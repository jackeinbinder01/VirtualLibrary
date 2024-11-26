USE virtual_library_db;
-- this tracks Sebastians Procedures


DELIMITER $$
-- logs in to a user
CREATE PROCEDURE LoginUser (
    IN input_username VARCHAR(64),
    IN input_password VARCHAR(64),
    OUT login_status VARCHAR(16)
)
BEGIN
    DECLARE stored_password VARCHAR(64);

    -- Retrieve the stored password for the given username
    SELECT password INTO stored_password
    FROM user
    WHERE user_name = input_username;

    -- Check if the username exists and the password matches
    IF stored_password IS NULL THEN
        SET login_status = 'User Not Found';
    ELSEIF stored_password = input_password THEN
        SET login_status = 'Login Successful';
    ELSE
        SET login_status = 'Invalid Password';
    END IF;
END $$

DELIMITER ;




DELIMITER $$
-- adds a user to the DB
CREATE PROCEDURE AddUser (
    IN username_p VARCHAR(64),
    IN password_p VARCHAR(64)
)
BEGIN
    -- Check if the username already exists
    IF EXISTS (SELECT 1 FROM user WHERE user_name = username_p) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username already exists';
    ELSE
        -- Insert the new user
        INSERT INTO user (user_name, password)
        VALUES (username, password_p);
    END IF;
END $$

DELIMITER ;




DELIMITER $$

CREATE PROCEDURE GetBooksByFilters (
    IN genreName VARCHAR(32),
    IN bookName VARCHAR(128),
    IN publisherName VARCHAR(128),
    IN authorName VARCHAR(128),
    IN seriesName VARCHAR(128)
)
BEGIN
    -- Create a temporary table for the user's current list
    CREATE TEMPORARY TABLE IF NOT EXISTS CurrentBookList AS
    SELECT DISTINCT b.book_id, b.book_title, b.release_date, b.description
    FROM book b
    LEFT JOIN book_genre bg ON b.book_id = bg.book_id
    LEFT JOIN book_publisher bp ON b.book_id = bp.book_id
    LEFT JOIN publisher p ON bp.publisher_id = p.publisher_id
    LEFT JOIN book_author ba ON b.book_id = ba.book_id
    LEFT JOIN author a ON ba.author_id = a.author_id
    LEFT JOIN book_series bs ON b.book_id = bs.book_id
    LEFT JOIN series s ON bs.series_id = s.series_id
    WHERE 
        (genreName IS NULL OR bg.genre_name = genreName) AND
        (bookName IS NULL OR b.book_title = bookName) AND
        (publisherName IS NULL OR p.publisher_name = publisherName) AND
        (authorName IS NULL OR CONCAT(a.first_name, ' ', a.last_name) = authorName) AND
        (seriesName IS NULL OR s.series_name = seriesName);
END $$

DELIMITER ;


DELIMITER //
-- filters on a already filtered list.
CREATE PROCEDURE FilterCurrentList (
    IN genreName VARCHAR(32),
    IN bookName VARCHAR(128),
    IN publisherName VARCHAR(128),
    IN authorName VARCHAR(128),
    IN seriesName VARCHAR(128)
)
BEGIN
    -- Apply additional filters on the temporary table
    CREATE TEMPORARY TABLE IF NOT EXISTS FilteredBookList AS
    SELECT DISTINCT *
    FROM CurrentBookList c
    LEFT JOIN book_genre bg ON c.book_id = bg.book_id
    LEFT JOIN book_publisher bp ON c.book_id = bp.book_id
    LEFT JOIN publisher p ON bp.publisher_id = p.publisher_id
    LEFT JOIN book_author ba ON c.book_id = ba.book_id
    LEFT JOIN author a ON ba.author_id = a.author_id
    LEFT JOIN book_series bs ON c.book_id = bs.book_id
    LEFT JOIN series s ON bs.series_id = s.series_id
    WHERE 
        (genreName IS NULL OR bg.genre_name = genreName) AND
        (bookName IS NULL OR c.book_title = bookName) AND
        (publisherName IS NULL OR p.publisher_name = publisherName) AND
        (authorName IS NULL OR CONCAT(a.first_name, ' ', a.last_name) = authorName) AND
        (seriesName IS NULL OR s.series_name = seriesName);

    -- Replace the current list with the filtered list
    DROP TEMPORARY TABLE IF EXISTS CurrentBookList;
    RENAME TABLE FilteredBookList TO CurrentBookList;
END //

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE ViewCurrentList ()
BEGIN
    SELECT * FROM CurrentBookList;
END $$

DELIMITER ;


DELIMITER $$
-- allows for comments to be made
CREATE PROCEDURE AddOrUpdateBookRating (
    IN input_user_name VARCHAR(64),
    IN input_book_id INT,
    IN input_score INT,
    IN input_text TEXT,
    OUT rating_status VARCHAR(32)
)
BEGIN
    -- Check if the user already has a rating for the book
    IF EXISTS (
        SELECT 1
        FROM user_book_rating
        WHERE user_name = input_user_name AND book_id = input_book_id
    ) THEN
        -- Update the existing rating and review
        UPDATE user_book_rating
        SET score = input_score, text = input_text
        WHERE user_name = input_user_name AND book_id = input_book_id;
        
        SET rating_status = 'Rating Updated';
    ELSE
        -- Add a new rating and review
        INSERT INTO user_book_rating (user_name, book_id, text, score)
        VALUES (input_user_name, input_book_id, input_text, input_score);
        
        SET rating_status = 'Rating Added';
    END IF;
END $$

DELIMITER ;

DELIMITER $$
-- creates a sublist for user
CREATE PROCEDURE CreateSubList (
    IN input_user_name VARCHAR(64),
    IN input_parent_list_name VARCHAR(64),
    IN input_sub_list_name VARCHAR(64),
    OUT sub_list_status VARCHAR(32)
)
BEGIN
    -- Check if the sub-list already exists for the user and parent list
    IF EXISTS (
        SELECT 1
        FROM user_book_list
        WHERE book_list_name = input_sub_list_name
          AND parent_list_name = input_parent_list_name
          AND user_name = input_user_name
    ) THEN
        SET sub_list_status = 'Sub-List Already Exists';
    ELSE
        -- Create the sub-list
        INSERT INTO user_book_list (user_name, book_list_name, parent_list_name)
        VALUES (input_user_name, input_sub_list_name, input_parent_list_name);
        
        SET sub_list_status = 'Sub-List Created';
    END IF;
END $$

DELIMITER ;

DELIMITER $$
-- adds books to a sublist
CREATE PROCEDURE AddBookToSubList (
    IN input_user_name VARCHAR(64),
    IN input_sub_list_name VARCHAR(64),
    IN input_book_id INT,
    OUT book_add_status VARCHAR(32)
)
BEGIN
    -- Check if the book is already in the sub-list
    IF EXISTS (
        SELECT 1
        FROM book_list_book blb
        JOIN user_book_list ubl ON blb.book_list_name = ubl.book_list_name
        WHERE ubl.user_name = input_user_name
          AND ubl.book_list_name = input_sub_list_name
          AND blb.book_id = input_book_id
    ) THEN
        SET book_add_status = 'Book Already in Sub-List';
    ELSE
        -- Add the book to the sub-list
        INSERT INTO book_list_book (book_list_name, book_id)
        VALUES (input_sub_list_name, input_book_id);
        
        SET book_add_status = 'Book Added to Sub-List';
    END IF;
END $$

DELIMITER ;


