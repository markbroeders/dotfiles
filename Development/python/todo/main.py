import time

import functions

now = time.strftime("%b %d, %Y %H:%M:%S")
print("It is", now)

while True:
    user_action = input("Type add, show, edit, complete, or exit: ").strip()

    if user_action.startswith("add"):
        todo = user_action[4:]

        todos = functions.get_todos()
        todos.append(todo + "\n")

        functions.write_todos(todos)

    elif user_action.startswith("show"):
        todos = functions.get_todos()

        #   new_todos = [item.strip("\n") for item in todos]

        for index, item in enumerate(todos):
            item = item.strip("\n")
            row = f"{index + 1}-{item.title()}"
            print(row)

    elif user_action.startswith("edit"):
        try:
            number = int(user_action[5:])
            number -= 1

            todos = functions.get_todos()
            todos[number]  # Messy try code
            new_todo = input("Enter a new todo: ")
            todos[number] = new_todo + "\n"

            functions.write_todos(todos)

        except ValueError:
            print("Your command is not valid")
            continue
        except IndexError:
            print("You've entered an invalid number")

    elif user_action.startswith("complete"):
        try:
            number = int(user_action[9:])
            number -= 1

            todos = functions.get_todos()
            todo_to_remove = todos[number].strip("\n")

            if number > 0 and number < len(todos):
                todos.pop(number)

                functions.write_todos(todos)

                message = f"Todo {todo_to_remove} was removed from the list"
                print(message)
        except ValueError:
            print("Your command is not valid")
        except IndexError:
            print("You've entered an invalid number")
            continue

    elif user_action.startswith("exit"):
        break

    else:
        print("Command is not valid.")

print("Bye!")
