# 🚀 Guía Completa de Despliegue - BackendTest

## 📋 Resumen del Proyecto

Aplicación Spring Boot con controladores REST para mostrar saludos.

### **Endpoints disponibles:**
- `GET /api/saludo` - Saludo básico
- `GET /api/saludo/personalizado` - Saludo personalizado

---

## 🐳 Despliegue con Docker + Git

### **Prerrequisitos:**
- Máquina virtual con acceso a internet
- Usuario con permisos sudo

---

## **1. Instalar Docker en la Máquina Virtual**

### **Ubuntu/Debian:**
```bash
# Actualizar repositorios
sudo apt update

# Instalar Docker
sudo apt install docker.io docker-compose

# Agregar usuario al grupo docker (para no usar sudo)
sudo usermod -aG docker $USER

# Reiniciar sesión o ejecutar:
newgrp docker

# Verificar instalación
docker --version
docker-compose --version
```

### **CentOS/RHEL:**
```bash
# Instalar Docker
sudo yum install docker docker-compose

# Habilitar y iniciar Docker
sudo systemctl enable docker
sudo systemctl start docker

# Agregar usuario al grupo
sudo usermod -aG docker $USER
newgrp docker

# Verificar
docker --version
```

---

## **2. Instalar Git en la Máquina Virtual**

```bash
# Ubuntu/Debian
sudo apt install git

# CentOS/RHEL
sudo yum install git

# Configurar Git (opcional pero recomendado)
git config --global user.name "Tu Nombre"
git config --global user.email "tu-email@example.com"

# Verificar instalación
git --version
```

---

## **3. Preparar el Proyecto Local con Docker**

### **Archivos necesarios en el proyecto:**

#### **Dockerfile:**
```dockerfile
# Multi-stage build para optimizar el tamaño de la imagen
FROM maven:3.9.5-openjdk-17 AS build

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración de Maven
COPY pom.xml .
COPY src ./src

# Compilar la aplicación
RUN mvn clean package -DskipTests

# Segunda etapa: imagen de ejecución
FROM openjdk:17-jre-slim

# Establecer directorio de trabajo
WORKDIR /app

# Copiar el JAR compilado desde la etapa anterior
COPY --from=build /app/target/backend-test-0.0.1-SNAPSHOT.jar app.jar

# Exponer puerto
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
```

#### **docker-compose.yml:**
```yaml
version: '3.8'

services:
  backend-test:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
    restart: unless-stopped
    container_name: backend-test-app
```

#### **.dockerignore:**
```dockerignore
# Archivos de Maven
target/
!target/*.jar

# Archivos de IDE
.idea/
*.iml
.vscode/
.settings/
.project
.classpath

# Archivos de sistema
.DS_Store
Thumbs.db

# Archivos de Git
.git/
.gitignore

# Archivos de Docker
Dockerfile
.dockerignore

# Logs
*.log

# Archivos temporales
*.tmp
*.temp
```

### **Subir a GitHub:**
```bash
# En tu máquina local
git add .
git commit -m "Agregar configuración Docker"
git push origin main
```

---

## **4. Clonar el Proyecto desde la Máquina Virtual**

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/BackendTest.git

# Entrar al directorio
cd BackendTest

# Verificar que están todos los archivos
ls -la
# Deberías ver: pom.xml, Dockerfile, docker-compose.yml, src/, etc.
```

---

## **5. Desplegar con Docker Compose**

```bash
# Construir y ejecutar en segundo plano
docker-compose up -d

# Ver logs en tiempo real (opcional)
docker-compose logs -f
```

---

## **6. Comprobaciones y Verificaciones**

### **Verificar que el contenedor está corriendo:**
```bash
# Ver contenedores activos
docker ps

# Deberías ver algo como:
# CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS         PORTS                    NAMES
# abc123def456   backend-test_app   "java -jar app.jar"      2 minutes ago   Up 2 minutes   0.0.0.0:8080->8080/tcp   backend-test-app
```

### **Verificar logs de la aplicación:**
```bash
# Ver logs del contenedor
docker logs backend-test-app

# Ver logs con Docker Compose
docker-compose logs -f
```

### **Probar los endpoints:**
```bash
# Probar desde dentro de la VM
curl http://localhost:8080/api/saludo
curl http://localhost:8080/api/saludo/personalizado

# Si tienes wget instalado
wget -qO- http://localhost:8080/api/saludo
```

### **Verificar desde el navegador:**
- Abrir navegador en la VM: `http://localhost:8080/api/saludo`
- Desde tu máquina local: `http://IP-DE-LA-VM:8080/api/saludo`

### **Verificar estadísticas del contenedor:**
```bash
# Ver uso de recursos
docker stats backend-test-app
```

---

## **7. Comandos Útiles para Gestión**

### **Detener la aplicación:**
```bash
# Desde la carpeta del proyecto
docker-compose down

# O desde cualquier lugar
docker stop backend-test-app
docker rm backend-test-app
```

### **Reiniciar después de cambios:**
```bash
# Reconstruir y reiniciar
docker-compose up -d --build
```

### **Ver logs en tiempo real:**
```bash
docker-compose logs -f
```

### **Entrar al contenedor (para debugging):**
```bash
docker exec -it backend-test-app /bin/bash
```

---

## **8. Flujo de Trabajo Completo**

```bash
# 1. Instalar dependencias
sudo apt update
sudo apt install docker.io docker-compose git

# 2. Configurar Docker
sudo usermod -aG docker $USER
newgrp docker

# 3. Clonar proyecto
git clone https://github.com/tu-usuario/BackendTest.git
cd BackendTest

# 4. Desplegar
docker-compose up -d

# 5. Verificar
docker ps
curl http://localhost:8080/api/saludo

# 6. Para actualizar (cuando hagas cambios en GitHub)
git pull
docker-compose up -d --build
```

---

## **✅ Checklist de Verificación**

- [ ] Docker instalado y funcionando
- [ ] Git instalado y configurado
- [ ] Proyecto clonado desde GitHub
- [ ] Contenedor corriendo (`docker ps`)
- [ ] Endpoints respondiendo (`curl http://localhost:8080/api/saludo`)
- [ ] Logs sin errores (`docker-compose logs`)

---

## **🔧 Troubleshooting**

### **Si el puerto 8080 está ocupado:**
```bash
# Cambiar puerto en docker-compose.yml
ports:
  - "8081:8080"  # Usar puerto 8081 en el host
```

### **Si hay problemas de permisos:**
```bash
# Verificar que el usuario está en el grupo docker
groups $USER

# Si no está, agregarlo
sudo usermod -aG docker $USER
newgrp docker
```

### **Si el contenedor no arranca:**
```bash
# Ver logs detallados
docker-compose logs

# Reconstruir imagen
docker-compose up -d --build
```

---

## **📚 Recursos Adicionales**

- [Documentación oficial de Docker](https://docs.docker.com/)
- [Documentación de Docker Compose](https://docs.docker.com/compose/)
- [Spring Boot Docker Guide](https://spring.io/guides/gs/spring-boot-docker/)

---

## **📞 Soporte**

Si tienes problemas con el despliegue:
1. Verifica que Docker esté instalado correctamente
2. Revisa los logs del contenedor
3. Asegúrate de que todos los archivos estén en el repositorio
4. Verifica que el puerto 8080 esté disponible 