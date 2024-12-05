import os

import pymysql
import csv
from datetime import datetime
import tabulate
from PyQt6.QtWidgets import QApplication, QFileDialog
import sys


def connect_to_database():
    """
    Handles connects to MySQL the database.

    :return: None if user does not want to reconnect
    """
    while True:
        username = input("Enter your MySQL username: ").strip()
        pword = input("Enter your MySQL password: ").strip()
        try:
            connection = pymysql.connect(
                host='localhost',
                user=username,
                password=pword,
                database="virtual_library_db",
                cursorclass=pymysql.cursors.DictCursor,
                autocommit=True
            )
            print("\nConnection Successful!\n"
                  "\nWelcome to the Virtual Library!")
            return connection
        except pymysql.Error as e:
            print(f"Cannot connect to the database: {e}")
            while True:
                retry = input("Would you like to try again? (y/n)\n").strip().lower()
                if retry == 'y':
                    break
                if retry == 'n':
                    return None
                else:
                    print("invalid entry")


def login_options(connection):
    while True:
        answer = input("Please login or create a new account:\n"
                       "\n1. Login to an existing account"
                       "\n2. Create a new account"
                       "\nq. Quit\n")
        if answer.strip().lower() == "q":
            return False
        if answer == "1":
            while True:
                username = login_user(connection)
                if username != False:
                    print(f"\nWelcome back, {username}!")
                    return username
                else:
                    retry = input("Please try again. (y/n)\n")
                    if retry.lower() == 'n':
                        return False

        if answer == "2":
            while True:
                username = create_user(connection)
                if username != False:
                    print("You have been automatically logged in.\n")
                    return username
                else:
                    retry = input("Please try again. (y/n)\n")
                    if retry.strip().lower() == 'n':
                        return False
        else:
            print(f"Invalid input '{answer}', please try again.\n")


def get_username_password():
    username = input("Please enter your Virtual Library username: ")
    password = input("Please enter your Virtual Library password: ")
    return username, password


def create_user(connection, is_admin=False):
    username, password = get_username_password()
    try:
        creation_conn = connection.cursor()

        # Call AddUser procedure
        creation_conn.callproc('AddUser', (username, password))
        print("\nUser account created successfully!")
        # Commit changes to ensure the user is saved
        connection.commit()

        if not is_admin:

            # Call LoginUser to log in
            creation_conn.callproc('LoginUser', (username, password))
            result = creation_conn.fetchone()
            # print(f"Raw SELECT result: {result}")

            if result is None or "login_status" not in result:
                return False

            login_status = result["login_status"]
            # print(f"Login Status after creation: {login_status}")

            # Return username if login is successful
            if login_status == "Login Successful":
                return username
            else:
                print("incorrect usernname or password")
                return False
    except pymysql.Error as e:
        print(f"Error during account creation or login: {e}")
        return False
    finally:
        creation_conn.close()


def login_user(connection):
    username, password = get_username_password()
    try:
        login_conn = connection.cursor()

        # Call the LoginUser stored procedure with two arguments
        login_conn.callproc('LoginUser', (username, password))
        result = login_conn.fetchone()

        # Extract the login status
        login_status = result["login_status"]

        # Return username if login is successful
        if login_status == "Login Successful":
            return username
        else:
            print("\nFailed to login to the Virtual Library. Closing Application.")
            return False
    except pymysql.Error as e:
        print(f"Error during login: {e}")
        return False
    finally:
        login_conn.close()


def get_list(search_param, connection):
    # Replace empty strings with None to match SQL's NULL behavior
    search_param = [param if param != "" else None for param in search_param]
    try:
        get_list_conn = connection.cursor()

        get_list_conn.callproc("GetBooksByFilters", search_param)

        # Fetch results
        book_list = get_list_conn.fetchall()
        get_list_conn.close()
        print_books_tabular(book_list)


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
            print_books_tabular(book_list)
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
    search_param = [input("What is the name of the genre: "),
                    input("The book name: "),
                    input("The last name of the publisher: "),
                    input("The author name: "),
                    input("The series name: "),
                    username
                    ]
    return search_param


def main_menu():
    print("Please select from the following options:\n")
    answer = input("\n1. Search the Virtual Library for books"
                   "\n2. Manage my saved book lists"
                   "\n3. View user analytics"
                   "\nq. Quit\n\n")
    return answer


