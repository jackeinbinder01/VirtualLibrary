DROP DATABASE IF EXISTS virtual_library_db;
CREATE DATABASE IF NOT EXISTS virtual_library_db;
USE virtual_library_db;

CREATE TABLE book
(
    book_id INT AUTO_INCREMENT PRIMARY KEY
    , book_title VARCHAR(128) NOT NULL
    , description TEXT NOT NULL
    , release_date DATE NOT NULL

    , CONSTRAINT book_ak
        UNIQUE(book_title, release_date)
);

CREATE TABLE author
(
    author_id INT AUTO_INCREMENT PRIMARY KEY
    , first_name VARCHAR(32) NOT NULL
    , last_name VARCHAR(32) NOT NULL
    , email_address VARCHAR(64) NOT NULL

    , CONSTRAINT author_ak_name
        UNIQUE(first_name, last_name)

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
    publisher_name VARCHAR(128) NOT NULL PRIMARY KEY
    , email_address VARCHAR(64) NOT NULL

    , CONSTRAINT publisher_ak
        UNIQUE(email_address)
);

CREATE TABLE book_publisher
(
    book_id INT NOT NULL
    , publisher_name VARCHAR(128) NOT NULL

    , CONSTRAINT book_publisher_pk
        PRIMARY KEY(book_id, publisher_name)

    , CONSTRAINT book_publisher_fk_book
        FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

    , CONSTRAINT book_publisher_fk_publisher
        FOREIGN KEY (publisher_name) REFERENCES publisher (publisher_name)
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
    format_type ENUM('Hard Cover', 'Paper Back', 'PDF', 'eBook') NOT NULL
    , url VARCHAR(256) PRIMARY KEY
);

CREATE TABLE book_format
(
    book_id INT NOT NULL
    , format_type VARCHAR(16) NOT NULL

    , CONSTRAINT book_format_pk
        PRIMARY KEY(book_id)

    , CONSTRAINT book_format_fk_book
        FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

    , CONSTRAINT book_format_fk_format
        FOREIGN KEY (format_type) REFERENCES format (format_type)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

