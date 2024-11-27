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

def manage_menu(username, connection):
    while True:
        print("welcome to the management menu!")
        # model.print_user_lists_names(username)
        answer = input("1. create a new book list\n2. view you saved book lists\n3. return to main menu\n")
        if answer.strip() == '1':
            # Prompt user for name of book list they wish to create
            book_list_name = input("Enter the name of the book list you wish to create: \n")

            if not book_list_name:
                print("Book list name cannot be empty. Please try again.")
                continue

            # Call function that calls stored procedure to create new book list
            status_message = create_user_book_list(connection, username, book_list_name)

            # Display the status message returned by the procedure
            if status_message:
                print(f"Result: {status_message}")
            else:
                    print("An error occurred while creating the book list.")
        elif answer.strip() == '2':
            get_user_book_lists(connection, username)
        elif answer.strip() == '3':
            return

def create_user_book_list(connection, user_name, book_list_name):
    try:
        with connection.cursor() as cursor:
            print(f"Calling CreateUserBookList with username={user_name}, book_list_name={book_list_name}")
            cursor.callproc('CreateUserBookList', (user_name, book_list_name))

            cursor.execute('SELECT @status_message')
            result = cursor.fetchone()

            # Debug: Log the fetched result
            print(f"Procedure result: {result}")

            if result and 'status_message' in result:
                return result['status_message']
            else:
                return "No status message returned."
    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
        return None

'''
Calls the return_list_name_of_user stored procedure to fetch book lists for a user.
'''
def get_user_book_lists(connection, username):
    try:
        with connection.cursor() as cursor:
            # Call the stored procedure
            cursor.callproc('return_list_name_of_user', (username,))

            # Fetch all results returned by the procedure
            book_lists = cursor.fetchall()

            # If not book lists found
            if not book_lists:
                print("No book lists found for the user.")
                return

            # Display the user's saved book lists
            print(f"{username}'s Saved Book Lists: ")
            for index, book_list in enumerate(book_lists, start=1):
                print(f"{index}. {book_list['book_list_name']}")

            while True:
                try:
                    selected_index = int(input("Enter the number of the book list you wish to view"))

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")



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
                                break
                            break
                if search_menu_answer.strip() == '2':
                    pass
                if search_menu_answer.strip() == '3':
                    pass
                if search_menu_answer.strip() == '4':
                    pass
                if search_menu_answer.strip().lower == 'q':
                    break
            if main_menu_answer.strip() == "2":
                manage_menu(username, connection)
                break
            if main_menu_answer.strip().lower() == 'q':
                return

def main():
    work()



if __name__ == "__main__":
    main()