def admin_main_menu():
    print("Please select from the following options:")
    answer = input("\n1. Search the Virtual Library for books"
                   "\n2. Manage my saved book lists"
                   "\n3. View user analytics"
                   "\n4. Manage users"
                   "\nq. Quit\n\n")
    return answer


def manage_users_menu(connection):
    print("\nWelcome to the Manage Users Menu!\n"
          "Please select from the following options:\n")
    answer = input("1. View users in database"
                   "\n2. Create a user account"
                   "\n3. Delete a user account"
                   "\n4. Update a user's information"
                   "\n5. Make a user an Admin"
                   "\n6. Demote a user from Admin"
                   "\nr. Return to main menu\n\n")
    match answer.lower():
        case '1':
            view_users(connection)
        case '2':
            admin_create_user(connection)
        case '3':
            admin_delete_user(connection)
        case '4':
            admin_update_user_information(connection)
        case '5':
            make_user_admin(connection)
        case '6':
            demote_user_from_admin(connection)
        case 'r':
            admin_main_menu()


def view_users(connection):
    try:
        cursor = connection.cursor()
        cursor.execute("CALL view_users()")
        result_tuples = cursor.fetchall()
        if not result_tuples:
            print("View users error: No users found in database.")
        else:
            if not result_tuples:
                print("View users error: No users found in database.")
            else:
                clean_data = [
                    {key: ('True' if key == 'is_admin' and value == 1 else value) for key, value in row.items()}
                    for row in result_tuples
                ]
                table = tabulate.tabulate(clean_data, headers="keys", tablefmt="grid")
                print(f'{table}')
                manage_users_menu(connection)
    except pymysql.Error as e:
        code, msg = e.args
        print(f"View users error: {code} - {msg}")


def admin_create_user(connection):
    username = input("Enter the user's username: ").strip()
    password = input("Enter the user's password: ").strip()

    if username == '' or password == '':
        print("\nCreate user error: Username and/or password cannot be blank.")
        manage_users_menu(connection)
        return

    try:
        cursor = connection.cursor()
        cursor.execute(f"CALL AddUser('{username}', '{password}')")
        print(f"\nSuccessfully created account for '{username}'\n")
    except pymysql.Error as e:
        print(f"\nAdmin create user error: {e}\n")


def admin_delete_user(connection):
    username = input("Enter the username of the user to delete: ").strip()

    if username == '':
        print("\nDelete User Error: Username cannot be blank.")
        manage_users_menu(connection)
        return

    try:
        cursor = connection.cursor()
        cursor.execute(f"CALL delete_user('{username}')")
        print(f"\nSuccessfully deleted '{username}'\n")
    except pymysql.Error as e:
        print(f"\nDelete user error: {e}\n")


def admin_update_user_information(connection):
    print("Please select from the following options:\n")
    answer = input("\n1. Update a user's username"
                   "\n2. Update a user's password"
                   "\n3. Update a user's username and password"
                   "\nr. Return to the Manage Users Menu\n\n")

    match answer.lower():
        case '1':
            old_username = input("Enter the user's old username: ").strip()
            new_username = input("Enter the user's new username: ").strip()

            if old_username == new_username:
                print("\nUpdate user error: New username must be different than the original username.")
                admin_update_user_information(connection)
                return
            if new_username == '':
                print("\nUpdate user error: New username cannot be blank.")
                admin_update_user_information(connection)
                return

            try:
                cursor = connection.cursor()
                cursor.execute(f"CALL update_username('{old_username}', '{new_username}')")
                print(f"\nSuccessfully updated username '{old_username}' to '{new_username}'!\n")
            except pymysql.Error as e:
                print(f"\nUpdate user error: {e}\n")
        case '2':
            username = input("Enter the user's username: ").strip()
            new_password = input("Enter the user's new password: ").strip()

            if new_password == '':
                print("\nUpdate user error: New password cannot be blank.")
                admin_update_user_information(connection)
                return

            try:
                cursor = connection.cursor()
                cursor.execute(f"CALL update_password('{username}', '{new_password}')")
                print(f"\nSuccessfully updated {username}'s password!\n")
            except pymysql.Error as e:
                print(f"\nUpdate user error: {e}\n")

        case '3':
            old_username = input("Enter the user's old username: ").strip()
            new_username = input("Enter the user's new username: ").strip()
            new_password = input("Enter the user's new password: ").strip()

            if old_username == new_username:
                print("\nUpdate user error: New username must be different than the original username.")
                admin_update_user_information(connection)
                return
            if new_username == '':
                print("\nUpdate user error: New username cannot be blank.")
                admin_update_user_information(connection)
                return
            if new_password == '':
                print("\nUpdate user error: New password cannot be blank.")
                admin_update_user_information(connection)
                return
            try:
                cursor = connection.cursor()
                cursor.execute(f"CALL update_username('{old_username}', '{new_username}')")
                print(f"\nSuccessfully updated username '{old_username}' to '{new_username}'!")
            except pymysql.Error as e:
                print(f"\nUpdate user error: {e}\n")

            try:
                cursor = connection.cursor()
                cursor.execute(f"CALL update_password('{new_username}', '{new_password}')")
                print(f"Successfully updated {new_username}'s password!\n")
            except pymysql.Error as e:
                print(f"\nUpdate user error: {e}\n")
        case 'r':
            manage_users_menu(connection)
        case _:
            print(f"\nInvalid option '{answer}'. Please try again.")
            admin_update_user_information(connection)


