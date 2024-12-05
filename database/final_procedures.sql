USE virtual_library_db;

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
DELIMITER $$

CREATE PROCEDURE GetBooksByFilters (
    IN genreName_p VARCHAR(64),
    IN bookName_p VARCHAR(256),
    IN publisherName_p VARCHAR(128),
    IN authorName_p VARCHAR(128),
    IN seriesName_p VARCHAR(128)
)
BEGIN
    -- Ensure the FilteredBookList table exists
    CREATE TABLE IF NOT EXISTS FilteredBookList (
        book_id INT,
        book_title VARCHAR(256),
        release_date DATE,
        genres VARCHAR(256),
        publisher_name VARCHAR(128),
        author_name VARCHAR(128),
        series_name VARCHAR(128)
    );

    -- Clear existing data in FilteredBookList
    TRUNCATE TABLE FilteredBookList;

    -- Populate FilteredBookList with filtered data
    INSERT INTO FilteredBookList (book_id, book_title, release_date, genres, publisher_name, author_name, series_name)
    SELECT 
        b.book_id, 
        b.book_title, 
        b.release_date,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres,
        p.publisher_name,
        a.author_name,
        s.series_name
    FROM book b
    LEFT JOIN book_genre bg ON b.book_id = bg.book_id
    LEFT JOIN genre g ON bg.genre_name = g.genre_name
    LEFT JOIN publisher p ON b.publisher_id = p.publisher_id
    LEFT JOIN author a ON b.author_id = a.author_id
    LEFT JOIN book_series bs ON b.book_id = bs.book_id
    LEFT JOIN series s ON bs.series_id = s.series_id
    WHERE 
        (genreName_p IS NULL OR EXISTS (
            SELECT 1 
            FROM book_genre bg2
            WHERE bg2.book_id = b.book_id AND bg2.genre_name = genreName_p
        )) AND
        (bookName_p IS NULL OR b.book_title = bookName_p) AND
        (publisherName_p IS NULL OR p.publisher_name = publisherName_p) AND
        (authorName_p IS NULL OR a.author_name = authorName_p) AND
        (seriesName_p IS NULL OR s.series_name = seriesName_p)
    GROUP BY b.book_id, b.book_title, b.release_date, p.publisher_name, a.author_name, s.series_name;

    -- Return the contents of FilteredBookList
    SELECT * FROM FilteredBookList;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE FilterOnFilteredList (
    IN genreName_p VARCHAR(64),
    IN bookName_p VARCHAR(256),
    IN publisherName_p VARCHAR(128),
    IN authorName_p VARCHAR(128),
    IN seriesName_p VARCHAR(128)
)
BEGIN
    -- Ensure FilteredBookList exists
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.tables 
        WHERE table_name = 'FilteredBookList' AND table_schema = DATABASE()
    ) THEN
        SIGNAL SQLSTATE '02000' 
        SET MESSAGE_TEXT = 'FilteredBookList does not exist.';
    END IF;

    -- Create a working table to hold the filtered results
    CREATE TABLE IF NOT EXISTS WorkingFilteredList (
        book_id INT,
        book_title VARCHAR(256),
        release_date DATE,
        genres VARCHAR(256), -- Aggregated genres
        publisher_name VARCHAR(128),
        author_name VARCHAR(128),
        series_name VARCHAR(128)
    );

    -- Clear the working table
    TRUNCATE TABLE WorkingFilteredList;

    -- Populate the working table with aggregated genres
    INSERT INTO WorkingFilteredList (book_id, book_title, release_date, genres, publisher_name, author_name, series_name)
    SELECT 
        book_id, 
        book_title, 
        release_date,
        GROUP_CONCAT(DISTINCT genre_name ORDER BY genre_name SEPARATOR ', ') AS genres, -- Aggregate genres
        publisher_name,
        author_name,
        series_name
    FROM FilteredBookList
    WHERE 
        (genreName_p IS NULL OR FIND_IN_SET(genreName_p, genre_name)) AND -- Match genre within aggregated genres
        (bookName_p IS NULL OR book_title = bookName_p) AND
        (publisherName_p IS NULL OR publisher_name = publisherName_p) AND
        (authorName_p IS NULL OR author_name = authorName_p) AND
        (seriesName_p IS NULL OR series_name = seriesName_p)
    GROUP BY book_id, book_title, release_date, publisher_name, author_name, series_name;

    -- Replace FilteredBookList with the filtered results
    TRUNCATE TABLE FilteredBookList;
    INSERT INTO FilteredBookList (book_id, book_title, release_date, genre_name, publisher_name, author_name, series_name)
    SELECT 
        book_id, 
        book_title, 
        release_date, 
        genres AS genre_name, -- Store aggregated genres in FilteredBookList
        publisher_name, 
        author_name, 
        series_name 
    FROM WorkingFilteredList;

    -- Drop the working table (optional if you want it only temporary)
    DROP TABLE IF EXISTS WorkingFilteredList;

    -- Return the updated FilteredBookList
    SELECT * FROM FilteredBookList;
END $$

DELIMITER ;
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


DELIMITER $$
-- Drop Filtered List
CREATE PROCEDURE DropFilteredList ()
BEGIN
    -- Drop the FilteredBookList table
    DROP TABLE IF EXISTS FilteredBookList;
END $$

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

USE virtual_library_db;

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

/*
Test cases:
*/
CALL return_list_name_of_user('bob');

/*
Third pass at procedure for retrieving books from a specific list with new DB design
*/
DELIMITER $$
CREATE PROCEDURE fetch_books_in_list(book_list_name_p VARCHAR(64)
)
BEGIN
	SELECT
		b.book_id,
        b.book_title,
        b.release_date,
        GROUP_CONCAT(DISTINCT g.genre_name) AS genres,
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
        LEFT JOIN book_rating br ON b.book_id = br.book_id
	WHERE bl.list_name = book_list_name_p
    GROUP BY b.book_id, b.book_title, b.release_date, a.author_name, p.publisher_name, s.series_name, br.score, br.text
    ORDER BY b.book_id;
END $$

DELIMITER ;
        
SELECT @@sql_mode;

-- Test case:
CALL fetch_books_in_list('test_list');

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

-- Test case:
CALL delete_book_list('bob', 'test_list6');

-- Test case:
CALL CreateUserBookList('bob', 'test_list3');
SELECT @status_message;


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
CALL FetchUserGenres('s');

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

CALL CountUserBooks('s');


DELIMITER $$

CREATE PROCEDURE DateRangeUserBooks(
    IN username_p VARCHAR(64)
)
BEGIN
    SELECT 
        MIN(b.release_date) AS earliest_date,
        MAX(b.release_date) AS latest_date
    FROM book_list_book blb
    JOIN book_list bl ON blb.book_list_name = bl.list_name
    JOIN book b ON blb.book_id = b.book_id
    WHERE bl.user_name = username_p;
END $$

DELIMITER ;

CALL DateRangeUserBooks('s');


