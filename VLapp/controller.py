import model
import pymysql


def main_menu(username):
    print("welcome to the main menu!")
    answer = input("would you like to search for books or manage your lists {username}"
                   "\n1. for searching\n2. for managing\nq to quit")
    return answer


def search_menu(username):
    print("welcome to the search menu!")
    answer = input("1. if you would like to search for books by genre, publisher,"
                " author name, book name, or series name\n2. to add a specific book"
                " to a list\n3. to remove a specific book\n4. add/update a rating on a"
                " book\nq to return to main menu")
    return answer

def manage_menu(username):
    print("welcome to the management menu!")
    answer = input("1. if you would like to ")

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

    main_menu_answer = main_menu(username)
    while True:
        if main_menu_answer.strip() == "1":
            pass

        if main_menu_answer.strip() == "2":
            pass
        if main_menu_answer.strip().lower() == 'q':
            return

def main():
    work()



if __name__ == "__main__":
    main()