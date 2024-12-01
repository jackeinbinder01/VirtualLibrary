USE virtual_library_db;

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

CREATE PROCEDURE add_book(book_title_p VARCHAR(256), description_p TEXT, author_id_p INT,
                          publisher_id_p INT, release_date_p DATE)

BEGIN
    DECLARE book_in_db_error VARCHAR(64);

    SET book_in_db_error = CONCAT('book: ', book_title_p, ', already exists in the book table');

    IF EXISTS (
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
        INSERT INTO book(book_title, description, author_id, publisher_id, release_date)
        VALUES (book_title_p, description_p, author_id_p, publisher_id_p, release_date_p);
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
CREATE PROCEDURE add_book_from_import(book_title_p VARCHAR(256), description_p TEXT, author_name_p VARCHAR(128),
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
        CALL add_book(book_title_p, description_p,
                      author_id_v, publisher_id_v, release_date_p);
    END IF ;


END //
DELIMITER ;

DROP PROCEDURE IF EXISTS add_author;

DELIMITER //
CREATE PROCEDURE add_author(author_name_p VARCHAR(128), author_email_p VARCHAR(64))

BEGIN

    DECLARE author_in_db_error VARCHAR(256);
    DECLARE email_in_db_error VARCHAR(256);
    DECLARE blank_param_error VARCHAR(64);

    SET author_in_db_error = CONCAT('Author: ', author_name_p, ', already exists in author table.');
    SET email_in_db_error = CONCAT('The email: ', author_email_p, ', already exists in author table.');
    SET blank_param_error = CONCAT('Author name or email cannot be blank.');

    IF author_name_p = '' OR author_email_p = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = blank_param_error;
    ELSEIF EXISTS (
        SELECT
            1 AS 'author in db'
        FROM author a
        WHERE 1=1
        AND a.author_name = author_name_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = author_in_db_error;
    ELSEIF EXISTS (
        SELECT
            1 AS 'email in db'
        FROM author a
        WHERE 1=1
        AND a.email_address = author_email_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = email_in_db_error;
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
    DECLARE email_in_db_error VARCHAR(256);
    DECLARE blank_param_error VARCHAR(64);

    SET publisher_in_db_error = CONCAT('Publisher: ', publisher_name_p, ', already exists in publisher table.');
    SET email_in_db_error = CONCAT('The email: ', publisher_email_p, ', already exists in publisher table.');
    SET blank_param_error = CONCAT('Publisher name or email cannot be blank.');

    IF publisher_name_p = '' OR publisher_email_p = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = blank_param_error;
    ELSEIF EXISTS (
        SELECT
            1 AS 'publisher in db'
        FROM publisher p
        WHERE 1=1
        AND p.publisher_name = publisher_name_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = publisher_in_db_error;
    ELSEIF EXISTS (
        SELECT
            1 AS 'email in db'
        FROM publisher p
        WHERE 1=1
        AND p.email_address = publisher_email_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = email_in_db_error;
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
