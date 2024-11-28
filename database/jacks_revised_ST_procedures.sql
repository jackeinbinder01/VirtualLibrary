USE virtual_library_db;
-- this tracks Sebastians Procedures

DROP PROCEDURE IF EXISTS LoginUser;
DELIMITER $$

CREATE PROCEDURE LoginUser (
    IN i_username VARCHAR(64),
    IN i_password VARCHAR(64)
)
BEGIN
    DECLARE stored_password VARCHAR(64);

    -- Retrieve the stored password for the given username
    SELECT password INTO stored_password
    FROM user
    WHERE user_name = i_username;

    -- Return the login status directly
    IF stored_password IS NULL THEN
        SELECT 'User Not Found' AS login_status;
    ELSEIF stored_password = i_password THEN
        SELECT 'Login Successful' AS login_status;
    ELSE
        SELECT 'Invalid Password' AS login_status;
    END IF;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS AddUser;
DELIMITER $$
-- adds user to the DB
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
        VALUES (username_p, password_p);
    END IF;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS GetBooksByFilters;
DELIMITER $$

CREATE PROCEDURE GetBooksByFilters (
    IN genreName VARCHAR(64),
    IN bookName VARCHAR(256),
    IN publisherName VARCHAR(128),
    IN authorName VARCHAR(128),
    IN seriesName VARCHAR(128)
)
BEGIN
    -- Create the FilteredBookList table if it doesn't exist
    CREATE TABLE IF NOT EXISTS FilteredBookList (
        book_id INT,
        book_title VARCHAR(256),
        release_date DATE,
        genreName VARCHAR(64),
        publisherName VARCHAR(128),
        authorName VARCHAR(128),
        seriesName VARCHAR(128)
    );

    -- Clear existing data in FilteredBookList
    TRUNCATE TABLE FilteredBookList;

    -- Populate FilteredBookList with initial filters
    INSERT INTO FilteredBookList (book_id, book_title, release_date, genreName, publisherName, authorName, seriesName)
    SELECT DISTINCT
        b.book_id,
        b.book_title,
        b.release_date,
        bg.genre_name AS genreName,
        p.publisher_name AS publisherName,
        a.author_name AS authorName,
        s.series_name AS seriesName
    FROM book b
    LEFT JOIN book_genre bg ON b.book_id = bg.book_id
    LEFT JOIN publisher p ON b.publisher_id = p.publisher_id
    LEFT JOIN author a ON b.author_id = a.author_id
    LEFT JOIN book_series bs ON b.book_id = bs.book_id
    LEFT JOIN series s ON bs.series_id = s.series_id
    WHERE
        (genreName IS NULL OR bg.genre_name = genreName) AND
        (bookName IS NULL OR b.book_title = bookName) AND
        (publisherName IS NULL OR p.publisher_name = publisherName) AND
        (authorName IS NULL OR a.author_name = authorName) AND
        (seriesName IS NULL OR s.series_name = seriesName);

    -- Return the contents of FilteredBookList
    SELECT * FROM FilteredBookList;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS FilterOnFilteredList;
DELIMITER $$

CREATE PROCEDURE FilterOnFilteredList (
    IN genreName VARCHAR(64),
    IN bookName VARCHAR(256),
    IN publisherName VARCHAR(128),
    IN authorName VARCHAR(128),
    IN seriesName VARCHAR(128)
)
BEGIN
    -- Ensure FilteredBookList exists
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'FilteredBookList' AND table_schema = DATABASE()) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'FilteredBookList does not exist.';
    END IF;

    -- Create a temporary table to hold filtered results
    CREATE TEMPORARY TABLE TempFilteredList AS
    SELECT DISTINCT
        book_id,
        book_title,
        release_date,
        genreName,
        publisherName,
        authorName,
        seriesName
    FROM FilteredBookList
    WHERE
        (genreName IS NULL OR genreName = genreName) AND
        (bookName IS NULL OR book_title = bookName) AND
        (publisherName IS NULL OR publisherName = publisherName) AND
        (authorName IS NULL OR authorName = authorName) AND
        (seriesName IS NULL OR seriesName = seriesName);

    -- Replace the FilteredBookList with the filtered results
    TRUNCATE TABLE FilteredBookList;
    INSERT INTO FilteredBookList SELECT * FROM TempFilteredList;

    -- Drop the temporary table
    DROP TEMPORARY TABLE TempFilteredList;

    -- Return the updated FilteredBookList
    SELECT * FROM FilteredBookList;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS AddOrUpdateBookRating;
DELIMITER $$

