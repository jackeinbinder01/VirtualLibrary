USE virtual_library_db;


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





