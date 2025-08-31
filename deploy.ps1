Write-Host "🚀 Iniciando despliegue de BackendTest en Docker..." -ForegroundColor Green

# Construir la imagen Docker
Write-Host "📦 Construyendo imagen Docker..." -ForegroundColor Yellow
docker build -t backend-test:latest .

# Verificar si la construcción fue exitosa
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Imagen construida exitosamente" -ForegroundColor Green
    
    # Detener contenedor existente si está corriendo
    Write-Host "🛑 Deteniendo contenedor existente..." -ForegroundColor Yellow
    docker stop backend-test-app 2>$null
    docker rm backend-test-app 2>$null
    
    # Ejecutar el contenedor
    Write-Host "▶️  Iniciando contenedor..." -ForegroundColor Yellow
    docker run -d `
        --name backend-test-app `
        -p 8080:8080 `
        --restart unless-stopped `
        backend-test:latest
    
    Write-Host "✅ Aplicación desplegada exitosamente!" -ForegroundColor Green
    Write-Host "🌐 Accede a la aplicación en: http://localhost:8080" -ForegroundColor Cyan
    Write-Host "📋 Endpoints disponibles:" -ForegroundColor Cyan
    Write-Host "   - http://localhost:8080/api/saludo" -ForegroundColor White
    Write-Host "   - http://localhost:8080/api/saludo/personalizado" -ForegroundColor White
    
} else {
    Write-Host "❌ Error al construir la imagen Docker" -ForegroundColor Red
    exit 1
} 