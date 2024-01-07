FROM maven:3.8.6-jdk-11-slim AS build

WORKDIR /app

COPY . .

RUN mvn clean package

FROM openjdk:11-jre-slim

COPY --from=build /app/java_app_version.txt ./java_app_version.txt

ENV VERSION=$(cat java_app_version.txt | awk '{print $4}')

COPY --from=build /app/target/my-app-$VERSION.jar /app/target/my-app-$VERSION.jar

CMD ["java","-jar","/app/target/my-app-$VERSION.jar"]