def make_user_admin(connection):
    username = input("Enter the user's username: ").strip()

    if username == '':
        print("\nMake user admin error: Username cannot be blank.")
        manage_users_menu(connection)
        return

    confirmation = input(f"Are you sure you want to make '{username}' an Admin? (y/n)\n ")
    if confirmation.lower() != 'y':
        print(f"\nUser '{username}' was NOT made an Admin.")
        manage_users_menu(connection)
        return

    try:
        cursor = connection.cursor()
        cursor.execute(f"CALL make_user_admin('{username}')")
        print(f"\nUser '{username}' was successfully promoted to Admin!\n")
    except pymysql.Error as e:
        print(f"\nMake user admin error: {e}\n")


def demote_user_from_admin(connection):
    username = input("Enter the user's username: ").strip()

    if username == '':
        print("\nDemote user from admin error: Username cannot be blank.")
        manage_users_menu(connection)
        return

    confirmation = input(f"Are you sure you want to demote '{username}' from Admin? (y/n)\n ")
    if confirmation.lower() != 'y':
        print(f"\nUser '{username}' was NOT demoted from Admin.")
        manage_users_menu(connection)
        return

    try:
        cursor = connection.cursor()
        cursor.execute(f"CALL demote_user_from_admin('{username}')")
        print(f"\nUser '{username}' was successfully demoted from Admin!\n")
    except pymysql.Error as e:
        print(f"\nDemote user from admin error: {e}\n")


def search_menu(current_list=None):
    print("\nWelcome to the search menu!\n"
          "Please select from the following options:\n")

    answer = input("\n1. Search for books by genre, publisher, author name, book name, or series name"
                   "\n2. Add a specific book by book id to a list"
                   "\n3. Remove a specific book by book id"
                   "\n4. Add/update a rating on a book by book id"
                   "\n5. Add a URL to access a copy of a book"
                   "\n\nr. Return to the main menu\n")
    return answer


def manage_menu(username):
    # model.print_user_lists_names(username)

    print("\nWelcome to the Management Menu!\n"
          "Please select from the following options:\n")
    answer = input(
        "1. Create a new book list\n"
        "2. View my book lists\n"
        "3. Delete an existing book list\n"
        "4. Add a book to a book list\n"
        "5. Remove a book from a book list\n"
        "6. Export a book list to csv file\n"
        "7. Import a book list from a csv file\n"
        "r. Return to main menu\n")
    return answer


def is_user_admin(connection, username):
    try:
        cursor = connection.cursor()
        cursor.execute(f"SELECT is_user_admin('{username}')")

        result = cursor.fetchone()
        key = f"is_user_admin('{username}')"

        user_is_admin = result[key] if result else False
        return user_is_admin
    except Exception as e:
        print(f"Admin check error: {e}")
        return False


def application_logic(connection, username):
    leave = True
    while leave:
        connection.commit()

        user_is_admin = is_user_admin(connection, username)
        if user_is_admin:
            main_menu_answer = admin_main_menu()
        else:
            main_menu_answer = main_menu()

        # Quit from main menu
        if main_menu_answer.strip().lower() == 'q':
            print("Exiting program. Goodbye!")
            leave = False
            break

        if main_menu_answer.strip() == "1":  # Search Menu
            search_logic(connection, username)

        elif main_menu_answer.strip() == "2":  # Manage Lists
            manage_lists_logic(connection, username)

        elif main_menu_answer.strip() == '3':
            analysis_logic(connection, username)

        elif main_menu_answer.strip() == "4" and user_is_admin:
            manage_users_menu(connection)



        else:
            print("Invalid input. Please try again.")


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
            analysis_logic(connection, username)
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


