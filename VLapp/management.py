import csv
import os
import sys
from datetime import datetime

import pymysql
from PyQt6.QtWidgets import QApplication, QFileDialog

import model
import search

def manage_lists_logic(connection, username):
    while True:
        connection.commit()
        list_menu_answer = model.manage_menu(username)

        if list_menu_answer.strip() == '1':
            book_list_name = input("\nEnter the name of the book list you wish to create: \n")

            if not book_list_name:
                print("Book list name cannot be empty. Please try again.")
                continue

            # Call function that calls stored procedure to create new book list
            status_message = model.create_user_book_list(connection, username, book_list_name)

            # Display the status message returned by the procedure
            if status_message.startswith("Database error"):
                print("An error occured while creating the book list.")
            else:
                print(f"Result: {status_message}")

        elif list_menu_answer.strip() == '2':
            print_user_book_lists(connection, username)

        elif list_menu_answer.strip() == '3':
            delete_book_list(connection, username)

        elif list_menu_answer.strip() == '4':
            search.add_book_by_id_logic(connection, username)

        elif list_menu_answer.strip() == '5':
            search.remove_book_by_id_logic(connection, username)

        elif list_menu_answer.strip() == '6':
            export_user_book_list(connection, username)

        elif list_menu_answer.strip() == '7':
            import_book_list_from_csv(connection, username)

        # quit to main menu
        elif list_menu_answer.strip().lower() == 'r':
            print("Returning to main menu...")
            break

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
                print("r. Return to Management menu")

                # Prompt user to select a book list

                selected_index = (input("\nEnter the number of the book list you want: "))

                if selected_index.lower() == 'r':
                    return

                if selected_index.isdigit():
                    selected_index = int(selected_index)

                    # validate selected index
                    if 1 <= selected_index <= len(book_lists):
                        selected_list = book_lists[selected_index - 1]['list_name']

                        fetch_books_in_list(connection, username, selected_list)

                    else:
                        print(f"Invalid selection '{selected_index}'. Please choose a valid number.")
                else:
                    print(f"Invalid input '{selected_index}'. Please enter a number or 'r'.")


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
                model.print_books_tabular(books)
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
                        model.create_user_book_list(connection, username, list_name)
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
                            search.create_user_book_list(connection, username, list_name)
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
