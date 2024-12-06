import pymysql
import tabulate
import model


def manage_users_menu(connection, admin_user_name):
    print("\nWelcome to the Manage Users Menu!\n"
          "Please select from the following options:\n")
    answer = input("1. View users in database"
                   "\n2. Create a user account"
                   "\n3. Delete a user account"
                   "\n4. Update a user's information"
                   "\n5. Make a user an Admin"
                   "\n6. Demote a user from Admin"
                   "\nr. Return to main menu\n\n")
    match answer.lower():
        case '1':
            admin_view_users(connection, admin_user_name)
        case '2':
            admin_create_user(connection, admin_user_name)
        case '3':
            admin_delete_user(connection, admin_user_name)
        case '4':
            admin_update_user_information(connection, admin_user_name)
        case '5':
            make_user_admin(connection, admin_user_name)
        case '6':
            demote_user_from_admin(connection, admin_user_name)
        case 'r':
            model.application_logic(connection, admin_user_name)


def admin_view_users(connection, admin_user_name):
    try:
        cursor = connection.cursor()
        cursor.execute("CALL view_users()")
        result_tuples = cursor.fetchall()
        if not result_tuples:
            print("View users error: No users found in database.")
        else:
            if not result_tuples:
                print("View users error: No users found in database.")
            else:
                clean_data = [
                    {key: ('True' if key == 'is_admin' and value == 1
                           else 'False' if key == 'is_admin' and value == 0
                    else value) for key, value in row.items()}
                    for row in result_tuples
                ]
                table = tabulate.tabulate(clean_data, headers="keys", tablefmt="grid")
                print(f'{table}')
                manage_users_menu(connection, admin_user_name)
    except pymysql.Error as e:
        code, msg = e.args
        print(f"View users error: {code} - {msg}")


def admin_create_user(connection, admin_user_name):
    username = input("Enter the user's username: ").strip()
    password = input("Enter the user's password: ").strip()

    if username == '' or password == '':
        print("\nCreate user error: Username and/or password cannot be blank.")
        manage_users_menu(connection, admin_user_name)
        return

    try:
        cursor = connection.cursor()
        cursor.execute(f"CALL AddUser('{username}', '{password}')")
        print(f"\nSuccessfully created account for '{username}'\n")
    except pymysql.Error as e:
        print(f"\nAdmin create user error: {e}\n")


def admin_delete_user(connection, admin_user_name):
    username = input("Enter the username of the user to delete: ").strip()

    if username == '':
        print("\nDelete User Error: Username cannot be blank.")
        manage_users_menu(connection, admin_user_name)
        return

    try:
        cursor = connection.cursor()
        cursor.execute(f"CALL delete_user('{username}')")
        print(f"\nSuccessfully deleted '{username}'\n")
    except pymysql.Error as e:
        print(f"\nDelete user error: {e}\n")


