#!/bin/bash

echo "🔧 Resolvendo erro do JWT/Carbon..."
echo ""

# Para o container
echo "⏹️  Parando container do Laravel..."
docker compose stop laravel

# Remove o volume de cache do bootstrap (onde está o cache de configuração)
echo "🧹 Removendo volume de cache do bootstrap..."
docker volume rm olist_checkout_backend_bootstrap_cache 2>/dev/null || echo "Volume não existe ou já foi removido"

# Inicia o container
echo "🚀 Iniciando container do Laravel..."
docker compose up -d laravel

# Aguarda o container iniciar
echo "⏳ Aguardando container iniciar..."
sleep 5

# Limpa todos os caches
echo "🧹 Limpando caches do Laravel..."
docker compose exec laravel php artisan config:clear
docker compose exec laravel php artisan cache:clear
docker compose exec laravel php artisan route:clear
docker compose exec laravel php artisan view:clear
docker compose exec laravel php artisan optimize:clear

# Recarrega a configuração
echo "🔄 Recarregando configuração..."
docker compose exec laravel php artisan config:cache

echo ""
echo "✅ Processo concluído!"
echo ""
echo "📋 Verificando configuração do JWT..."
docker compose exec laravel php artisan tinker --execute="echo 'JWT_TTL: ' . config('jwt.ttl') . PHP_EOL; echo 'JWT_REFRESH_TTL: ' . config('jwt.refresh_ttl') . PHP_EOL;"
echo ""
echo "🌐 Tente fazer login novamente em http://localhost:3000"

