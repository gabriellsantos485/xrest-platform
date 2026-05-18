# Etapa 1: Build
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Runtime
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["sh", "-c", "java \
  -Dspring.datasource.url=${SPRING_DATASOURCE_URL} \
  -Dspring.datasource.username=${SPRING_DATASOURCE_USERNAME} \
  -Dspring.datasource.password=${SPRING_DATASOURCE_PASSWORD} \
  -Dspring.datasource.driver-class-name=org.postgresql.Driver \
  -Dspring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect \
  -jar app.jar"]