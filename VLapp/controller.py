import model
import pymysql

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
    answer = input("1. if you would like to add new book list\n2. to delete")

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
        main_menu_answer = main_menu(username)
        while True:
            if main_menu_answer.strip() == "1":
                search_menu_answer = search_menu(username)
                if search_menu_answer.strip() == '1':
                    while True:
                        search_param = get_search_param()
                        model.get_list(search_param, connection)
                        while True:
                            user_continue = input("would you like to further refine the list y/n")
                            if user_continue.strip().lower() == "y":
                                search_param = get_search_param()
                                model.filter_current_list(search_param, connection)
                                # TODO
                            if user_continue.strip().lower() == "n":
                                model.drop_current_list(connection)
                                print("returning to search menu")
                                break
                if search_menu_answer.strip() == '2': # add by book id
                    pass
                if search_menu_answer.strip() == '3': # remove by book id
                    pass
                if search_menu_answer.strip() == '4': # update a rating on book
                    score = input("enter an number 1 - 5")
                    comment = input(f"write down some thoughts on why you gave this book a {score}")
                    model.rate_book(username, score, comment, connection)
                if search_menu_answer.strip().lower == 'q':
                    print("returning to main menu")
                    break
            if main_menu_answer.strip() == "2":
                pass
            if main_menu_answer.strip().lower() == 'q':
                return

def main():
    work()



if __name__ == "__main__":
    main()