CREATE PROCEDURE AddOrUpdateBookRating (
    IN input_user_name VARCHAR(64),
    IN input_book_id INT,
    IN input_score INT,
    IN input_text TEXT
)
BEGIN
    DECLARE rating_status VARCHAR(32);

    -- Check that the score is valid
    IF input_score < 1 OR input_score > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Score must be between 1 and 5';
    END IF;

    -- Check if the user already has a rating for the book
    IF EXISTS (
        SELECT 1
        FROM book_rating
        WHERE user_name = input_user_name AND book_id = input_book_id
    ) THEN
        -- Update the existing rating and review
        UPDATE book_rating
        SET score = input_score, text = input_text
        WHERE user_name = input_user_name AND book_id = input_book_id;

        SET rating_status = 'Rating Updated';
    ELSE
        -- Add a new rating and review
        INSERT INTO book_rating (user_name, book_id, text, score)
        VALUES (input_user_name, input_book_id, input_text, input_score);

        SET rating_status = 'Rating Added';
    END IF;

    -- Return the status
    SELECT rating_status AS operation_status;
END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS CreateSubList;
DELIMITER ;
DELIMITER $$

CREATE PROCEDURE CreateSubList (
    IN input_user_name VARCHAR(64),
    IN input_sub_list_name VARCHAR(64),
    OUT sub_list_status VARCHAR(32)
)
proc_block: BEGIN
    -- Check if the user exists
    IF NOT EXISTS (
        SELECT 1 FROM user WHERE user_name = input_user_name
    ) THEN
        SET sub_list_status = 'User Not Found';
        LEAVE proc_block;
    END IF;

    -- Check if the sub-list already exists
    IF EXISTS (
        SELECT 1
        FROM book_list
        WHERE list_name = input_sub_list_name
          AND user_name = input_user_name
    ) THEN
        SET sub_list_status = 'Sub-List Already Exists';
    ELSE
        -- Create the sub-list
        INSERT INTO book_list (user_name, list_name)
        VALUES (input_user_name, input_sub_list_name);

        SET sub_list_status = 'Sub-List Created';
    END IF;

END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS AddBookToSubList;
DELIMITER $$

CREATE PROCEDURE AddBookToSubList (
    IN input_user_name VARCHAR(64),
    IN input_sub_list_name VARCHAR(64),
    IN input_book_id INT,
    OUT book_add_status VARCHAR(32)
)
proc_block: BEGIN
    -- Check if the user exists
    IF NOT EXISTS (
        SELECT 1 FROM user WHERE user_name = input_user_name
    ) THEN
        SET book_add_status = 'User Not Found';
        LEAVE proc_block;
    END IF;

    -- Check if the sub-list exists for the user
    IF NOT EXISTS (
        SELECT 1
        FROM book_list
        WHERE user_name = input_user_name
          AND list_name = input_sub_list_name
    ) THEN
        SET book_add_status = 'Sub-List Not Found';
        LEAVE proc_block;
    END IF;

    -- Check if the book exists
    IF NOT EXISTS (
        SELECT 1 FROM book WHERE book_id = input_book_id
    ) THEN
        SET book_add_status = 'Book Not Found';
        LEAVE proc_block;
    END IF;

    -- Check if the book is already in the sub-list
    IF EXISTS (
        SELECT 1
        FROM book_list_book blb
        WHERE blb.book_list_name = input_sub_list_name
          AND blb.book_id = input_book_id
    ) THEN
        SET book_add_status = 'Book Already in Sub-List';
    ELSE
        -- Add the book to the sub-list
        INSERT INTO book_list_book (book_list_name, user_name, book_id)
        VALUES (input_sub_list_name, input_user_name, input_book_id);

        SET book_add_status = 'Book Added to Sub-List';
    END IF;

END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS DropFilteredList;
DELIMITER $$

CREATE PROCEDURE DropFilteredList ()
BEGIN
    -- Drop the FilteredBookList table
    DROP TABLE IF EXISTS FilteredBookList;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS GetBookById;
DELIMITER $$

CREATE PROCEDURE GetBookById (
    IN input_book_id INT
)
BEGIN
    -- Select the book name and book ID for the given book ID
    SELECT book_id, book_title
    FROM book
    WHERE book_id = input_book_id;

    -- Handle cases where no book is found (optional)
    IF ROW_COUNT() = 0 THEN
        SELECT CONCAT('No book found with ID: ', input_book_id) AS message;
    END IF;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS RemoveBookFromUserList;
DELIMITER $$

CREATE PROCEDURE RemoveBookFromUserList (
    IN input_user_name VARCHAR(64),
    IN input_book_list_name VARCHAR(64),
    IN input_book_id INT,
    OUT remove_status VARCHAR(32)
)
BEGIN
    -- Check if the book exists in the user's list
    IF EXISTS (
        SELECT 1
        FROM book_list_book blb
        JOIN book_list bl ON blb.book_list_name = bl.list_name
        WHERE bl.user_name = input_user_name
          AND bl.list_name = input_book_list_name
          AND blb.book_id = input_book_id
    ) THEN
        -- Remove the book from the list
        DELETE blb
        FROM book_list_book blb
        JOIN book_list bl ON blb.book_list_name = bl.list_name
        WHERE bl.user_name = input_user_name
          AND bl.list_name = input_book_list_name
          AND blb.book_id = input_book_id;

        SET remove_status = 'Book Removed Successfully from List';
    ELSE
        -- If the book doesn't exist in the specified list, set status
        SET remove_status = 'Book Not Found in Specified List';
    END IF;
END $$

DELIMITER ;




