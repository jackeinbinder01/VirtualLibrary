import pymysql

def work():
    while True:
        username = input("Enter your username: ")
        pword = input('Enter your password: ')
        # Connect to the database
        try:
            connection = pymysql.connect(host='localhost',
                                         user=username,
                                         password=pword,
                                         database='virtual_library_db',
                                         cursorclass=pymysql.cursors.DictCursor,
                                         autocommit=True)

            print("Connection Successful")

        except pymysql.Error as e:
            code, msg = e.args
            print("Cannot connect to the database", code, msg)
            print("Please try entering your username and password again.")


if __name__ == '__main__':
    work()