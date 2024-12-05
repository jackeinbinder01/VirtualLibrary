import pymysql
import analysis
import model
import management

def search_menu(current_list=None):
    print("\nWelcome to the Search Menu!\n"
          "Please select from the following options:")
    answer = input("\n1. Search for books by genre, publisher, author name, book name, or series name"
                   "\n2. Add a specific book by book id to a list"
                   "\n3. Remove a specific book by book id"
                   "\n4. Add/update a rating on a book by book id"
                   "\n5. Add a URL to access a copy of a book"
                   "\nr. Return to the main menu\n\n")
    return answer

def search_logic(connection, username):
    while True:
        connection.commit()
        search_menu_answer = search_menu(username)

        # Quit to main menu
        if search_menu_answer.strip().lower() == 'r':
            print("Returning to main menu...")
            break

        if search_menu_answer.strip() == '1':  # Search for books
            search_books(connection, username)

        elif search_menu_answer.strip() == '2':  # Add by book ID
            add_book_by_id_logic(connection, username)

        elif search_menu_answer.strip() == '3':  # Remove by book ID
            remove_book_by_id_logic(connection, username)

        elif search_menu_answer.strip() == '4':  # Update a rating on a book
            update_rating_logic(connection, username)

        elif search_menu_answer.strip() == '5':  # Add a URL to the database
            add_url_to_db(connection)

        elif search_menu_answer.strip() == '6':  # go to analysis menu
            analysis.analysis_logic(connection, username)
        else:
            print(f"Invalid input '{search_menu_answer}'. Please try again.")


def search_books(connection, username):
    while True:
        search_param = get_search_param(username)
        get_list(search_param, connection)

        # Refine search loop
        while True:
            user_continue = input("Would you like to further refine the list? (y/n)\n").strip().lower()
            if user_continue == "y":
                search_param = get_search_param(username)
                filter_current_list(search_param, connection)
            elif user_continue == "n":
                drop_current_list(connection)
                print("Returning to search menu...")
                return
            else:
                print(f"Invalid input '{user_continue}'. Please enter 'y' or 'n'.")


def print_list_names_of_user(connection, username):
    try:
        with connection.cursor() as cursor:
            # Call the stored procedure
            cursor.callproc('return_list_name_of_user', (username,))

            # Fetch all results returned by the procedure
            book_lists = cursor.fetchall()

            # If not book lists found
            if not book_lists:
                print(f"No book lists found for the user '{username}'.")
                return

            while True:
                # Display the user's saved book lists
                print(f"{username}'s Saved Book Lists: ")
                for index, book_list in enumerate(book_lists, start=1):
                    print(f"{index}. {book_list['list_name']}")
                return
    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
        
def get_list(search_param, connection):
    # Replace empty strings with None to match SQL's NULL behavior
    search_param = [param if param != "" else None for param in search_param]
    try:
        get_list_conn = connection.cursor()

        get_list_conn.callproc("GetBooksByFilters", search_param)

        # Fetch results
        book_list = get_list_conn.fetchall()
        get_list_conn.close()
        model.print_books_tabular(book_list)


    except pymysql.Error as e:
        code, msg = e.args
        print(f"Error retrieving books: {code} - {msg}")

    except Exception as e:
        # Catch any unexpected exceptions
        print(f"Unexpected error: {e}")


def filter_current_list(search_param, connection):
    search_param = [param if param != "" else None for param in search_param]
    try:
        get_list_conn = connection.cursor()

        # Call the stored procedure
        get_list_conn.callproc("FilterOnFilteredList", search_param)

        # Fetch results
        book_list = get_list_conn.fetchall()
        get_list_conn.close()

        if book_list:
            model.print_books_tabular(book_list)
        else:
            print("No books found.")
    except pymysql.Error as e:
        code, msg = e.args
        print(f"Error retrieving books: {code} - {msg}")
    except Exception as e:
        print(f"Unexpected error: {e}")


def drop_current_list(connection):
    try:
        drop_list = connection.cursor()
        drop_list.callproc("DropFilteredList")
        drop_list.close()
        print("The list has been cleared")

    except Exception as e:
        # Catch any unexpected exceptions
        print(f"Unexpected error: {e}")


def get_search_param(username):
    print("Please fill out the questions below, no response is acceptable.\n")
    search_param = [input("Genre name: "),
                    input("Book title: "),
                    input("Publisher name: "),
                    input("Author name: "),
                    input("Series name: "),
                    username
                    ]
    return search_param


