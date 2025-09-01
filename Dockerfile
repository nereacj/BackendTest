# Multi-stage build para optimizar el tamaño de la imagen
FROM maven:3.9.5 AS build

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración de Maven
COPY pom.xml .
COPY src ./src

# Compilar la aplicación
RUN mvn clean package -DskipTests

# Segunda etapa: imagen de ejecución
FROM openjdk:17-slim

# Establecer directorio de trabajo
WORKDIR /app

# Copiar el JAR compilado desde la etapa anterior
COPY --from=build /app/target/backend-test-0.0.1-SNAPSHOT.jar app.jar

# Exponer puerto
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"] 