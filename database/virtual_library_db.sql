DROP DATABASE IF EXISTS virtual_library_db;
CREATE DATABASE IF NOT EXISTS virtual_library_db;
USE virtual_library_db;

CREATE TABLE author
(
    author_id INT AUTO_INCREMENT PRIMARY KEY
    , author_name VARCHAR(128) NOT NULL
    , email_address VARCHAR(64)

    , CONSTRAINT author_ak_name
        UNIQUE(author_name)
);

CREATE TABLE publisher
(
    publisher_id INT AUTO_INCREMENT PRIMARY KEY
    , publisher_name VARCHAR(128) NOT NULL
    , email_address VARCHAR(64)

    , CONSTRAINT publisher_ak_name
            UNIQUE(publisher_name)
);

CREATE TABLE book
(
    book_id INT AUTO_INCREMENT PRIMARY KEY
    , book_title VARCHAR(256) NOT NULL
    , author_id INT
    , publisher_id INT NOT NULL
    , release_date DATE NOT NULL

    , CONSTRAINT book_ak
        UNIQUE(book_title, release_date)

    , CONSTRAINT book_fk_author
        FOREIGN KEY (author_id) REFERENCES author (author_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE

    , CONSTRAINT book_fk_publisher
        FOREIGN KEY (publisher_id) REFERENCES publisher (publisher_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE series
(
    series_id INT AUTO_INCREMENT PRIMARY KEY
    , series_name VARCHAR(128) NOT NULL

    , CONSTRAINT series_ak
        UNIQUE(series_name)
);

CREATE TABLE book_series
(
    book_id INT NOT NULL
    , series_id INT NOT NULL

    , CONSTRAINT book_series_pk
        PRIMARY KEY(book_id, series_id)

    , CONSTRAINT book_series_fk_book
        FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

    , CONSTRAINT book_series_fk_series
        FOREIGN KEY (series_id) REFERENCES series (series_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE link
(
    url VARCHAR(512) PRIMARY KEY
    , format_type ENUM('Hardcover', 'Paperback', 'PDF', 'eBook', 'Audiobook') NOT NULL
    , book_id INT NOT NULL

    , CONSTRAINT link_fk_book
        FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE genre
(
    genre_name VARCHAR(64) PRIMARY KEY
);

CREATE TABLE book_genre
(
    book_id INT NOT NULL
    , genre_name VARCHAR(64) NOT NULL

    , CONSTRAINT book_genre_pk
        PRIMARY KEY(book_id, genre_name)

    , CONSTRAINT book_genre_fk_book
        FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

    , CONSTRAINT book_genre_fk_genre
        FOREIGN KEY (genre_name) REFERENCES genre (genre_name)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE user
(
    user_name VARCHAR(64) PRIMARY KEY
    , password VARCHAR(64) NOT NULL
	, is_admin BOOL DEFAULT FALSE NOT NULL
);

CREATE TABLE book_list
(
    list_name VARCHAR(64) NOT NULL
    , user_name VARCHAR(64) NOT NULL

    , CONSTRAINT book_list_pk
        PRIMARY KEY(list_name, user_name)

    , CONSTRAINT book_list_fk_user
        FOREIGN KEY (user_name) REFERENCES user (user_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE book_list_book
(
    book_list_name VARCHAR(64) NOT NULL
    , user_name VARCHAR(64) NOT NULL
    , book_id INT NOT NULL

    , CONSTRAINT book_list_book_pk
        PRIMARY KEY(book_list_name, user_name,  book_id)

    , CONSTRAINT book_list_book_fk_book
        FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

    , CONSTRAINT book_list_book_fk_book_list
        FOREIGN KEY (book_list_name, user_name) REFERENCES book_list (list_name, user_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE book_rating
(
    user_name VARCHAR(64) NOT NULL
    , book_id INT NOT NULL
    , text TEXT
    , score INT NOT NULL

    , CONSTRAINT user_book_rating_pk
        PRIMARY KEY(user_name, book_id)

    , CONSTRAINT score_ck
        CHECK(score BETWEEN 1 AND 5)

    , CONSTRAINT user_book_rating_fk_book
        FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

    , CONSTRAINT user_book_rating_fk_user
        FOREIGN KEY (user_name) REFERENCES user (user_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
