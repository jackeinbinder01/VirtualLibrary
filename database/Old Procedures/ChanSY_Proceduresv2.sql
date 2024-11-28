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

-- Test case:
CALL CreateUserBookList('bob', 'test_list3');
SELECT @status_message;