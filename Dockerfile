FROM maven:latest

WORKDIR /app

COPY pom.xml ./
COPY deliver.sh ./
COPY src ./src

CMD ["sh", "deliver.sh"]
