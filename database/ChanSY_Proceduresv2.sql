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

Error Code: 1304. PROCEDURE return_list_name_of_user already exists


/*
Procedure to view booklist items. Takes in username and name of booklist.
*/

DELIMITER $$
CREATE PROCEDURE return_book_list_items(user_name_p VARCHAR(64), book_list_name_p VARCHAR(64))
BEGIN
	SELECT b.book_id, b.book_title, b.description, b.release_date
    FROM user_book_list ubl
		JOIN book_list bl ON ubl.book_list_name = bl.list_name
        JOIN book_list_book blb ON blb.book_list_name = bl.list_name
        JOIN book b USING(book_id)
	WHERE ubl.user_name = user_name_p AND ubl.book_list_name = book_list_name_p;
END $$
DELIMITER ;

-- Test cases:
CALL return_book_list_items('jack', 'favorites');

/*
Second pass at retrieving books from a specific book list
*/
DELIMITER $$

CREATE PROCEDURE fetch_books_in_list(
    IN book_list_name_p VARCHAR(64)
)
BEGIN
    SELECT 
        b.book_id,
        b.book_title,
        b.release_date,
        GROUP_CONCAT(DISTINCT g.genre_name) AS genreName,
        GROUP_CONCAT(DISTINCT a.author_name) AS authorName,
        GROUP_CONCAT(DISTINCT p.publisher_name) AS publisherName, 
        GROUP_CONCAT(DISTINCT s.series_name) AS seriesName       
    FROM book_list_book blb
    JOIN book b ON blb.book_id = b.book_id
    LEFT JOIN book_genre bg ON b.book_id = bg.book_id
    LEFT JOIN genre g ON bg.genre_name = g.genre_name 
    LEFT JOIN book_author ba ON b.book_id = ba.book_id
    LEFT JOIN author a ON ba.author_id = a.author_id
    LEFT JOIN book_publisher bp ON b.book_id = bp.book_id
    LEFT JOIN publisher p ON bp.publisher_id = p.publisher_id
    LEFT JOIN book_series bs ON b.book_id = bs.book_id
    LEFT JOIN series s ON bs.series_id = s.series_id
    WHERE blb.book_list_name = book_list_name_p
    GROUP BY b.book_id, b.book_title, b.release_date
    ORDER BY b.book_title;
END $$

DELIMITER ;

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

CALL fetch_books_in_list("da vanci");

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