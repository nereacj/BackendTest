# BackendTest

Un proyecto Spring Boot básico creado con Java 17 y Maven.

## Requisitos

- Java 17 o superior
- Maven 3.6 o superior

## Estructura del Proyecto

```
BackendTest/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── example/
│   │   │           └── backendtest/
│   │   │               ├── BackendTestApplication.java
│   │   │               └── controller/
│   │   │                   └── HelloController.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/
│           └── com/
│               └── example/
│                   └── backendtest/
│                       └── BackendTestApplicationTests.java
├── pom.xml
└── README.md
```

## Cómo ejecutar

1. **Compilar el proyecto:**
   ```bash
   mvn clean compile
   ```

2. **Ejecutar la aplicación:**
   ```bash
   mvn spring-boot:run
   ```

3. **Ejecutar las pruebas:**
   ```bash
   mvn test
   ```

## Endpoints disponibles

Una vez que la aplicación esté ejecutándose, puedes acceder a:

- `http://localhost:8080/api/hello` - Mensaje de bienvenida
- `http://localhost:8080/api/status` - Estado de la aplicación

## Configuración

La aplicación se ejecuta por defecto en el puerto 8080. Puedes modificar la configuración en `src/main/resources/application.properties`.

## Tecnologías utilizadas

- Spring Boot 3.2.0
- Java 17
- Maven
- Spring Web
- Spring Boot DevTools 