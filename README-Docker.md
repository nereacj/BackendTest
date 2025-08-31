# 🐳 Despliegue en Docker - BackendTest

## 📋 Prerrequisitos

- Docker instalado en tu sistema
- Docker Compose (opcional, pero recomendado)

## 🚀 Opciones de Despliegue

### Opción 1: Usando Docker Compose (Recomendado)

```bash
# Construir y ejecutar con Docker Compose
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener
docker-compose down
```

### Opción 2: Usando Docker directamente

```bash
# Construir la imagen
docker build -t backend-test:latest .

# Ejecutar el contenedor
docker run -d --name backend-test-app -p 8080:8080 backend-test:latest

# Ver logs
docker logs -f backend-test-app

# Detener y eliminar
docker stop backend-test-app
docker rm backend-test-app
```

### Opción 3: Usando scripts automatizados

#### En Linux/Mac:
```bash
chmod +x deploy.sh
./deploy.sh
```

#### En Windows (PowerShell):
```powershell
.\deploy.ps1
```

## 🌐 Acceso a la Aplicación

Una vez desplegada, la aplicación estará disponible en:
- **URL principal:** http://localhost:8080
- **Endpoints disponibles:**
  - http://localhost:8080/api/saludo
  - http://localhost:8080/api/saludo/personalizado

## 🔧 Comandos Útiles

```bash
# Ver contenedores corriendo
docker ps

# Ver logs del contenedor
docker logs backend-test-app

# Entrar al contenedor (para debugging)
docker exec -it backend-test-app /bin/bash

# Ver estadísticas del contenedor
docker stats backend-test-app

# Reconstruir y reiniciar
docker-compose up -d --build
```

## 🛠️ Troubleshooting

### Si el puerto 8080 está ocupado:
```bash
# Cambiar puerto en docker-compose.yml
ports:
  - "8081:8080"  # Usar puerto 8081 en el host
```

### Si hay problemas de memoria:
```bash
# Agregar límites de memoria al docker-compose.yml
services:
  backend-test:
    # ... otras configuraciones
    deploy:
      resources:
        limits:
          memory: 512M
```

## 📁 Estructura de Archivos Docker

```
BackendTest/
├── Dockerfile              # Configuración de la imagen Docker
├── .dockerignore           # Archivos a excluir del build
├── docker-compose.yml      # Configuración de servicios
├── deploy.sh              # Script de despliegue (Linux/Mac)
├── deploy.ps1             # Script de despliegue (Windows)
└── README-Docker.md        # Este archivo
```

## ✅ Verificación del Despliegue

1. **Verificar que el contenedor está corriendo:**
   ```bash
   docker ps
   ```

2. **Verificar logs:**
   ```bash
   docker logs backend-test-app
   ```

3. **Probar endpoints:**
   ```bash
   curl http://localhost:8080/api/saludo
   curl http://localhost:8080/api/saludo/personalizado
   ```

## 🧹 Limpieza

```bash
# Eliminar contenedor e imagen
docker stop backend-test-app
docker rm backend-test-app
docker rmi backend-test:latest

# O usando Docker Compose
docker-compose down --rmi all
``` 