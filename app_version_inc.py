# Script for incrementing the patch version of the Java App.

with open('java_app_version.txt', "r") as v_file:
    text = v_file.read()
    current_version = text.split(" ")[3]
    current_version = current_version.split(".")

current_version[2] = str(int(current_version[2]) + 1)
new_version = ".".join(current_version[:])

with open('java_app_version.txt', "w") as v_file:
    new_text = (" ".join(text.split(" ")[:3])) + f" {new_version}"
    v_file.write(new_text)

print(new_version)
