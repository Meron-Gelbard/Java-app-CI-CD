FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

COPY .mvn/ .mvn
COPY deliver.sh pom.xml ./
COPY src ./src

CMD ["sh", "deliver.sh"]
