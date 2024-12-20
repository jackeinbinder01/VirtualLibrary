USE virtual_library_db;

SET GLOBAL max_sp_recursion_depth = 64;

DROP PROCEDURE IF EXISTS LoginUser;
DELIMITER $$

-- Login User
CREATE PROCEDURE LoginUser (
    IN username_p VARCHAR(64),
    IN password_p VARCHAR(64)
)
BEGIN
    DECLARE stored_password VARCHAR(64);

    -- Retrieve the stored password for the given username
    SELECT password INTO stored_password
    FROM user
    WHERE user_name = username_p;

    -- Return the login status directly
    IF stored_password IS NULL THEN
        SELECT 'User Not Found' AS login_status;
    ELSEIF stored_password = password_p THEN
        SELECT 'Login Successful' AS login_status;
    ELSE
        SELECT 'Invalid Password' AS login_status;
    END IF;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS AddUser;
DELIMITER $$
-- Add User
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
    IN genreName_p VARCHAR(64),
    IN bookName_p VARCHAR(256),
    IN publisherName_p VARCHAR(128),
    IN authorName_p VARCHAR(128),
    IN seriesName_p VARCHAR(128),
    IN username_p VARCHAR(64)
)
BEGIN
    -- Create the FilteredBookList table if it doesn't exist
    CREATE TABLE IF NOT EXISTS FilteredBookList (
        username VARCHAR(64),
        book_id INT,
        book_title VARCHAR(256),
        release_date DATE,
        genres VARCHAR(256),
        publisher_name VARCHAR(128),
        author_name VARCHAR(128),
        series_name VARCHAR(128),
        rating INT,
        comments TEXT,
        PRIMARY KEY (username, book_id)
    );

    -- Delete existing data for this user
    DELETE FROM FilteredBookList WHERE username = username_p;

    -- Populate FilteredBookList with filtered data
    INSERT INTO FilteredBookList (username, book_id, book_title, release_date, genres, publisher_name, author_name, series_name, rating, comments)
    SELECT 
        username_p AS username,
        b.book_id,
        b.book_title,
        b.release_date,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres,
        p.publisher_name,
        a.author_name,
        s.series_name,
        br.score AS rating,
        br.text AS comments
    FROM book b
    LEFT JOIN book_genre bg ON b.book_id = bg.book_id
    LEFT JOIN genre g ON bg.genre_name = g.genre_name
    LEFT JOIN publisher p ON b.publisher_id = p.publisher_id
    LEFT JOIN author a ON b.author_id = a.author_id
    LEFT JOIN book_series bs ON b.book_id = bs.book_id
    LEFT JOIN series s ON bs.series_id = s.series_id
    LEFT JOIN book_rating br ON b.book_id = br.book_id AND br.user_name = username_p
    WHERE 
        (genreName_p IS NULL OR EXISTS (
            SELECT 1 FROM book_genre bg2 WHERE bg2.book_id = b.book_id AND bg2.genre_name = genreName_p
        )) AND
        (bookName_p IS NULL OR b.book_title = bookName_p) AND
        (publisherName_p IS NULL OR p.publisher_name = publisherName_p) AND
        (authorName_p IS NULL OR a.author_name = authorName_p) AND
        (seriesName_p IS NULL OR s.series_name = seriesName_p)
    GROUP BY b.book_id, b.book_title, b.release_date, p.publisher_name, a.author_name, s.series_name, br.score, br.text;

    -- Return the filtered list for the user
    SELECT * FROM FilteredBookList WHERE username = username_p;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS FilterOnFilteredList;
DELIMITER $$

