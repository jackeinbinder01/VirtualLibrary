import pymysql
import datetime
import csv
from tabulate import tabulate


def connect_to_database():
    while True:
        username = input("Enter your username: ").strip()
        pword = input("Enter your password: ").strip()
        try:
            connection = pymysql.connect(
                host='localhost',
                user=username,
                password=pword,
                database="virtual_library_db",
                cursorclass=pymysql.cursors.DictCursor,
                autocommit=True
            )
            print("Connection Successful")
            return connection
        except pymysql.Error as e:
            print(f"Cannot connect to the database: {e}")
            retry = input("Would you like to try again? (y/n): ").strip().lower()
            if retry != 'y':
                return None

def login_options(connection):
    while True:
        answer = input("enter a value based on the prompt below\n"
                       "1. Login to an existing account"
                       "\n2. Create a new account\nq to quit\n")
        if answer.strip().lower() == "q":
            return False
        if answer == "1":
            while True:
                username = login_user(connection)
                if username != False:
                    print("login successful")
                    return username
                else:
                    retry = input("Try again y/n")
                    if retry.lower() == 'n':
                        return False

        if answer == "2":
            while True:
                username = create_user(connection)
                if username != False:
                    print("account created, you have been automatically logged in")
                    return username
                else:
                    retry = input("Try again y/n")
                    if retry.strip().lower() == 'n':
                        return False
        else: 
            print("invalid input please try again")

def get_username_password():
    username = input("please enter the username: ")
    password = input("please enter the password: ")
    return username, password

def create_user(connection):
    username, password = get_username_password()
    try:
        creation_conn = connection.cursor()

        # Call AddUser procedure
        creation_conn.callproc('AddUser', (username, password))
        print("User created successfully")

        # Commit changes to ensure the user is saved
        connection.commit()

        # Call LoginUser to log in
        creation_conn.callproc('LoginUser', (username, password))
        result = creation_conn.fetchone()
        print(f"Raw SELECT result: {result}")

        if result is None or "login_status" not in result:
            return False

        login_status = result["login_status"]
        print(f"Login Status after creation: {login_status}")

        # Return username if login is successful
        if login_status == "Login Successful":
            return username
        else:
            print("Login procedure did not return a valid status after account creation.")
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
        print(f"Login Status: {login_status}")

        # Return username if login is successful
        if login_status == "Login Successful":
            return username
        else:
            print("Login procedure did not return a valid status after account creation.")
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
        print("the list has been cleared")
        
    except Exception as e:
        # Catch any unexpected exceptions
        print(f"Unexpected error: {e}")
        
def get_search_param(username):
    print("please fill out the questions below, no response is acceptable")
    search_param = [ input("What is the name of the genre: "),
    input("the book name: "),
    input("the last name of the publisher: "),
    input("The author name: "),
    input("The series name: ")
    ]
    return search_param

def main_menu(username):
    print("welcome to the main menu!")
    answer = input(f"would you like to search for books or manage your lists {username}"
                   "\n1. for searching\n2. for managing\nq to quit\n")
    return answer


def search_menu(current_list=None):
    print("welcome to the search menu!")
    answer = input("1. if you would like to search for books by genre, publisher,"
                " author name, book name, or series name\n2. to add a specific book by book id"
                " to a list\n3. to remove a specific book by book id\n4. add/update a rating on a"
                " book by book id\nq to return to main menu\n")
    return answer


def manage_menu(username):
    print("welcome to the management menu!")
    # model.print_user_lists_names(username)
    answer = input("1. create a new book list\n2. view you saved book lists\n3. Delete a book list\n4.export book list to csv file\nr. return to main menu\n") # TODO
    return answer

def application_logic(connection, username):
    leave = True
    while leave: 
        connection.commit()
        main_menu_answer = main_menu(username)

        # Quit from main menu
        if main_menu_answer.strip().lower() == 'q':
            print("Exiting program. Goodbye!")
            leave = False
            break

        if main_menu_answer.strip() == "1":  # Search Menu
            search_logic(connection, username)

        elif main_menu_answer.strip() == "2":  # Manage Lists
            manage_lists_logic(connection, username)

        else:
            print("Invalid input. Please try again.")


def search_logic(connection, username):
    while True:
        connection.commit()
        search_menu_answer = search_menu(username)

        # Quit to main menu
        if search_menu_answer.strip().lower() == 'q':
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

        else:
            print("Invalid input. Please try again.")


def search_books(connection, username):
    while True:
        search_param = get_search_param(username)
        get_list(search_param, connection)

        # Refine search loop
        while True:
            user_continue = input("Would you like to further refine the list (y/n): ").strip().lower()
            if user_continue == "y":
                search_param = get_search_param(username)
                filter_current_list(search_param, connection)
            elif user_continue == "n":
                drop_current_list(connection)
                print("Returning to search menu...")
                return
            else:
                print("Invalid input. Please enter 'y' or 'n'.")


