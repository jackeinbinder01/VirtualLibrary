import model
import pymysql


def login_options(connection):
    '''
    ask user if they have an account
    if no account make new one send data to DB
    if not ask for username and password and ensure the DB has them.
    '''
    while True:
        answer = input("enter a value based on the prompt below\n"
                       "1. Login to an existing account"
                       "\n2.Create a new account\nq to quit\n")
        if answer.lower() == "q":
            return False
        if answer == "1":
            while True:
                if model.login_user(connection):
                    print("login successful")
                    return True
                else:
                    retry = input("Try again y/n")
                    if retry.lower == 'n':
                        return False
                
        if answer == "2":
            while True:
                if model.create_user(connection):
                    print("account created, you have been automatically logged in")
                    return True
                else:
                    retry = input("Try again y/n")
                    if retry.lower == 'n':
                        return False
        else: 
            print("invalid input please try again")  

def work():
    connection = model.connect_to_database()
    if connection == None:
        print("closing app")
        return
    try:
        while True:
            if login_options(connection):
                im_in = True
            else:
                print("closing app")
                return
    except Exception as e:
        print("error found")
    
def main():
    work()
    
    
    
if __name__ == "__main__":
    main()