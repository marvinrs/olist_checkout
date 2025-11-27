#!/bin/bash

# Script para corrigir o erro do JWT/Carbon
echo "🔧 Corrigindo erro do JWT/Carbon..."

# Limpa o cache de configuração
echo "🧹 Limpando cache de configuração..."
docker compose exec laravel php artisan config:clear

# Limpa o cache geral
echo "🧹 Limpando cache geral..."
docker compose exec laravel php artisan cache:clear

# Limpa o cache de rotas
echo "🧹 Limpando cache de rotas..."
docker compose exec laravel php artisan route:clear

# Limpa o cache de views
echo "🧹 Limpando cache de views..."
docker compose exec laravel php artisan view:clear

# Reinicia o container para garantir que tudo está atualizado
echo "🔄 Reiniciando container do Laravel..."
docker compose restart laravel

echo ""
echo "✅ Cache limpo e container reiniciado!"
echo "🌐 Tente fazer login novamente em http://localhost:3000"