def manage_lists_logic(connection, username):
    while True:
        connection.commit()
        list_menu_answer = manage_menu(username)

        if list_menu_answer.strip() == '1':
            book_list_name = input("\nEnter the name of the book list you wish to create: \n")

            if not book_list_name:
                print("Book list name cannot be empty. Please try again.")
                continue

            # Call function that calls stored procedure to create new book list
            status_message = create_user_book_list(connection, username, book_list_name)

            # Display the status message returned by the procedure
            if status_message:
                print(f"Result: {status_message}")
            else:
                print("An error occurred while creating the book list.")

        elif list_menu_answer.strip() == '2':
            print_user_book_lists(connection, username)

        elif list_menu_answer.strip() == '3':
            delete_book_list(connection, username)

        elif list_menu_answer.strip() == '4':
            add_book_by_id_logic(connection, username)

        elif list_menu_answer.strip() == '5':
            remove_book_by_id_logic(connection, username)

        elif list_menu_answer.strip() == '6':
            export_user_book_list(connection, username)

        elif list_menu_answer.strip() == '7':
            import_book_list_from_csv(connection, username)

        # quit to main menu
        elif list_menu_answer.strip().lower() == 'r':
            print("Returning to main menu...")
            break

        # Add more list management logic here as needed


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
    list_name = operate_on_user_book_lists(connection, username, "add")
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
            fetch_books_in_list(connection, username, list_name)
        except pymysql.MySQLError as e:
            print(f"Database error: {e}")


def remove_book_by_id_logic(connection, username):  # TODO
    list_name = operate_on_user_book_lists(connection, username, "delete")
    fetch_books_in_list(connection, username, list_name)
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


'''
Helper funtion to create new user book list
'''


def create_user_book_list(connection, user_name, book_list_name):
    try:
        with connection.cursor() as cursor:
            print(f"Calling CreateUserBookList with username={user_name}, book_list_name={book_list_name}")
            cursor.callproc('CreateUserBookList', (user_name, book_list_name))

            cursor.execute('SELECT @status_message')
            result = cursor.fetchone()

            # Debug: Log the fetched result
            # print(f"Procedure result: {result}")

            if result and 'status_message' in result:
                return result['status_message\n']
            # else:
            #     return "No status message returned."
    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
        return None


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


'''
Helper function to retrieve and display a user's saved book lists
'''


def print_user_book_lists(connection, username):
    try:
        with connection.cursor() as cursor:
            # Call the stored procedure
            cursor.callproc('return_list_name_of_user', (username,))

            # Fetch all results returned by the procedure
            book_lists = cursor.fetchall()

            # If not book lists found
            if not book_lists:
                print("No book lists found for the user.")
                return

            while True:
                # Display the user's saved book lists
                print(f"{username}'s Saved Book Lists: ")
                for index, book_list in enumerate(book_lists, start=1):
                    print(f"{index}. {book_list['list_name']}")

                # add option to return back to management menu
                print(f"{len(book_lists) + 1}. Return to Management Menu")

                # Prompt user to select a book list
                try:
                    selected_index = (input("\nEnter the number of the book list you want: "))

                    if not selected_index.isdigit():
                        raise ValueError(f"Invalid input '{selected_index}'. Please enter a valid number.")
                        continue

                    selected_index = int(selected_index)

                    # if user selects option to return to management menu
                    if selected_index == len(book_lists) + 1:
                        return

                    # validate selected index
                    if 1 <= selected_index <= len(book_lists):
                        selected_list = book_lists[selected_index - 1]['list_name']

                        fetch_books_in_list(connection, username, selected_list)

                    else:
                        print(f"Invalid selection '{selected_index}'. Please choose a valid number.")
                except ValueError as e:
                    print(f"Invalid input: {e}. Please enter a number.")


    except pymysql.MySQLError as e:
        print(f"Database error: {e}")


'''
Helper function to call procedure to retrieve books from book list
'''


