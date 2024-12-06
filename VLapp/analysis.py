
def analysis_logic(connection, username):
    leave = True
    while leave:
        # if user is an admin the check will be here and it will allow
        # a user to see all usernames and pass in one as an arguement
        # to the other functions!
        analysis_input = analysis_menu(connection, username).strip().lower()

        if analysis_input == '1':
            user_genre_analysis(connection, username)
        elif analysis_input == '2':
            user_most_read_genre_analysis(connection, username)
        elif analysis_input == "3":
            user_book_count_analysis(connection, username)
        elif analysis_input == '4':
            user_author_analysis(connection, username)
        elif analysis_input == "5":
            user_most_read_author_analysis(connection, username)

        elif analysis_input == 'r':
            return


def analysis_menu(connection, username):
    user = username
    print("\nWelcome to the User Analytics Menu!\n"
          "Please select from the following options:")
    analysis_input = input(f"\n1. View genres across all {user}'s lists"
                           f"\n2. View {user}'s most read genre"
                           f"\n3. View the number of unique books"
                           f"\n4. View authors across all {user}'s lists"
                           f"\n5. View {user}'s most read author"
                           f"\nr. Return to managment menu\n\n"
                           )
    return analysis_input


def user_genre_analysis(connection, username):
    try:
        with connection.cursor() as genre_analysis:
            genre_analysis.callproc("FetchUserGenres", (username,))
            result = genre_analysis.fetchall()

            if not result:
                print(f"\nThere are no books in your lists, {username}!")
                return
            print("The genres you read are:\n")
            for key in result:
                genre = key.get("genres")
                print(f"- {genre}")
            print("\n")
            return

    except Exception as e:
        print(f"Unexpected error: {e}")


def user_most_read_genre_analysis(connection, username):
    try:
        with connection.cursor() as most_read_genre_analysis:
            most_read_genre_analysis.callproc("MostReadGenre", (username,))
            result = most_read_genre_analysis.fetchall()
            if not result:
                print(f"\nThere are no books in your lists, {username}!")
                return

            if len(result) > 1:
                print(f" {username}'s most read genres are\n")
                for genre in result:
                    print(f"- {genre.get("genre_name")}")
            else:
                genre = result[0]
                print(f"{username}'s most read genre is:\n")
                print(f"- {genre.get("genre_name")}")
            print("\n")
            return
    except Exception as e:
        print(f"Unexpected error: {e}")


def user_author_analysis(connection, username):
    try:
        with connection.cursor() as author_analysis:
            author_analysis.callproc("AuthorDiversity", (username,))
            result = author_analysis.fetchall()

            print("The Authors you read are:\n")
            for key in result:
                author = key.get("unique_authors")
                print(f"- {author}")
            print("\n")
            return
            # print_analysis_tabular(result, "genres")
    except Exception as e:
        print(f"Unexpected error: {e}")


def user_most_read_author_analysis(connection, username):
    try:
        with connection.cursor() as most_read_author:
            most_read_author.callproc("TopAuthor", (username,))
            result = most_read_author.fetchall()
            if not result:
                print(f"There are no books in your lists {username}!")
                return
            if len(result) > 1:
                print(f"{username}'s most read genres are\n")
                for author in result:
                    print(f"- {author.get("author_name")}")
                print("\n")
            else:
                author = result[0]
                print(f"{username}'s most read author is:\n")
                print(f"- {author.get("author_name")}\n\n")
            return
    except Exception as e:
        print(f"Unexpected error: {e}")


def user_book_count_analysis(connection, username):
    try:
        with connection.cursor() as book_num_analysis:
            book_num_analysis.callproc("CountUserBooks", (username,))
            result = book_num_analysis.fetchall()

            total_books = result[0].get("total_unique_books")
            book = "books"
            if total_books == 1:
                book = "book"
            print(f"\nYou have a total of {total_books} {book} in your lists\n\n")

    except Exception as e:
        print(f"Unexpected error: {e}")