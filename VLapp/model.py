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


def get_username_password():
    username = input("please enter the username: ")
    password = input("please enter the password: ")
    return username, password

def create_user(connection):
    username, password = get_username_password()
    try:
        creation_conn = connection.cursor()
        creation_conn.callproc('AddUser', (username, password))
        print("User created successfully")
        creation_conn.callproc('LoginUser', (username, password, "@status"))
        creation_conn.close()
        return True
    except pymysql.Error as e:
        print(f"Error during creation: {e}")
        return False


def login_user(connection):
    username, password = get_username_password()
    try:
        login_conn = connection.cursor()
        login_conn.callproc('LoginUser', (username, password, "@status"))
        print("User logged in successfully.")
        return True
    except pymysql.Error as e:
        print(f"Error during login: {e}")
        return False




