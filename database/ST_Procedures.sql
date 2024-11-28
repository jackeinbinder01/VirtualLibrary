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
        genre_name VARCHAR(64),
        publisher_name VARCHAR(128),
        author_name VARCHAR(128),
        series_name VARCHAR(128)
    );

    -- Clear existing data in FilteredBookList
    TRUNCATE TABLE FilteredBookList;

    -- Populate FilteredBookList with filtered data
    INSERT INTO FilteredBookList (book_id, book_title, release_date, genre_name, publisher_name, author_name, series_name)
    SELECT DISTINCT 
        b.book_id, 
        b.book_title, 
        b.release_date,
        g.genre_name,
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
        (genreName_p IS NULL OR g.genre_name = genreName_p) AND
        (bookName_p IS NULL OR b.book_title = bookName_p) AND
        (publisherName_p IS NULL OR p.publisher_name = publisherName_p) AND
        (authorName_p IS NULL OR a.author_name = authorName_p) AND
        (seriesName_p IS NULL OR s.series_name = seriesName_p);

    -- Return the contents of FilteredBookList
    SELECT * FROM FilteredBookList;
END $$

DELIMITER ;

CALL GetBooksByFilters(NULL, NULL, NULL, NULL, NULL);
DELIMITER $$

-- Filter on Filtered List
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
        genre_name VARCHAR(64),
        publisher_name VARCHAR(128),
        author_name VARCHAR(128),
        series_name VARCHAR(128)
    );

    -- Clear the working table
    TRUNCATE TABLE WorkingFilteredList;

    -- Populate the working table with filtered data
    INSERT INTO WorkingFilteredList (book_id, book_title, release_date, genre_name, publisher_name, author_name, series_name)
    SELECT DISTINCT 
        book_id, 
        book_title, 
        release_date,
        genre_name,
        publisher_name,
        author_name,
        series_name
    FROM FilteredBookList
    WHERE 
        (genreName_p IS NULL OR genre_name = genreName_p) AND
        (bookName_p IS NULL OR book_title = bookName_p) AND
        (publisherName_p IS NULL OR publisher_name = publisherName_p) AND
        (authorName_p IS NULL OR author_name = authorName_p) AND
        (seriesName_p IS NULL OR series_name = seriesName_p);

    -- Replace FilteredBookList with the filtered results
    TRUNCATE TABLE FilteredBookList;
    INSERT INTO FilteredBookList (book_id, book_title, release_date, genre_name, publisher_name, author_name, series_name)
    SELECT book_id, book_title, release_date, genre_name, publisher_name, author_name, series_name FROM WorkingFilteredList;

    -- Drop the working table (optional if you want it only temporary)
    DROP TABLE IF EXISTS WorkingFilteredList;

    -- Return the updated FilteredBookList
    SELECT * FROM FilteredBookList;
END $$

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





