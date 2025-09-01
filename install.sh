#!/bin/bash

echo "🚀 Instalación Automática de BackendTest con Docker"
echo "=================================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para imprimir con colores
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si estamos ejecutando como root
if [[ $EUID -eq 0 ]]; then
   print_error "Este script no debe ejecutarse como root"
   exit 1
fi

# 1. Actualizar repositorios
print_status "Actualizando repositorios..."
sudo apt update

# 2. Instalar Docker
print_status "Instalando Docker..."
sudo apt install -y docker.io docker-compose

# 3. Instalar Git
print_status "Instalando Git..."
sudo apt install -y git

# 4. Configurar Docker
print_status "Configurando Docker..."
sudo usermod -aG docker $USER
newgrp docker

# 5. Verificar instalaciones
print_status "Verificando instalaciones..."

if command -v docker &> /dev/null; then
    print_status "Docker instalado: $(docker --version)"
else
    print_error "Docker no se instaló correctamente"
    exit 1
fi

if command -v docker-compose &> /dev/null; then
    print_status "Docker Compose instalado: $(docker-compose --version)"
else
    print_error "Docker Compose no se instaló correctamente"
    exit 1
fi

if command -v git &> /dev/null; then
    print_status "Git instalado: $(git --version)"
else
    print_error "Git no se instaló correctamente"
    exit 1
fi

# 6. Solicitar URL del repositorio
echo ""
print_status "Ingresa la URL de tu repositorio GitHub:"
read -p "URL del repositorio: " REPO_URL

if [ -z "$REPO_URL" ]; then
    print_error "URL del repositorio no puede estar vacía"
    exit 1
fi

# 7. Crear directorio de aplicaciones y clonar repositorio
print_status "Creando directorio de aplicaciones..."
mkdir -p $HOME/apps
cd $HOME/apps

print_status "Clonando repositorio..."
git clone $REPO_URL backend-test
cd backend-test

# 8. Verificar archivos necesarios
print_status "Verificando archivos del proyecto..."

if [ ! -f "Dockerfile" ]; then
    print_error "Dockerfile no encontrado"
    exit 1
fi

if [ ! -f "docker-compose.yml" ]; then
    print_error "docker-compose.yml no encontrado"
    exit 1
fi

if [ ! -f "pom.xml" ]; then
    print_error "pom.xml no encontrado"
    exit 1
fi

print_status "Todos los archivos necesarios encontrados"

# 9. Desplegar con Docker Compose
print_status "Desplegando aplicación..."
docker-compose up -d

# 10. Esperar a que la aplicación arranque
print_status "Esperando a que la aplicación arranque..."
sleep 10

# 11. Verificar que el contenedor está corriendo
if docker ps | grep -q "backend-test-app"; then
    print_status "✅ Contenedor corriendo correctamente"
else
    print_error "❌ Contenedor no está corriendo"
    print_status "Revisando logs..."
    docker-compose logs
    exit 1
fi

# 12. Probar endpoints
print_status "Probando endpoints..."

# Esperar un poco más para que Spring Boot termine de arrancar
sleep 5

# Probar endpoint
if curl -s http://localhost:8080/api/saludo > /dev/null; then
    print_status "✅ Endpoint /api/saludo funcionando"
    print_status "Respuesta: $(curl -s http://localhost:8080/api/saludo)"
else
    print_warning "⚠️  Endpoint /api/saludo no responde"
fi

if curl -s http://localhost:8080/api/saludo/personalizado > /dev/null; then
    print_status "✅ Endpoint /api/saludo/personalizado funcionando"
    print_status "Respuesta: $(curl -s http://localhost:8080/api/saludo/personalizado)"
else
    print_warning "⚠️  Endpoint /api/saludo/personalizado no responde"
fi

# 13. Mostrar información final
echo ""
echo "🎉 ¡Instalación completada!"
echo "=========================="
echo ""
print_status "Aplicación desplegada en: http://localhost:8080"
print_status "Endpoints disponibles:"
echo "  - http://localhost:8080/api/saludo"
echo "  - http://localhost:8080/api/saludo/personalizado"
echo ""
print_status "Comandos útiles:"
echo "  - Ver logs: docker-compose logs -f"
echo "  - Detener: docker-compose down"
echo "  - Reiniciar: docker-compose up -d --build"
echo ""
print_status "Para acceder desde fuera de la VM:"
echo "  - http://$(hostname -I | awk '{print $1}'):8080/api/saludo"
echo ""

# 14. Mostrar estado del contenedor
print_status "Estado actual del contenedor:"
docker ps | grep backend-test-app 