CREATE PROCEDURE FilterOnFilteredList (
    IN genreName_p VARCHAR(64),
    IN bookName_p VARCHAR(256),
    IN publisherName_p VARCHAR(128),
    IN authorName_p VARCHAR(128),
    IN seriesName_p VARCHAR(128),
    IN username_p VARCHAR(64)
)
BEGIN
    -- Ensure FilteredBookList exists for this user
    IF NOT EXISTS (
        SELECT 1 FROM FilteredBookList WHERE username = username_p
    ) THEN
        SIGNAL SQLSTATE '02000' 
        SET MESSAGE_TEXT = 'FilteredBookList does not exist for this user. Run GetBooksByFilters first.';
    END IF;

    -- Create a temporary table to hold filtered results
    CREATE TEMPORARY TABLE TempFilteredList AS
    SELECT 
        username,
        book_id,
        book_title,
        release_date,
        genres,
        publisher_name,
        author_name,
        series_name,
        rating,
        comments
    FROM FilteredBookList
    WHERE username = username_p AND
        (genreName_p IS NULL OR FIND_IN_SET(genreName_p, genres)) AND
        (bookName_p IS NULL OR book_title = bookName_p) AND
        (publisherName_p IS NULL OR publisher_name = publisherName_p) AND
        (authorName_p IS NULL OR author_name = authorName_p) AND
        (seriesName_p IS NULL OR series_name = seriesName_p);

    -- Replace FilteredBookList with the filtered results for this user
    DELETE FROM FilteredBookList WHERE username = username_p;
    INSERT INTO FilteredBookList
    SELECT * FROM TempFilteredList;

    -- Drop the temporary table
    DROP TEMPORARY TABLE TempFilteredList;

    -- Return the updated FilteredBookList for the user
    SELECT * FROM FilteredBookList WHERE username = username_p;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS AddOrUpdateBookRating;
DELIMITER $$

-- Add or Update Book Rating
CREATE PROCEDURE AddOrUpdateBookRating (
    IN username_p VARCHAR(64),
    IN bookId_p INT,
    IN ratingText_p TEXT,
    IN ratingScore_p INT
)
BEGIN
    -- Ensure the rating is within the valid range
    IF ratingScore_p < 1 OR ratingScore_p > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating score must be between 1 and 5.';
    END IF;

    -- Check if the rating already exists
    IF EXISTS (
        SELECT 1 FROM book_rating
        WHERE user_name = username_p AND book_id = bookId_p
    ) THEN
        -- Update the existing rating
        UPDATE book_rating
        SET text = ratingText_p, score = ratingScore_p
        WHERE user_name = username_p AND book_id = bookId_p;
    ELSE
        -- Insert a new rating
        INSERT INTO book_rating (user_name, book_id, text, score)
        VALUES (username_p, bookId_p, ratingText_p, ratingScore_p);
    END IF;
END $$
DELIMITER ;
DROP PROCEDURE IF EXISTS DropFilteredList;
DELIMITER $$
-- Drop Filtered List
CREATE PROCEDURE DropFilteredList ()
BEGIN
    -- Drop the FilteredBookList table
    DROP TABLE IF EXISTS FilteredBookList;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS GetBookById;
DELIMITER $$
-- Get Book By ID
CREATE PROCEDURE GetBookById (
    IN bookId_p INT
)
BEGIN
    -- Select the book name and book ID for the given book ID
    SELECT book_id, book_title
    FROM book
    WHERE book_id = bookId_p;

    -- Handle cases where no book is found (optional)
    IF ROW_COUNT() = 0 THEN
        SELECT CONCAT('No book found with ID: ', bookId_p) AS message;
    END IF;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS CreateSubList;
DELIMITER $$

CREATE PROCEDURE CreateSubList (
    IN username_p VARCHAR(64),
    IN subListName_p VARCHAR(64),
    OUT subListStatus_p VARCHAR(32)
)
proc_block: BEGIN
    -- Check if the user exists
    IF NOT EXISTS (
        SELECT 1 FROM user WHERE user_name = username_p
    ) THEN
        SET subListStatus_p = 'User Not Found';
        LEAVE proc_block;
    END IF;

    -- Check if the sub-list already exists
    IF EXISTS (
        SELECT 1
        FROM user_book_list
        WHERE book_list_name = subListName_p
          AND user_name = username_p
    ) THEN
        SET subListStatus_p = 'Sub-List Already Exists';
    ELSE
        -- Create the sub-list
        INSERT INTO user_book_list (user_name, book_list_name)
        VALUES (username_p, subListName_p);

        SET subListStatus_p = 'Sub-List Created';
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
DROP PROCEDURE IF EXISTS RemoveBookFromUserList;
DELIMITER $$

