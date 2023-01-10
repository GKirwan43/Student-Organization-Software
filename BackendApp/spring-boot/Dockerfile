FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} spring-boot-complete-1.0.0-Dev.jar
ENTRYPOINT ["java","-jar","/spring-boot-complete-1.0.0-Dev.jar"]