def add_url_to_db(connection):
    book_name = input("Enter the name of the book that the URL links to: ")
    book_release_date = input("Enter the book release date in the format: (yyyy-mm-dd): ")
    url = input("Enter the URL: ")

    while True:
        book_format = input("Enter the format of the book: \n"
                            "\n1. Hardcover\n"
                            "2. Paperback\n"
                            "3. PDF\n"
                            "4. eBook\n"
                            "5. Audiobook\n\n").strip().lower()
        valid_formats = {'1': 'Hardcover',
                         '2': 'Paperback',
                         '3': 'PDF',
                         '4': 'eBook',
                         '5': 'Audiobook',
                         'hardcover': 'Hardcover',
                         'paperback': 'Paperback',
                         'pdf': 'PDF',
                         'ebook': 'eBook',
                         'audiobook': 'Audiobook'}
        if book_format in valid_formats:
            book_format = valid_formats[book_format]
            break
        else:
            print(f"\nInvalid book format {book_format}. Please try again.")

    cursor = connection.cursor()
    try:
        cursor.execute(f"CALL add_link('{url}', '{book_format}', '{book_name}', '{book_release_date}')")
        print("\nURL added successfully!")
    except pymysql.Error as e:
        print(f"\nURL could not be added: {e}")


def add_book_by_id_logic(connection, username):
    correct_book_bool = False
    while not correct_book_bool:
        book_id, book_title = grab_book_by_id(connection, "add")
        if book_title is not None and book_id is not None:
            correct_book_bool = True
    list_name = management.operate_on_user_book_lists(connection, username, "add")
    if list_name == 0:
        print(f"{book_title} needs to be added to a list, returning to search menu")
        return
    else:
        try:
            add_book = connection.cursor()
            add_book.callproc("AddBookToSublist", (username, list_name, book_id, "@BookAddStatus"))
            connection.commit()
            add_book.close()
            print(f"Here is updated the list of books in {list_name}")
            management.fetch_books_in_list(connection, username, list_name)
        except pymysql.MySQLError as e:
            print(f"Database error: {e}")


def remove_book_by_id_logic(connection, username):  # TODO
    list_name = management.operate_on_user_book_lists(connection, username, "delete")
    management.fetch_books_in_list(connection, username, list_name)
    try:
        remove_book = connection.cursor()
        book_id, book_title = grab_book_by_id(connection, "delete")
        remove_book.callproc("RemoveBookFromUserList", (username, list_name, book_id))
        connection.commit()
        remove_book.close()

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")


def search_book_by_id(connection, book_id):
    try:
        # Call the stored procedure
        search_a_book = connection.cursor()
        search_a_book.callproc("GetBookById", (book_id,))

        # Fetch the results
        books = search_a_book.fetchall()
        search_a_book.close()

        # Check if any results were returned
        if books:
            for book in books:
                print(f"Book ID: {book['book_id']}, Book Title: {book['book_title']}")
                book_title = book['book_title']
                return book_title
        else:
            print(f"No book found with ID: {book_id}")
            return
    except pymysql.Error as e:
        print(f"Error retrieving book: {e}")


def update_rating_logic(connection, username):
    correct_book_bool = False
    while not correct_book_bool:
        book_id, book_title = grab_book_by_id(connection, "rate")
        if book_title is not None and book_id is not None:
            correct_book_bool = True
    while True:
        score = input("Enter a number (1 - 5):\n").strip()
        if 0 < int(score) < 6:
            score = int(score)
            break
        else:
            print(f"Invalid input '{score}'")
    comment = input(f"Write some thoughts on why you gave {book_title} a score of {score}: ").strip()
    rate_book(username, book_id, score, comment, connection)


def grab_book_by_id(connection, operation):
    while True:
        book_id = input(f"What is the ID number of the book you are looking to {operation}: ")
        book_title = search_book_by_id(connection, book_id)
        correct_book = input("Is this the correct book? (y/n)\n")
        if correct_book.lower().strip() == 'y':
            return book_id, book_title

        if correct_book.lower().strip() == 'n':
            print("Try a different ID")
        else:
            print("Invalid input")


def rate_book(username, book_id, score, comment, connection):
    try:
        book_rating = connection.cursor()
        book_rating.callproc("AddOrUpdateBookRating", (username, book_id, comment, score))
        connection.commit()
        book_rating.close()
        print("Rating successful\nReturning to search menu")
    except pymysql.Error as e:
        print(f"Error retrieving book: {e}")