def fetch_books_in_list(connection, username, book_list_name):
    try:
        with connection.cursor() as cursor:
            # Call stored procedure
            cursor.callproc('fetch_books_in_list', (book_list_name, username))

            # Fetch all results returned by the procedure
            books = cursor.fetchall()

            # Display books using the print_books helper function
            if books:
                print_books_tabular(books)
            else:
                print(f"No books found in the book list '{book_list_name}'.")

            return books

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
        return []


'''
Helper function to export book list to a csv file.
'''


def export_user_book_list(connection, username):
    try:
        with connection.cursor() as cursor:
            # call stored procedure to fetch book lists
            cursor.callproc('return_list_name_of_user', (username,))

            # Fetch all results returned by the procedure
            book_lists = cursor.fetchall()

            # If no book lists found
            if not book_lists:
                print(f"No book lists found for the user '{username}'.")
                return

            # Display the user's saved book lists
            print(f"\n{username}'s Saved Book Lists:")
            for index, book_list in enumerate(book_lists, start=1):
                print(f"{index}. {book_list['list_name']}")

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
        return

    # Prompt the user to select a book list
    try:
        selected_index = int(input("\nEnter the number of the book list you want to export: "))

        # Validate selected index
        if 1 <= selected_index <= len(book_lists):
            selected_list = book_lists[selected_index - 1]['list_name']

            # Fetch books in the selected list
            books = fetch_books_in_list(connection, username, selected_list)

            # Export the book list to a CSV file
            if books:
                export_book_list_to_csv(selected_list, books)
            # else:
            # print(f"No books found in the book list '{selected_list}'.")
        else:
            print(f"Invalid selection '{selected_index}'. Please choose a valid number.")
    except ValueError:
        print("Invalid input. Please enter a number.")

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")


'''
Helper function that exports a given book list to a CSV file
'''


def export_book_list_to_csv(book_list_name, books):
    try:
        # Initialize the application for the file dialog
        app = QApplication(sys.argv)

        # Open a file dialog to get the file path
        file_name, _ = QFileDialog.getSaveFileName(
            None,
            "Save Book List As",
            f"{book_list_name.replace(' ', '_')}_book_list.csv",
            "CSV Files (*.csv);;All Files(*)"
        )

        # Exit if user cancels the save operation
        if not file_name:
            print("\nExport canceled.")
            return

        # Write book data to the CSV file
        with open(file_name, mode='w', newline='', encoding='utf-8') as file:
            writer = csv.writer(file)
            #write header row
            writer.writerow(
                ["Book ID", "Book Title", "Release Date", "Genres", "Authors", "Publisher", "Series", "Rating"])

            # Write book data rows
            for book in books:
                writer.writerow([
                    book.get("book_id", "N/A"),
                    book.get("book_title", "N/A"),
                    book.get("release_date", "N/A"),
                    book.get("genres", "N/A"),
                    book.get("author_name", "N/A"),
                    book.get("publisher_name", "N/A"),
                    book.get("series_name", "N/A"),
                    book.get("rating", "N/A")
                ])

        print(f"\nBook list successfully exported to {file_name}!")
    except Exception as e:
        print(f"An error occurred while exporting the book list: {e}")


def parse_date(date):
    formats = ["%Y-%m-%d", "%d-%m-%Y", "%m/%d/%y", "%m/%d/%Y"]

    for each in formats:
        try:
            return datetime.strptime(date, each).date()
        except ValueError:
            continue

    return None


