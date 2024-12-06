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


def application_logic(connection, username):
    leave = True
    while leave:
        connection.commit()

        user_is_admin = admin.is_user_admin(connection, username)
        if user_is_admin:
            main_menu_answer = admin.admin_main_menu()
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
            admin.manage_users_menu(connection, username)



        else:
            print("Invalid input. Please try again.")

        # Add more list management logic here as needed


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
            key_to_header["comments"]: book.get("comments", "N/A")
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
