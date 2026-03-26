# ---------------------------------------------------
# Estágio 1 - Build
# ---------------------------------------------------
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

# 1. Copia o pom.xml da raiz
COPY pom.xml .

# 2. Baixa as dependências
RUN mvn dependency:go-offline -B

# 3. CORREÇÃO: Copia a pasta src que está dentro de 'backend'
# para a pasta 'src' dentro do container
COPY backend-app/src ./src

# 4. Executa o build
RUN mvn clean package -DskipTests

# ---------------------------------------------------
# Estágio 2 - Execução
# ---------------------------------------------------
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# O Maven gera o jar na pasta target da raiz do build
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENV JAVA_OPTS="-Xmx300m -Xss512k"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]