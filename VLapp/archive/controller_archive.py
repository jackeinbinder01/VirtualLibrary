import model_archive as model
import pymysql


def work():
    connection = model.connect_to_database()
    if connection == None:
        print("closing app")
        return
    try:
        while True:
            username = model.login_options(connection)
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
