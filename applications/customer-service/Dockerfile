FROM eclipse-temurin:21-jre
WORKDIR /app
COPY target/customer-service-*.jar app.jar
USER 10001
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
