import model


def login_info():
    '''
    ask user if they have an account
    if no account make new one send data to DB
    if not ask for username and password and ensure the DB has them.
    '''
    while True:
        answer = input("enter a value based on the prompt below\n1. Login to an existing account\n2.Create a new account")
        while answer == "1":
            username = input("please enter the username: ")
            password = input("please enter your password: ")
            if model.login(username, password):
                print("login successful")
                return
            else:
                print("please try again")
                
        while answer == "2":
            username = input("please enter the username: ")
            password = input("please enter your password: ")
            if model.create_user(username, password):
                print("account created, you have been automatically logged in")
            else:
                print("please try again")