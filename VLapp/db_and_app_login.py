import pymysql

def connect_to_database():
    """
    Handles connects to MySQL the database.

    :return: None if user does not want to reconnect
    """
    while True:
        # username = input("Enter your MySQL username: ").strip()
        # pword = input("Enter your MySQL password: ").strip()
        try:
            connection = pymysql.connect(
                host='localhost',
                user="root",
                password="Basti101",
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
                       "\nq. Quit\n\n")
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
