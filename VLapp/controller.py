import model
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
                print("the connection was unsuccessful, quitting now")
                return 
            else:
                break
    except Exception as e:
        print("error found")
        return
    while True:
        model.application_logic(connection, username)
        

def main():
    work()



if __name__ == "__main__":
    main()