def login():
    '''
    ask user if they have an account
    if no account make new one send data to DB
    if not ask for username and password and ensure the DB has them.
    '''
    while True:
        answer = input("enter a value based on the prompt below\n1. Login to an existing account\n2.Create a new account")
        if answer == "1":
            username = input("please enter the username: ")
            password = input("please enter your password: ")
            ## use values to login to DB
            
            