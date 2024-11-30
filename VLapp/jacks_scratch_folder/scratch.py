import csv
import tkinter as tk
from tkinter import filedialog

def import_book_list_from_csv(user_name):
    """
    Imports books and a book list from a csv file into the book and book_list tables in db.

    Opens tkinter file chooser and prompts the user to choose the book list csv to import.

    :param connection: connection to MySQL database
    :param username: user's account name
    """
    root = tk.Tk()
    root.withdraw()

    file_path = filedialog.askopenfilename(
        title="Please select a CSV file to import",
        filetypes=[("CSV Files", "*.csv"), ("All Files", "*.*")]
    )

    file_name = "file_name"

    with open(file_path, mode='r', encoding='utf-8') as file:
        reader = csv.reader(file)
        header = next(reader)
        for row in reader:
            book_title = row[0]
            release_date = row[1]
            author_name = row[2]
            author_email = row[3]
            publisher_name = row[4]
            publisher_email = row[5]
            description = row[6]
            series = row[7]
            url = row[8]
            format_type = row[9]

            if any(field == '' for field in [book_title, release_date, author_name,
                                             author_email, publisher_name, publisher_email]):
                print("Invalid, missing required fields")
            else:
                print(f"CALL add_book_from_import('{book_title}', '{description}', '{author_name}', '{author_email}',"
                      f" '{publisher_name}', '{publisher_email}', '{release_date}')")
                print()
                print(f"CALL add_book_to_user_list('{user_name}', '{file_name}', '{book_title}', '{release_date}')")

            if series != '':
                print()
                print(f"CALL add_book_to_series('{book_title}', {release_date}', '{series})")

            if all(field != '' for field in [url, format_type]):
                print()
                print(f"CALL add_link('{url}','{format_type}','{book_title}', {release_date}')")
                print()

            for i in range(10, 13):
                if row[i] != '':
                    genre_name = row[i]
                    print(f"CALL add_genre_to_book('{book_title}', {release_date},'{genre_name}')")


def main():
    import_book_list_from_csv('jack')


if __name__ == '__main__':
    main()