


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

