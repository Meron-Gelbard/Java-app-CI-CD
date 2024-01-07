FROM maven:3.8.6-jdk-11-slim AS build

WORKDIR /app

COPY . .

RUN mvn clean package
RUN mvn install

FROM openjdk:11-jre-slim

COPY --from=build /app/target/my-app-1.0-SNAPSHOT.jar \
/app/java_app_version.txt \
 /app/target/my-app-1.0-SNAPSHOT.jar

CMD cat java_app_version.txt; java -jar /app/target/my-app-1.0-SNAPSHOT.jar
