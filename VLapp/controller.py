import model
import pymysql

import db_and_app_login


def work():
    connection = db_and_app_login.connect_to_database()
    if connection == None:
        print("closing app")
        return
    try:
        while True:
            username = db_and_app_login.login_options(connection)
            if username == False:
                print("Failed to login to the Virtual Library. Closing application.")
                return
            else:
                break
    except Exception as e:
        print(f"Errors occurred: {e}:")
        return
    model.application_logic(connection, username)
    connection.commit()


def main():
    work()


if __name__ == "__main__":
    main()