def import_book_list_from_csv(connection, username):
    """
    Imports books and a book list from a csv file into the book and book_list tables in db.

    Opens file chooser and prompts the user to choose the book list csv to import.

    :param connection: connection to MySQL database
    :param username: user's account name
    """

    print("\nPlease select a csv file that matches the import template in the README.\n")
    app = QApplication([])

    # Open file dialog to select a CSV file
    file_path, _ = QFileDialog.getOpenFileName(
        None,
        "Please select a CSV file to import",
        "",
        "CSV Files (*.csv);;All Files (*)"
    )

    if not file_path:
        print("No file selected.")
        return

    file_name = os.path.basename(file_path)
    book_list_name = os.path.splitext(file_name)[0]
    cursor = connection.cursor()

    try:
        with open(file_path, mode='r', encoding='utf-8') as file:
            reader = csv.reader(file)
            header = next(reader)
            if header != ['book_title', 'release_date', 'author_name', 'publisher_name',
                          'author_email', 'publisher_email', 'series', 'url', 'format_type', 'genre_1',
                          'genre_2', 'genre_3']:
                print(f"\nImport error: Invalid csv! Please use the csv import template provided "
                      f"in the Virtual Library README.\n")
                return
            for row in reader:
                book_title = row[0].replace("'", '')
                release_date = row[1]
                author_name = row[2].replace("'", '')
                publisher_name = row[3].replace("'", '')
                author_email = row[4].replace("'", '')
                publisher_email = row[5].replace("'", '')
                series = row[6].replace("'", '')
                url = row[7].replace("'", '')
                format_type = row[8].replace("'", '')

                formatted_release_date = parse_date(release_date)

                if formatted_release_date:
                    current_date = datetime.now().date()
                    if formatted_release_date > current_date:
                        print(f"Import Error: Future release date '{formatted_release_date}' is invalid.")
                else:
                    print(f"'{release_date}' is not a valid date.")
                    return

                if any(field == '' for field in [book_title, release_date, author_name, publisher_name]):
                    print("\nImport Error: csv template is missing some required fields. Please populate all required "
                          "fields as detailed in the Virtual Library README.\n")
                    return
                if url != '' and format_type == '':
                    print(f"\nImport Error: the 'format_type' field is required when a URL is imported.\n")
                    return
                else:
                    try:
                        cursor.execute(
                            f"CALL add_book_from_import('{book_title}', '{author_name}', '{author_email}', '{publisher_name}', '{publisher_email}', '{formatted_release_date}')")
                    except pymysql.MySQLError as e:
                        print(f"Attempted add book to db: {e}")
                        return
                    try:
                        cursor.execute(
                            f"CALL add_book_to_user_list('{username}', '{book_list_name}', '{book_title}', '{formatted_release_date}')")
                    except pymysql.MySQLError as e:
                        print(f"Attempted add book to user list: {e}")
                if series != '':
                    try:
                        cursor.execute(
                            f"CALL add_book_to_series('{book_title}', '{formatted_release_date}', '{series}')")
                    except pymysql.MySQLError as e:
                        print(f"Attempted add book to series: {e}")

                if all(field != '' for field in [url, format_type]):
                    try:
                        cursor.execute(
                            f"CALL add_link('{url}','{format_type}','{book_title}', '{formatted_release_date}')")
                    except pymysql.MySQLError as e:
                        print(f"Attempted add url: {e}")

                for i in range(9, 12):
                    genre_name = row[i].replace("'", '')
                    if genre_name:
                        try:
                            cursor.execute(
                                f"CALL add_genre_to_book('{book_title}', '{formatted_release_date}', '{genre_name}')"
                            )
                        except pymysql.MySQLError as e:
                            print(f"Attempted add genre to book: {e}")
        connection.commit()
        print("\nImport complete!\n")

    except csv.Error as e:
        print(f"Error reading CSV: {e}")
    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
    finally:
        cursor.close()


'''
Helper function that prints books in tabular format
'''


def print_books_tabular(book_list):
    if not book_list:
        print(f"No books in book list '{book_list}' to display.")
        return

    # Define custom header mapping
    key_to_header = {
        "book_id": "Book ID",
        "book_title": "Book Title",
        "release_date": "Release Date",
        "genres": "Genres",
        "author_name": "Author",
        "publisher_name": "Publisher Name",
        "series_name": "Series Name",
        "rating": "Rating",
        "comments": "Comments"
    }

    # Reformat the data to match the custom header names
    formatted_books = [
        {
            key_to_header["book_id"]: book.get("book_id", "N/A"),
            key_to_header["book_title"]: book.get("book_title", "N/A"),
            key_to_header["release_date"]: book.get("release_date", "N/A"),
            key_to_header["genres"]: book.get("genres", "N/A"),
            key_to_header["author_name"]: book.get("author_name", "N/A"),
            key_to_header["publisher_name"]: book.get("publisher_name", "N/A"),
            key_to_header["series_name"]: book.get("series_name", "N/A"),
            key_to_header["rating"]: book.get("rating", "N/A"),
            key_to_header["comments"]: book.get("comments", "N/A"),
        }
        for book in book_list
    ]

    # Extract the headers in the desired order
    custom_headers = list(key_to_header.values())

    # Debugging output
    # print("Formatted books (final structure):", formatted_books)
    # print("Custom headers:", custom_headers)

    try:
        # Print table using tabulate
        print(tabulate.tabulate(formatted_books, headers="keys", tablefmt="fancy_grid"))
    except ValueError as e:
        print(f"Error displaying table.")