def manage_lists_logic(connection, username):
    while True:
        connection.commit()
        list_menu_answer = manage_menu(username)

        if list_menu_answer.strip() == '1':
            book_list_name = input("Enter the name of the book list you wish to create: \n")
            
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
            export_user_book_list(connection, username)

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
        if  0 < int(score) < 6:
            score = int(score)
            break
        else:
            print("Invalid input")
    comment = input(f"Write some thoughts on why you gave {book_title} a {score}: ").strip()
    rate_book(username, book_id, score, comment, connection)
    
def grab_book_by_id(connection, operation):
    while True:
        book_id = input(f"What is the ID number of the book you are looking to {operation}: ")
        book_title = search_book_by_id(connection, book_id)
        correct_book = input("Is this the correct book? y/n\n")
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
        
def add_book_by_id_logic(connection, username):
    correct_book_bool = False
    while not correct_book_bool:
       book_id, book_title = grab_book_by_id(connection, "add")
       if book_title is not None and book_id is not None:
           correct_book_bool = True
    print_list_names_of_user(connection, username)
    list_name = input("choose a list from above (case sensitive) or type 'n' to make a new list\n")
    if list_name.strip().lower() == 'n':
        list_name = input("What is the name of the new list?\n")
        create_user_book_list(connection, username, list_name)
    
    try:
        add_book = connection.cursor()
        add_book.callproc("AddBookToSublist", (username, list_name, book_id, "@BookAddStatus"))
        connection.commit()
        add_book.close()
        print(f"Here is updated the list of books in {list_name}")
        fetch_books_in_list(connection, list_name)
    except pymysql.MySQLError as e:
        print(f"Database error: {e}")


def remove_book_by_id_logic(connection, username): # TODO
    print_list_names_of_user(connection, username)
    list_name = input("choose a list from above (case sensitive)\n")
    print(f"Here is the list of books in {list_name}")
    fetch_books_in_list(connection, list_name)
    try:
        remove_book = connection.cursor()
        book_id, book_title = grab_book_by_id(connection, "delete")
        remove_book.callproc("RemoveBookFromUserList", (username, list_name, book_id, "@remove_status"))
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
            print(f"Procedure result: {result}")

            if result and 'status_message' in result:
                return result['status_message']
            else:
                return "No status message returned."
    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
        return None

def print_list_names_of_user(connection,username):
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
                    selected_index = (input("\nEnter the number of the book list you want to view: "))

                    if not selected_index.isdigit():
                        raise ValueError("Invalid input. Please enter a valid number.")
                        continue

                    selected_index = int(selected_index)

                    # if user selects option to return to management menu
                    if selected_index == len(book_lists) + 1:
                        return

                    # validate selected index
                    if 1 <= selected_index <= len(book_lists):
                        selected_list = book_lists[selected_index - 1]['list_name']

                        fetch_books_in_list(connection, selected_list)

                    else:
                        print("Invalid selection. Please choose a valid number.")
                except ValueError as e:
                    print(f"Invalid input: {e}. Please enter a number.")


    except pymysql.MySQLError as e:
        print(f"Database error: {e}")


'''
Helper function to call procedure to retrieve books from book list
'''
def fetch_books_in_list(connection, book_list_name):
    try:
        with connection.cursor() as cursor:
            # Call stored procedure
            cursor.callproc('fetch_books_in_list', (book_list_name,))

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
                print("No book lists found for the user.")
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
            books = fetch_books_in_list(connection, selected_list)

            # Export the book list to a CSV file
            if books:
                export_book_list_to_csv(selected_list, books)
            else:
                print(f"No books found in the book list '{selected_list}'.")
        else:
            print("Invalid selection. Please choose a valid number.")
    except ValueError:
        print("Invalid input. Please enter a number.")

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")

'''
Helper function that exports a given book list to a CSV file
'''
def export_book_list_to_csv(book_list_name, books):
    try:
        file_name = f"{book_list_name.replace(' ', '_')}_book_list.csv"

        # Write book data to the CSV file
        with open(file_name, mode='w', newline='', encoding='utf-8') as file:
            writer = csv.writer(file)
            #write header row
            writer.writerow(["Book ID", "Book Title", "Release Date", "Genres", "Authors", "Publisher", "Series", "Rating"])

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

        print(f"\nBook list successfully exported to {file_name}")
    except Exception as e:
        print(f"An error occured while exporting the book list: {e}")

'''
Helper function that prints books in tabular format
'''
def print_books_tabular(book_list):
    if not book_list:
        print("No books in book list to display.")
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
    print("Formatted books (final structure):", formatted_books)
    print("Custom headers:", custom_headers)

    try:
        # Print table using tabulate
        print(tabulate(formatted_books, headers="keys", tablefmt="fancy_grid"))
    except ValueError as e:
        print(f"Error displaying table.")

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
                    f"Are you sure you want to delete the book list '{selected_list_name}'? (y/n): ").strip().lower()

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