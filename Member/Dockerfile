FROM openjdk:17

ARG JAR_FILE=*.jar
COPY ./build/libs/*.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]
EXPOSE 8080