def operate_on_user_book_lists(connection, username, operation):
    try:
        with connection.cursor() as cursor:
            # Call the stored procedure
            cursor.callproc('return_list_name_of_user', (username,))

            # Fetch all results returned by the procedure
            book_lists = cursor.fetchall()

            # If not book lists found
            if operation == "add":
                if not book_lists:
                    create_new_list = input(f"No book lists found for the user '{username}'. Create new list? (y/n)\n")
                    if (create_new_list.strip().lower() == "y"):
                        list_name = input("What is the name of the new list?\n")
                        create_user_book_list(connection, username, list_name)
                        return list_name
                    else:
                        return 0
            else:
                if not book_lists:
                    print("There are no lists to delete from, returning to search menu.")
                    return 0
            if operation == "add":
                while True:
                    # Display the user's saved book lists
                    print(f"{username}'s Saved Book Lists: ")
                    for index, book_list in enumerate(book_lists, start=1):
                        print(f"{index}. {book_list['list_name']}")

                    # add option to return back to management menu

                    print(f"{len(book_lists) + 1}. Create a new list")
                    print(f"{len(book_lists) + 2}. Return to management menu")  # Option to return

                    # Prompt user to select a book list
                    try:
                        selected_index = (input("\nEnter the number of the book list you want to view: "))

                        if not selected_index.isdigit():
                            raise ValueError("Invalid input. Please enter a valid number.")
                            continue

                        selected_index = int(selected_index)

                        # if user selects option to return to management menu
                        if selected_index == len(book_lists) + 1:
                            list_name = input("What is the name of the new list?\n")
                            create_user_book_list(connection, username, list_name)
                            return list_name

                        if selected_index == len(book_lists) + 2:
                            print("Returning to search menu.")
                            return
                        # validate selected index
                        if 1 <= selected_index <= len(book_lists):
                            selected_list = book_lists[selected_index - 1]['list_name']
                            return selected_list

                        else:
                            print("Invalid selection. Please choose a valid number.")
                    except ValueError as e:
                        print(f"Invalid input: {e}. Please enter a number.")

            if operation == "delete":
                while True:
                    # Display the user's saved book lists
                    print(f"{username}'s Saved Book Lists: ")
                    for index, book_list in enumerate(book_lists, start=1):
                        print(f"{index}. {book_list['list_name']}")

                    # add option to return back to management menu

                    print(f"{len(book_lists) + 1}. Return to management menu")  # Option to return

                    # Prompt user to select a book list
                    try:
                        selected_index = (input("\nEnter the number of the book list you want to view: "))

                        if not selected_index.isdigit():
                            raise ValueError("Invalid input. Please enter a valid number.")
                            continue

                        selected_index = int(selected_index)

                        if selected_index == len(book_lists) + 1:
                            print("Returning to search menu.")
                            return
                        # validate selected index
                        if 1 <= selected_index <= len(book_lists):
                            selected_list = book_lists[selected_index - 1]['list_name']
                            return selected_list

                        else:
                            print(f"Invalid selection '{selected_index}'. Please choose a valid number.")
                    except ValueError as e:
                        print(f"Invalid input: {e}. Please enter a number.")

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")


'''
Helper function to delete a book list
'''


def delete_book_list(connection, username):
    try:
        with connection.cursor() as cursor:
            # Fetch the user's book lists
            cursor.callproc('return_list_name_of_user', (username,))
            book_lists = cursor.fetchall()

            # Check if there are any book lists
            if not book_lists:
                print("You have no book lists to delete.")
                return

            # Display book lists with corresponding numbers
            print(f"{username}'s Saved Book Lists:")
            for index, book_list in enumerate(book_lists, start=1):
                print(f"{index}. {book_list['list_name']}")

            # Prompt the user to select a book list
            selected_index = int(input("\nEnter the number of the book list you want to delete: "))

            # Validate the user's selection
            if 1 <= selected_index <= len(book_lists):
                selected_list_name = book_lists[selected_index - 1]['list_name']
                confirm = input(
                    f"Are you sure you want to delete the book list '{selected_list_name}'? (y/n)\n").strip().lower()

                if confirm == 'y':
                    # Call the DeleteBookList procedure
                    with connection.cursor() as cursor:
                        cursor.callproc('delete_book_list', (username, selected_list_name))
                        result = cursor.fetchall()
                        if result:
                            print(result[0]['status_message'])
                        else:
                            print("Error: No status message returned.")
                else:
                    print("Deletion canceled.")
            else:
                print("Invalid selection. Please choose a valid number.")

    except ValueError:
        print("Invalid input. Please enter a number.")
    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")


