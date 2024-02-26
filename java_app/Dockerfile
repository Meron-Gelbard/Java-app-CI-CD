FROM maven:3.8.6-jdk-11-slim AS build

WORKDIR /app

COPY . .

RUN mvn clean package

FROM openjdk:11-jre-slim

ARG VERSION_ARG

ENV VERSION=${VERSION_ARG}


COPY --from=build /app/target/*.jar /app/target/

CMD java -jar /app/target/*.jar
