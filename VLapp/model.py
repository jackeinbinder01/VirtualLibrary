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
        get_list_conn.callproc("FilterCurrentList", search_param)

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
        drop_list.callproc("DropCurrentList")
        drop_list.close()
        print("the list has been cleared")
        
    except Exception as e:
        # Catch any unexpected exceptions
        print(f"Unexpected error: {e}")
        
    