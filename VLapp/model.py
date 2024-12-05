import os

import pymysql
import csv
from datetime import datetime
import tabulate
from PyQt6.QtWidgets import QApplication, QFileDialog
import sys
import admin
import search
import analysis
import management



def main_menu():
    print("Please select from the following options:")
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


def manage_users_menu(connection, admin_user_name):
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
            admin.admin_view_users(connection, admin_user_name)
        case '2':
            admin.admin_create_user(connection, admin_user_name)
        case '3':
            admin.admin_delete_user(connection, admin_user_name)
        case '4':
            admin.admin_update_user_information(connection, admin_user_name)
        case '5':
            admin.make_user_admin(connection, admin_user_name)
        case '6':
            admin.demote_user_from_admin(connection, admin_user_name)
        case 'r':
            application_logic(connection, admin_user_name)






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
        "r. Return to main menu\n\n")
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
            search.search_logic(connection, username)

        elif main_menu_answer.strip() == "2":  # Manage Lists
            management.manage_lists_logic(connection, username)

        elif main_menu_answer.strip() == '3':
            analysis.analysis_logic(connection, username)

        elif main_menu_answer.strip() == "4" and user_is_admin:
            manage_users_menu(connection, username)



        else:
            print("Invalid input. Please try again.")



        # Add more list management logic here as needed


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






