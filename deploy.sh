#!/bin/bash

echo "🚀 Iniciando despliegue de BackendTest en Docker..."

# Construir la imagen Docker
echo "📦 Construyendo imagen Docker..."
docker build -t backend-test:latest .

# Verificar si la construcción fue exitosa
if [ $? -eq 0 ]; then
    echo "✅ Imagen construida exitosamente"
    
    # Detener contenedor existente si está corriendo
    echo "🛑 Deteniendo contenedor existente..."
    docker stop backend-test-app 2>/dev/null || true
    docker rm backend-test-app 2>/dev/null || true
    
    # Ejecutar el contenedor
    echo "▶️  Iniciando contenedor..."
    docker run -d \
        --name backend-test-app \
        -p 8080:8080 \
        --restart unless-stopped \
        backend-test:latest
    
    echo "✅ Aplicación desplegada exitosamente!"
    echo "🌐 Accede a la aplicación en: http://localhost:8080"
    echo "📋 Endpoints disponibles:"
    echo "   - http://localhost:8080/api/saludo"
    echo "   - http://localhost:8080/api/saludo/personalizado"
    
else
    echo "❌ Error al construir la imagen Docker"
    exit 1
fi 