USE virtual_library_db;

SELECT * FROM book;

SELECT * FROM author;

SELECT * FROM publisher;

SELECT * FROM series;

SELECT * FROM book_series;

SELECT * FROM user;

SELECT * FROM genre;

SELECT * FROM book_list;

SELECT * FROM book_genre WHERE book_id = 1;

SELECT * FROM book_list_book;

SELECT * FROM book_rating;

SELECT * FROM link;

SELECT * FROM filtered_book_list;




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
        (bg.genre_name = 'Crime') AND
        (b.book_title = 'The Da Vinci Code');


