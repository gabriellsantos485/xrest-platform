# Estágio de Build
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# 1. Copia a pasta inteira do backend para dentro de /app/backend-app
COPY backend-app ./backend-app

# 2. Muda o diretório de trabalho para onde o pom.xml realmente está
WORKDIR /app/backend-app

# 3. Executa o build (o Maven vai encontrar o src/ e o pom.xml aqui)
RUN mvn clean package -DskipTests

# Estágio de Execução
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# 4. Busca o JAR gerado dentro da pasta target do backend-app
COPY --from=build /app/backend-app/target/*.jar app.jar

EXPOSE 8080

ENV JAVA_OPTS="-Xmx300m -Xss512k"

ENTRYPOINT ["java", "-Xmx300m", "-Xss512k", "-Dlogging.level.org.hibernate=DEBUG", "-jar", "app.jar"]