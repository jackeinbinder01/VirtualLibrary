DROP DATABASE IF EXISTS virtual_library_db;
CREATE DATABASE IF NOT EXISTS virtual_library_db;
USE virtual_library_db;

CREATE TABLE book
(
    book_id INT AUTO_INCREMENT PRIMARY KEY
    , book_title VARCHAR(256) NOT NULL
    , description TEXT NOT NULL
    , release_date DATE NOT NULL

    , CONSTRAINT book_ak
        UNIQUE(book_title, release_date)
);

CREATE TABLE author
(
    author_id INT AUTO_INCREMENT PRIMARY KEY
    , author_name VARCHAR(128) NOT NULL
    , email_address VARCHAR(64) NOT NULL

    , CONSTRAINT author_ak_name
        UNIQUE(author_name)

    , CONSTRAINT author_ak_email
        UNIQUE(email_address)
);

CREATE TABLE book_author
(
    book_id INT NOT NULL
    , author_id INT NOT NULL

    , CONSTRAINT book_author_pk
        PRIMARY KEY(book_id, author_id)

    , CONSTRAINT book_author_fk_book
        FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

    , CONSTRAINT book_author_fk_author
        FOREIGN KEY (author_id) REFERENCES author (author_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE publisher
(
    publisher_id INT AUTO_INCREMENT PRIMARY KEY
    , publisher_name VARCHAR(128) NOT NULL
    , email_address VARCHAR(64) NOT NULL

    , CONSTRAINT publisher_ak_name
            UNIQUE(publisher_name)
    , CONSTRAINT publisher_ak_email
            UNIQUE(email_address)
);

CREATE TABLE book_publisher
(
    book_id INT NOT NULL
    , publisher_id INT NOT NULL

    , CONSTRAINT book_publisher_pk
        PRIMARY KEY(book_id, publisher_id)

    , CONSTRAINT book_publisher_fk_book
        FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

    , CONSTRAINT book_publisher_fk_publisher
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

CREATE TABLE format
(
    format_id INT AUTO_INCREMENT PRIMARY KEY
    , format_type ENUM('Hard Cover', 'Paper Back', 'PDF', 'eBook', 'Audio Book') NOT NULL
    , url VARCHAR(512) NOT NULL

    , CONSTRAINT format_ak
        UNIQUE(url)
);

CREATE TABLE book_format
(
    book_id INT NOT NULL
    , format_id INT NOT NULL

    , CONSTRAINT book_format_pk
        PRIMARY KEY(book_id, format_id)

    , CONSTRAINT book_format_fk_book
        FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

    , CONSTRAINT book_format_fk_format
        FOREIGN KEY (format_id) REFERENCES format (format_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE genre
(
    genre_name VARCHAR(32) PRIMARY KEY
);

CREATE TABLE book_genre
(
    book_id INT NOT NULL
    , genre_name VARCHAR(32) NOT NULL

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

CREATE TABLE book_list
(
    list_name VARCHAR(64) PRIMARY KEY
);

CREATE TABLE book_list_book
(
    book_list_name VARCHAR(64) NOT NULL
    , book_id INT NOT NULL

    , CONSTRAINT book_list_book_pk
        PRIMARY KEY(book_list_name, book_id)

    , CONSTRAINT book_list_book_fk_book
        FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

    , CONSTRAINT book_list_book_fk_book_list
        FOREIGN KEY (book_list_name) REFERENCES book_list (list_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE user
(
    user_name VARCHAR(64) PRIMARY KEY
    , password VARCHAR(64) NOT NULL
);


CREATE TABLE user_book_list
(
    user_name VARCHAR(64) NOT NULL
    , book_list_name VARCHAR(64) NOT NULL

    , CONSTRAINT user_book_list_pk
        PRIMARY KEY(user_name, book_list_name)

    , CONSTRAINT user_book_list_fk_user
        FOREIGN KEY (user_name) REFERENCES user (user_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE

    , CONSTRAINT user_book_list_fk_book_list
        FOREIGN KEY (book_list_name) REFERENCES book_list (list_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE user_book_rating
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
