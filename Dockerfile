FROM maven:latest

WORKDIR /app

COPY pom.xml ./
COPY deliver.sh ./
COPY src ./src

RUN mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

CMD ["sh", "deliver.sh"]
