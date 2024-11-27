import pymysql


def connect_to_database():
    """
    Establish a connection to the MySQL database.
    """
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
    '''
    ask user if they have an account
    if no account make new one send data to DB
    if not ask for username and password and ensure the DB has them.
    '''
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
