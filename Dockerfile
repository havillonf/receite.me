FROM maven:3.8.1-openjdk-17
ARG JAR_FILE=target/*.jar
COPY ./target/receite.me-1.0-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]