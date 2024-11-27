import pymysql
import datetime


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
            break
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
        
def print_books(book_list):
     # Check if the list is not empty and print books
    if book_list:
        print("{:<10} {:<75} {:<15} {:<15} {:<15} {:<15} {:<15}".format(
            "Book ID", "Book Title", "Release Date", "Genre", "Publisher", "Author", "Series"
        ))
        for book in book_list:
            # Convert release_date to a string for display
            date_str = book["release_date"].strftime('%Y-%m-%d') if book["release_date"] else "N/A"
            print("{:<10} {:<75} {:<15} {:<15} {:<15} {:<15} {:<15}".format(
                book["book_id"] or "N/A",
                book["book_title"] or "N/A",
                date_str,
                book["genreName"] or "N/A",
                book["publisherName"] or "N/A",
                book["authorName"] or "N/A",
                book["seriesName"] or "N/A"
            ))
    else:
        print("No books found.")
        
def get_list(search_param, connection):
    # Replace empty strings with None to match SQL's NULL behavior
    search_param = [param if param != "" else None for param in search_param]
    try:
        get_list_conn = connection.cursor()

        get_list_conn.callproc("GetBooksByFilters", search_param)

        # Fetch results
        book_list = get_list_conn.fetchall()
        get_list_conn.close()
        print_books(book_list)
       

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
            print_books(book_list)
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
        
def get_search_param():
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
    answer = input("1. if you would like to add new book list\n2. to delete") # TODO

def application_logic(connection, username):
    while True: 
        main_menu_answer = main_menu(username)

        # Quit from main menu
        if main_menu_answer.strip().lower() == 'q':
            print("Exiting program. Goodbye!")
            return

        if main_menu_answer.strip() == "1":  # Search Menu
            search_logic(connection, username)

        elif main_menu_answer.strip() == "2":  # Manage Lists
            manage_lists_logic(connection, username)

        else:
            print("Invalid input. Please try again.")


def search_logic(connection, username):
    while True:
        search_menu_answer = search_menu(username)

        # Quit to main menu
        if search_menu_answer.strip().lower() == 'q':
            print("Returning to main menu...")
            break

        if search_menu_answer.strip() == '1':  # Search for books
            search_books(connection)

        elif search_menu_answer.strip() == '2':  # Add by book ID
            add_book_by_id_logic(connection)

        elif search_menu_answer.strip() == '3':  # Remove by book ID
            remove_book_by_id_logic(connection)

        elif search_menu_answer.strip() == '4':  # Update a rating on a book
            update_rating_logic(connection, username)

        else:
            print("Invalid input. Please try again.")


def search_books(connection):
    while True:
        search_param = get_search_param()
        get_list(search_param, connection)

        # Refine search loop
        while True:
            user_continue = input("Would you like to further refine the list (y/n): ").strip().lower()
            if user_continue == "y":
                search_param = get_search_param()
                filter_current_list(search_param, connection)
            elif user_continue == "n":
                drop_current_list(connection)
                print("Returning to search menu...")
                return
            else:
                print("Invalid input. Please enter 'y' or 'n'.")


def manage_lists_logic(connection, username):
    while True:
        list_menu_answer = manage_menu(username)

        # Quit to main menu
        if list_menu_answer.strip().lower() == 'q':
            print("Returning to main menu...")
            break

        # Add more list management logic here as needed


def update_rating_logic(connection, username):
    score = input("Enter a number (1 - 5): ").strip()
    comment = input(f"Write some thoughts on why you gave this book a {score}: ").strip()
    rate_book(username, score, comment, connection)


def add_book_by_id_logic(connection):
    # Implement logic for adding a book by its ID
    pass


def remove_book_by_id_logic(connection):
    # Implement logic for removing a book by its ID
    pass



    