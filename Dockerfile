FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

COPY pom.xml ./
COPY deliver.sh ./
COPY src ./src

CMD ["sh", "deliver.sh"]
