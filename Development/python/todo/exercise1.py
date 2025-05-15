f = open("members.txt", "r")
members = f.readlines()
f.close()

member = input("Enter a new member: ")
members.append(member + "\n")

f = open("members.txt", "w")
f.writelines(members)
f.close()