def analysis_logic(connection, username):
    leave = True
    while leave:
        # if user is an admin the check will be here and it will allow
        # a user to see all usernames and pass in one as an arguement
        # to the other functions!
        analysis_input = analysis_menu(connection, username).strip().lower()

        if analysis_input == '1':
            user_genre_analysis(connection, username)
        elif analysis_input == '2':
            user_most_read_genre_analysis(connection, username)
        elif analysis_input == "3":
            user_book_count_analysis(connection, username)
        elif analysis_input == '4':
            user_author_analysis(connection, username)
        elif analysis_input == "5":
            user_most_read_author_analysis(connection, username)

        elif analysis_input == 'r':
            return


def analysis_menu(connection, username):
    user = username
    print("\nWelcome to the User Analytics Menu!\n"
          "Please select from the following options:\n")
    analysis_input = input(f"\n1. View genres across all {user}'s lists"
                           f"\n2. View {user}'s most read genre"
                           f"\n3. View the number of unique books"
                           f"\n4. View authors across all {user}'s lists"
                           f"\n5. View {user}'s most read author"
                           f"\nr. Return to managment menu\n"
                           )
    return analysis_input


def user_genre_analysis(connection, username):
    try:
        with connection.cursor() as genre_analysis:
            genre_analysis.callproc("FetchUserGenres", (username,))
            result = genre_analysis.fetchall()

            if not result:
                print(f"\nThere are no books in your lists, {username}!")
                return
            print("The genres you read are:\n")
            for key in result:
                genre = key.get("genres")
                print(f"- {genre}")
            print("\n")
            return

    except Exception as e:
        print(f"Unexpected error: {e}")


def user_most_read_genre_analysis(connection, username):
    try:
        with connection.cursor() as most_read_genre_analysis:
            most_read_genre_analysis.callproc("MostReadGenre", (username,))
            result = most_read_genre_analysis.fetchall()
            if not result:
                print(f"\nThere are no books in your lists, {username}!")
                return

            if len(result) > 1:
                print(f" {username}'s most read genres are\n")
                for genre in result:
                    print(f"- {genre.get("genre_name")}")
            else:
                genre = result[0]
                print(f"{username}'s most read genre is:\n")
                print(f"- {genre.get("genre_name")}")
            print("\n")
            return
    except Exception as e:
        print(f"Unexpected error: {e}")


def user_author_analysis(connection, username):
    try:
        with connection.cursor() as author_analysis:
            author_analysis.callproc("AuthorDiversity", (username,))
            result = author_analysis.fetchall()

            print("The Authors you read are:\n")
            for key in result:
                author = key.get("unique_authors")
                print(f"- {author}")
            print("\n")
            return
            # print_analysis_tabular(result, "genres")
    except Exception as e:
        print(f"Unexpected error: {e}")


def user_most_read_author_analysis(connection, username):
    try:
        with connection.cursor() as most_read_author:
            most_read_author.callproc("TopAuthor", (username,))
            result = most_read_author.fetchall()
            if not result:
                print(f"There are no books in your lists {username}!")
                return
            if len(result) > 1:
                print(f"{username}'s most read genres are\n")
                for author in result:
                    print(f"- {author.get("author_name")}")
                print("\n")
            else:
                author = result[0]
                print(f"{username}'s most read genre is:\n")
                print(f"- {author.get("author_name")}\n\n")
            return
    except Exception as e:
        print(f"Unexpected error: {e}")


def user_book_count_analysis(connection, username):
    try:
        with connection.cursor() as book_num_analysis:
            book_num_analysis.callproc("CountUserBooks", (username,))
            result = book_num_analysis.fetchall()

            total_books = result[0].get("total_unique_books")
            book = "books"
            if total_books == 1:
                book = "book"
            print(f"\nYou have a total of {total_books} {book} in your lists\n\n")

    except Exception as e:
        print(f"Unexpected error: {e}")


def user_format_analysis(connection, username):
    pass
