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

# Inject version into pom.xml
with open("pom.xml", "r") as pomfile:
    pom_script = pomfile.readlines()

for i in range(len(pom_script)):
    if "<version>" in pom_script[i]:
        pom_script[i] = f"  <version>{new_version}</version>\n"
        break

with open("pom.xml", "w") as new_pomfile:
    new_pomfile.writelines(pom_script)

# Output new version for use in pipeline
print(new_version)