def admin_update_user_information(connection, admin_user_name):
    print("Please select from the following options:\n")
    answer = input("\n1. Update a user's username"
                   "\n2. Update a user's password"
                   "\n3. Update a user's username and password"
                   "\nr. Return to the Manage Users Menu\n\n")

    match answer.lower():
        case '1':
            old_username = input("Enter the user's old username: ").strip()
            new_username = input("Enter the user's new username: ").strip()

            if old_username == new_username:
                print("\nUpdate user error: New username must be different than the original username.")
                admin_update_user_information(connection, admin_user_name)
                return
            if new_username == '':
                print("\nUpdate user error: New username cannot be blank.")
                admin_update_user_information(connection, admin_user_name)
                return

            try:
                cursor = connection.cursor()
                cursor.execute(f"CALL update_username('{old_username}', '{new_username}')")
                print(f"\nSuccessfully updated username '{old_username}' to '{new_username}'!\n")
            except pymysql.Error as e:
                print(f"\nUpdate user error: {e}\n")
        case '2':
            username = input("Enter the user's username: ").strip()
            new_password = input("Enter the user's new password: ").strip()

            if new_password == '':
                print("\nUpdate user error: New password cannot be blank.")
                admin_update_user_information(connection, admin_user_name)
                return

            try:
                cursor = connection.cursor()
                cursor.execute(f"CALL update_password('{username}', '{new_password}')")
                print(f"\nSuccessfully updated {username}'s password!\n")
            except pymysql.Error as e:
                print(f"\nUpdate user error: {e}\n")

        case '3':
            old_username = input("Enter the user's old username: ").strip()
            new_username = input("Enter the user's new username: ").strip()
            new_password = input("Enter the user's new password: ").strip()

            if old_username == new_username:
                print("\nUpdate user error: New username must be different than the original username.")
                admin_update_user_information(connection, admin_user_name)
                return
            if new_username == '':
                print("\nUpdate user error: New username cannot be blank.")
                admin_update_user_information(connection, admin_user_name)
                return
            if new_password == '':
                print("\nUpdate user error: New password cannot be blank.")
                admin_update_user_information(connection, admin_user_name)
                return
            try:
                cursor = connection.cursor()
                cursor.execute(f"CALL update_username('{old_username}', '{new_username}')")
                print(f"\nSuccessfully updated username '{old_username}' to '{new_username}'!")
            except pymysql.Error as e:
                print(f"\nUpdate user error: {e}\n")

            try:
                cursor = connection.cursor()
                cursor.execute(f"CALL update_password('{new_username}', '{new_password}')")
                print(f"Successfully updated {new_username}'s password!\n")
            except pymysql.Error as e:
                print(f"\nUpdate user error: {e}\n")
        case 'r':
            manage_users_menu(connection, admin_user_name)
        case _:
            print(f"\nInvalid option '{answer}'. Please try again.")
            admin_update_user_information(connection, admin_user_name)


def make_user_admin(connection, admin_user_name):
    username = input("Enter the user's username: ").strip()

    if username == '':
        print("\nMake user admin error: Username cannot be blank.")
        manage_users_menu(connection, admin_user_name)
        return

    confirmation = input(f"Are you sure you want to make '{username}' an Admin? (y/n)\n ")
    if confirmation.lower() != 'y':
        print(f"\nUser '{username}' was NOT made an Admin.")
        manage_users_menu(connection, admin_user_name)
        return

    try:
        cursor = connection.cursor()
        cursor.execute(f"CALL make_user_admin('{username}')")
        print(f"\nUser '{username}' was successfully promoted to Admin!\n")
    except pymysql.Error as e:
        print(f"\nMake user admin error: {e}\n")


def demote_user_from_admin(connection, admin_user_name):
    username = input("Enter the user's username: ").strip()

    if username == '':
        print("\nDemote user from admin error: Username cannot be blank.")
        manage_users_menu(connection, admin_user_name)
        return

    confirmation = input(f"Are you sure you want to demote '{username}' from Admin? (y/n)\n ")
    if confirmation.lower() != 'y':
        print(f"\nUser '{username}' was NOT demoted from Admin.")
        manage_users_menu(connection, admin_user_name)
        return

    try:
        cursor = connection.cursor()
        cursor.execute(f"CALL demote_user_from_admin('{username}')")
        print(f"\nUser '{username}' was successfully demoted from Admin!\n")
    except pymysql.Error as e:
        print(f"\nDemote user from admin error: {e}\n")


def is_user_admin(connection, username):
    try:
        cursor = connection.cursor()
        cursor.execute(f"SELECT is_user_admin('{username}')")

        result = cursor.fetchone()
        key = f"is_user_admin('{username}')"

        user_is_admin = result[key] if result else False
        return user_is_admin
    except Exception as e:
        print(f"Admin check error: {e}")
        return False


def admin_main_menu():
    print("Please select from the following options:")
    answer = input("\n1. Search the Virtual Library for books"
                   "\n2. Manage my saved book lists"
                   "\n3. View user analytics"
                   "\n4. Manage users"
                   "\nq. Quit\n\n")
    return answer