CREATE PROCEDURE RemoveBookFromUserList (
    IN input_user_name VARCHAR(64),
    IN input_book_list_name VARCHAR(64),
    IN input_book_id INT
    
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

        
    END IF;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS return_list_name_of_user;



/*
Procedure to view a list of names of booklists associated with a specific user.
*/
DELIMITER $$
CREATE PROCEDURE return_list_name_of_user(user_name_p VARCHAR(64))
BEGIN
	SELECT bl.list_name
    FROM book_list bl
    WHERE bl.user_name = user_name_p;
END $$
DELIMITER ;
DROP PROCEDURE IF EXISTS fetch_books_in_list;
DELIMITER $$
CREATE PROCEDURE fetch_books_in_list(
    IN book_list_name_p VARCHAR(64),
    IN username_p VARCHAR(64)
)
BEGIN
    SELECT
        b.book_id,
        b.book_title,
        b.release_date,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres,
        a.author_name,
        p.publisher_name,
        s.series_name,
        br.score AS rating,
        br.text AS comments
    FROM book_list_book blb
    JOIN book_list bl ON blb.book_list_name = bl.list_name
    JOIN book b USING(book_id)
    LEFT JOIN book_genre bg USING(book_id)
    LEFT JOIN genre g USING(genre_name)
    LEFT JOIN author a USING(author_id)
    LEFT JOIN publisher p USING(publisher_id)
    LEFT JOIN book_series bs USING(book_id)
    LEFT JOIN series s USING(series_id)
    LEFT JOIN book_rating br 
        ON b.book_id = br.book_id AND br.user_name = username_p -- Filter by specific user
    WHERE bl.list_name = book_list_name_p
    GROUP BY b.book_id, b.book_title, b.release_date, a.author_name, p.publisher_name, s.series_name, br.score, br.text
    ORDER BY b.book_id;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS CreateUserBookList;

/*
Procedure that creates a new user book list
*/
DELIMITER $$
CREATE PROCEDURE CreateUserBookList(
    IN input_user_name VARCHAR(64),
    IN input_book_list_name VARCHAR(64)
)
proc_block: BEGIN
    -- Check if the user exists
    IF NOT EXISTS (
        SELECT 1 FROM user WHERE user_name = input_user_name
    ) THEN
        SELECT 'Error: User does not exist' AS status_message;
        LEAVE proc_block;
    END IF;

    -- Check if the book list already exists for the user
    IF EXISTS (
        SELECT 1 
        FROM book_list 
        WHERE list_name = input_book_list_name AND user_name = input_user_name
    ) THEN
        SELECT 'Error: Book List already exists for this user' AS status_message;
        LEAVE proc_block;
    END IF;

    -- Insert the new book list for the user
    INSERT INTO book_list (list_name, user_name)
    VALUES (input_book_list_name, input_user_name);

    SELECT 'Success: Book List Created Successfully' AS status_message;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS delete_book_list;
DELIMITER $$

CREATE PROCEDURE delete_book_list(
    IN input_user_name VARCHAR(64),
    IN input_book_list_name VARCHAR(64)
)
proc_block: BEGIN
    -- Check if the user exists
    IF NOT EXISTS (
        SELECT 1 FROM user WHERE user_name = input_user_name
    ) THEN
        SELECT 'Error: User does not exist' AS status_message;
        LEAVE proc_block;
    END IF;

    -- Check if the book list exists for the user
    IF NOT EXISTS (
        SELECT 1 
        FROM book_list 
        WHERE list_name = input_book_list_name AND user_name = input_user_name
    ) THEN
        SELECT 'Error: Book List does not exist for this user' AS status_message;
        LEAVE proc_block;
    END IF;

    -- Delete any related entries in other tables (e.g., book_list_book)
    DELETE FROM book_list_book WHERE book_list_name = input_book_list_name;

    -- Delete the book list
    DELETE FROM book_list WHERE list_name = input_book_list_name AND user_name = input_user_name;

    -- Return success message
    SELECT 'Success: Book List Deleted Successfully' AS status_message;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS FetchUserGenres;
DELIMITER $$

CREATE PROCEDURE FetchUserGenres(
    IN username_p VARCHAR(64)
)
BEGIN
    SELECT DISTINCT g.genre_name AS genres
    FROM book_list_book blb
    JOIN book_list bl ON blb.book_list_name = bl.list_name
    JOIN book_genre bg USING(book_id)
    JOIN genre g USING(genre_name)
    WHERE bl.user_name = username_p
    ORDER BY g.genre_name;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS CountUserBooks;
DELIMITER $$

CREATE PROCEDURE CountUserBooks(
    IN username_p VARCHAR(64)
)
BEGIN
    SELECT COUNT(DISTINCT blb.book_id) AS total_unique_books
    FROM book_list_book blb
    JOIN book_list bl ON blb.book_list_name = bl.list_name
    WHERE bl.user_name = username_p;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS MostReadGenre;
DELIMITER $$
CREATE PROCEDURE MostReadGenre(IN user_name_p VARCHAR(64))
BEGIN
    -- Find the maximum count of genres
    DECLARE max_count INT;

    SELECT MAX(genre_count) INTO max_count
    FROM (
        SELECT bg.genre_name, COUNT(*) AS genre_count
        FROM book_list_book blb
        JOIN book_genre bg ON blb.book_id = bg.book_id
        WHERE blb.user_name = user_name_p
        GROUP BY bg.genre_name
    ) AS genre_counts;

    -- Select all genres with the maximum count
    SELECT bg.genre_name, COUNT(*) AS count
    FROM book_list_book blb
    JOIN book_genre bg ON blb.book_id = bg.book_id
    WHERE blb.user_name = user_name_p
    GROUP BY bg.genre_name
    HAVING count = max_count
    ORDER BY bg.genre_name;
END $$
DELIMITER ;
DROP PROCEDURE IF EXISTS AuthorDiversity;
DELIMITER $$
CREATE PROCEDURE AuthorDiversity(IN user_name_p VARCHAR(64))
BEGIN
    SELECT COUNT(DISTINCT a.author_id) AS unique_authors
    FROM book_list_book blb
    JOIN book b ON blb.book_id = b.book_id
    JOIN author a ON b.author_id = a.author_id
    WHERE blb.user_name = user_name_p;
END $$
DELIMITER ;
DROP PROCEDURE IF EXISTS TopAuthor;
DELIMITER $$
CREATE PROCEDURE TopAuthor(IN user_name_p VARCHAR(64))
BEGIN
    SELECT a.author_name, COUNT(*) AS book_count
    FROM book_list_book blb
    JOIN book b ON blb.book_id = b.book_id
    JOIN author a ON b.author_id = a.author_id
    WHERE blb.user_name = user_name_p
    GROUP BY a.author_name
    ORDER BY book_count DESC
    LIMIT 1;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS GetBookFormatsAndURLs;
DELIMITER $$

CREATE PROCEDURE GetBookFormatsAndURLs (
    IN input_book_id INT
)
BEGIN
    SELECT 
        b.book_id,
        b.book_title,
        l.url AS format_url,
        l.format_type AS format_type
    FROM book b
    LEFT JOIN link l ON b.book_id = l.book_id
    WHERE b.book_id = input_book_id;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS add_book_to_series;
DELIMITER //

CREATE PROCEDURE add_book_to_series(book_title_p VARCHAR(256), release_date_p DATE, series_name_p VARCHAR(128))

BEGIN
    DECLARE book_id_v INT;
    DECLARE book_not_in_db_error VARCHAR(512);
    DECLARE book_already_in_series_error VARCHAR(512);
    DECLARE series_id_v INT;

    SET book_not_in_db_error = CONCAT('book: ', book_title_p, ', does not exist in the book table');
    SET book_already_in_series_error = CONCAT('book: ', book_title_p, ', is already associated with the series: ',
                                              series_name_p, '.');

    IF EXISTS (
        SELECT
            1
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
    ) THEN
        SET book_id_v = (SELECT book_id FROM book WHERE book_title = book_title_p AND release_date = release_date_p);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_not_in_db_error;
    END IF ;

    IF NOT EXISTS(
        SELECT
            1
        FROM series s
        WHERE 1=1
            AND s.series_name = series_name_p
    ) THEN
        INSERT INTO series (series_name)
        VALUES (series_name_p);
    END IF ;

    SET series_id_v = (SELECT series_id FROM series WHERE series_name = series_name_p);

    IF EXISTS (
        SELECT
            1
        FROM book_series bs
        WHERE 1=1
            AND bs.series_id = series_id_v
            AND bs.book_id = book_id_v
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_already_in_series_error;
    ELSE
        INSERT INTO book_series (book_id, series_id)
        VALUES (book_id_v, series_id_v);
    END IF ;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_book_to_user_list;
DELIMITER //
CREATE PROCEDURE add_book_to_user_list(user_name_p VARCHAR(64), book_list_name_p VARCHAR(64),
                                       book_title_p VARCHAR(256), release_date_p DATE)

BEGIN

    DECLARE book_in_book_list_error VARCHAR(512);
    DECLARE book_id_v INT;

    SET book_in_book_list_error = CONCAT('book: ', book_title_p, ', is already in booklist: ', book_list_name_p, '.');

    IF EXISTS (
        SELECT
            1
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
    ) THEN
        SET book_id_v = (SELECT book_id FROM book WHERE book_title = book_title_p AND release_date = release_date_p);
    END IF ;

    IF NOT EXISTS (
        SELECT
            1 AS 'book_list_in_db'
        FROM book_list bl
        WHERE 1=1
            AND bl.list_name = book_list_name_p
            AND bl.user_name = user_name_p
    ) THEN
        INSERT INTO book_list (list_name, user_name)
        VALUES (book_list_name_p, user_name_p);
    END IF ;

    IF EXISTS (
        SELECT
            1 AS 'book_in_book_list'
        FROM book_list_book blb
        WHERE 1=1
            AND blb.book_list_name = book_list_name_p
            AND blb.user_name = user_name_p
            AND blb.book_id = book_id_v
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_in_book_list_error;
    ELSE
        INSERT INTO book_list_book (book_list_name, user_name, book_id)
        VALUES (book_list_name_p, user_name_p, book_id_v);
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_book;
DELIMITER //

CREATE PROCEDURE add_book(book_title_p VARCHAR(256), author_id_p INT,
                          publisher_id_p INT, release_date_p DATE)

BEGIN
    DECLARE book_in_db_error VARCHAR(64);
    DECLARE future_release_date_error VARCHAR(128);

    SET book_in_db_error = CONCAT('Book: ', book_title_p, ', already exists in the book table.');
    SET future_release_date_error = CONCAT('Future release date: , ', release_date_p, ', is invalid.');

    IF release_date_p > NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = future_release_date_error;
    ELSEIF EXISTS (
        SELECT
            1 AS 'book in db'
        FROM book b
        WHERE 1=1
        AND b.book_title = book_title_p
        AND b.release_date = release_date_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_in_db_error;
    ELSE
        INSERT INTO book(book_title, author_id, publisher_id, release_date)
        VALUES (book_title_p, author_id_p, publisher_id_p, release_date_p);
    END IF;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_genre_to_book;
DELIMITER //

CREATE PROCEDURE add_genre_to_book(book_title_p VARCHAR(256), release_date_p DATE, genre_name_p VARCHAR(64))
BEGIN
    DECLARE book_not_in_db_error VARCHAR(512);
    DECLARE book_id_v INT;
    DECLARE blank_param_error VARCHAR(32);
    DECLARE book_genre_in_db VARCHAR(512);

    SET book_not_in_db_error = CONCAT('book: ', book_title_p, ', does not exist in the book table');
    SET blank_param_error = ('No parameters can be empty');
    SET book_genre_in_db = CONCAT('book: ', book_title_p, ', with genre: ', genre_name_p,
                                  ', is already in book_genre table');

    IF book_title_p = '' OR genre_name_p = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = blank_param_error;
    ELSEIF NOT EXISTS (
        SELECT
            1 AS 'book in db'
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_not_in_db_error;
    ELSEIF NOT EXISTS(
        SELECT
            1 AS 'genre_in_genres'
        FROM genre g
        WHERE 1=1
            AND g.genre_name = genre_name_p
    ) THEN
        INSERT INTO genre (genre_name)
        VALUES (genre_name_p);
    END IF;

    SET book_id_v = (
        SELECT
            b.book_id
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
        );

    IF EXISTS (
        SELECT
            1
        FROM book_genre bg
        WHERE 1=1
            AND bg.book_id = book_id_v
            AND bg.genre_name = genre_name_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_genre_in_db;
    ELSE
        INSERT INTO book_genre (book_id, genre_name)
        VALUES (book_id_v, genre_name_p);
    END IF;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_book_from_import;
DELIMITER //

-- Adds a book to the book table
CREATE PROCEDURE add_book_from_import(book_title_p VARCHAR(256), author_name_p VARCHAR(128),
                          author_email_p VARCHAR(64), publisher_name_p VARCHAR(128), publisher_email_p VARCHAR(64),
                          release_date_p DATE)

BEGIN

    DECLARE author_id_v INT;
    DECLARE publisher_id_v INT;

    IF NOT EXISTS (
        SELECT
            1
        FROM author a
        WHERE a.author_name = author_name_p
    ) THEN
        CALL add_author(author_name_p, author_email_p);
    END IF ;
    IF NOT EXISTS (
        SELECT
            1
        FROM publisher p
        WHERE p.publisher_name = publisher_name_p
    ) THEN
        CALL add_publisher(publisher_name_p, publisher_email_p);
    END IF ;

    SET author_id_v = (
        SELECT
            author_id
        FROM author a
        WHERE a.author_name = author_name_p
    );

    SET publisher_id_v = (
        SELECT
            publisher_id
        FROM publisher a
        WHERE a.publisher_name = publisher_name_p
    );

    IF NOT EXISTS (
        SELECT
            1
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
    ) THEN
        CALL add_book(book_title_p, author_id_v, publisher_id_v, release_date_p);
    END IF ;

END //
DELIMITER ;

DROP PROCEDURE IF EXISTS add_author;

DELIMITER //
CREATE PROCEDURE add_author(author_name_p VARCHAR(128), author_email_p VARCHAR(64))

BEGIN

    DECLARE author_in_db_error VARCHAR(256);
    DECLARE blank_author_error VARCHAR(64);

    SET author_in_db_error = CONCAT('Author: ', author_name_p, ', already exists in author table.');
    SET blank_author_error = CONCAT('Author name cannot be blank.');

    IF author_name_p = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = blank_author_error;
    ELSEIF EXISTS (
        SELECT
            1 AS 'author in db'
        FROM author a
        WHERE 1=1
        AND a.author_name = author_name_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = author_in_db_error;
    ELSEIF author_email_p = '' THEN
        INSERT INTO author (author_name, email_address)
        VALUES (author_name_p, NULL);
    ELSE
        INSERT INTO author (author_name, email_address)
        VALUES (author_name_p, author_email_p);
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_publisher;

DELIMITER //
CREATE PROCEDURE add_publisher(publisher_name_p VARCHAR(128), publisher_email_p VARCHAR(64))

BEGIN

    DECLARE publisher_in_db_error VARCHAR(256);
    DECLARE blank_publisher_error VARCHAR(64);

    SET publisher_in_db_error = CONCAT('Publisher: ', publisher_name_p, ', already exists in publisher table.');
    SET blank_publisher_error = CONCAT('Publisher name cannot be blank.');

    IF publisher_name_p = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = blank_publisher_error;
    ELSEIF EXISTS (
        SELECT
            1 AS 'publisher in db'
        FROM publisher p
        WHERE 1=1
        AND p.publisher_name = publisher_name_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = publisher_in_db_error;
    ELSEIF publisher_email_p = '' THEN
        INSERT INTO publisher (publisher_name, email_address)
        VALUES (publisher_name_p, NULL);
    ELSE
        INSERT INTO publisher (publisher_name, email_address)
        VALUES (publisher_name_p, publisher_email_p);
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_link;

DELIMITER //
CREATE PROCEDURE add_link(url_p VARCHAR(512), format_type_p VARCHAR(64),
                          book_title_p VARCHAR(256), release_date_p DATE)

BEGIN
    DECLARE url_in_db_error VARCHAR(256);
    DECLARE invalid_format_error VARCHAR(256);
    DECLARE invalid_book_title VARCHAR(256);
    DECLARE book_id_v INT;

	SET url_in_db_error = CONCAT('url: ', url_p, ', already exists in the link table.');
	SET invalid_format_error = CONCAT('book format type: ',
                                      format_type_p,
                                      ', is invalid. Please enter either: Hardcover, Paperback, PDF, eBook, or Audiobook.');
    SET invalid_book_title = CONCAT('book title: ', book_title_p, ', does not exist in the book table.');

    IF EXISTS (
        SELECT
            1 AS 'link in db'
        FROM link l
        WHERE 1=1
        AND l.url = url_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = url_in_db_error;
    ELSEIF format_type_p NOT IN ('Hardcover', 'Paperback', 'PDF', 'eBook', 'Audiobook') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = invalid_format_error;
    ELSEIF NOT EXISTS (
        SELECT
            1 AS 'book_id in db'
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = invalid_book_title;
    ELSE
        SET book_id_v = (
            SELECT
                b.book_id
            FROM book b
            WHERE 1=1
                AND b.book_title = book_title_p
                AND b.release_date = release_date_p
            );

        INSERT INTO link (url, format_type, book_id)
        VALUES (url_p, format_type_p, book_id_v);

    END IF;

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS delete_user;
DELIMITER //

CREATE PROCEDURE delete_user(username_p VARCHAR(64))

BEGIN
    DECLARE username_not_in_db_error VARCHAR(64);
    SET username_not_in_db_error = CONCAT('User, ', username_p, ', does not exist');

    IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = username_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = username_not_in_db_error;
    ELSE
        DELETE FROM user u WHERE u.user_name = username_p;
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS make_user_admin;
DELIMITER //

CREATE PROCEDURE make_user_admin(username_p VARCHAR(64))

BEGIN
    DECLARE username_not_in_db_error VARCHAR(64);
    DECLARE user_already_admin VARCHAR(64);
    SET username_not_in_db_error = CONCAT('User, ', username_p, ', does not exist');
    SET user_already_admin = CONCAT('User, ', username_p, ', is already an Admin');

    IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = username_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = username_not_in_db_error;
    ELSEIF EXISTS (
        SELECT
            1
        FROM user u
        WHERE 1=1
            AND u.user_name = username_p
            AND u.is_admin = TRUE
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = user_already_admin;
	ELSE
        UPDATE user u
            SET u.is_admin = TRUE
        WHERE 1=1
            AND u.user_name = username_p
            AND u.is_admin = FALSE;
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS demote_user_from_admin;
DELIMITER //

CREATE PROCEDURE demote_user_from_admin(username_p VARCHAR(64))

BEGIN
    DECLARE username_not_in_db_error VARCHAR(64);
    DECLARE user_not_admin VARCHAR(64);
    SET username_not_in_db_error = CONCAT('User, ', username_p, ', does not exist');
    SET user_not_admin = CONCAT('User, ', username_p, ', was not an Admin');

    IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = username_p
	    ) THEN
	        SIGNAL SQLSTATE '45000'
	        SET MESSAGE_TEXT = username_not_in_db_error;
    ELSEIF EXISTS (
        SELECT
            1
        FROM user u
        WHERE 1=1
            AND u.user_name = username_p
            AND u.is_admin = FALSE
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = user_not_admin;
	ELSE
        UPDATE user u
            SET u.is_admin = FALSE
        WHERE 1=1
            AND u.user_name = username_p
            AND u.is_admin = TRUE;
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS update_username;
DELIMITER //

CREATE PROCEDURE update_username(old_username_p VARCHAR(64), new_username_p VARCHAR(64))

BEGIN
	 DECLARE username_not_in_db_error VARCHAR(64);
	 SET username_not_in_db_error = CONCAT('User, ', old_username_p, ', does not exist');

	 IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = old_username_p
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = username_not_in_db_error;
     ELSE
	     UPDATE user u
	        SET u.user_name = new_username_p
	     WHERE u.user_name = old_username_p;
	 END IF;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS update_password;
DELIMITER //

CREATE PROCEDURE update_password(username_p VARCHAR(64), new_password_p VARCHAR(64))

BEGIN
	 DECLARE username_not_in_db_error VARCHAR(64);
	 SET username_not_in_db_error = CONCAT('User, ', username_p, ', does not exist');

	 IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = username_p
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = username_not_in_db_error;
     ELSE
	     UPDATE user u
	        SET u.password = new_password_p
	     WHERE u.user_name = username_p;
	 END IF;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS view_users;
DELIMITER //

CREATE PROCEDURE view_users()
    BEGIN
        SELECT
            u.user_name
            , u.is_admin
        FROM user u;
    END //

DELIMITER ;

DROP FUNCTION IF EXISTS is_user_admin;
DELIMITER //

CREATE FUNCTION is_user_admin(username_p VARCHAR(64))
RETURNS BOOL
READS SQL DATA
BEGIN
    DECLARE is_admin BOOL;

    IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = username_p
            AND u.is_admin = TRUE
    ) THEN
        SET is_admin = FALSE;
    ELSE
        SET is_admin = TRUE;
    END IF;

    RETURN is_admin;
END //

DELIMITER ;



