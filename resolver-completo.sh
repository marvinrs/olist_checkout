#!/bin/bash

echo "🔧 Resolução completa do erro JWT/Carbon"
echo "=========================================="
echo ""

# 1. Parar todos os containers
echo "⏹️  Passo 1: Parando containers..."
docker compose stop laravel

# 2. Remover volumes de cache
echo "🧹 Passo 2: Removendo volumes de cache..."
docker volume rm olist_checkout_backend_bootstrap_cache 2>/dev/null && echo "   ✓ Volume backend_bootstrap_cache removido" || echo "   ⚠ Volume não existe"
docker volume rm olist_checkout_backend_storage 2>/dev/null && echo "   ✓ Volume backend_storage removido" || echo "   ⚠ Volume não existe (será recriado)"

# 3. Remover container
echo "🗑️  Passo 3: Removendo container..."
docker compose rm -f laravel

# 4. Reconstruir e iniciar
echo "🔨 Passo 4: Reconstruindo e iniciando container..."
docker compose up -d --build laravel

# 5. Aguardar container iniciar
echo "⏳ Passo 5: Aguardando container iniciar (10 segundos)..."
sleep 10

# 6. Verificar se container está rodando
echo "🔍 Passo 6: Verificando status do container..."
if ! docker compose ps laravel | grep -q "Up"; then
    echo "   ❌ Container não está rodando. Verifique os logs:"
    echo "   docker compose logs laravel"
    exit 1
fi
echo "   ✓ Container está rodando"

# 7. Limpar todos os caches
echo "🧹 Passo 7: Limpando todos os caches..."
docker compose exec laravel php artisan config:clear || echo "   ⚠ Erro ao limpar config cache"
docker compose exec laravel php artisan cache:clear || echo "   ⚠ Erro ao limpar cache"
docker compose exec laravel php artisan route:clear || echo "   ⚠ Erro ao limpar route cache"
docker compose exec laravel php artisan view:clear || echo "   ⚠ Erro ao limpar view cache"
docker compose exec laravel php artisan optimize:clear || echo "   ⚠ Erro ao limpar optimize cache"

# 8. Verificar configuração JWT
echo "🔍 Passo 8: Verificando configuração JWT..."
docker compose exec laravel php -r "
    require '/var/www/html/vendor/autoload.php';
    \$app = require_once '/var/www/html/bootstrap/app.php';
    \$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();
    echo 'JWT_TTL: ' . gettype(config('jwt.ttl')) . ' = ' . config('jwt.ttl') . PHP_EOL;
    echo 'JWT_REFRESH_TTL: ' . gettype(config('jwt.refresh_ttl')) . ' = ' . config('jwt.refresh_ttl') . PHP_EOL;
"

# 9. Testar login (opcional)
echo ""
echo "✅ Processo concluído!"
echo ""
echo "📋 Próximos passos:"
echo "   1. Acesse http://localhost:3000/login"
echo "   2. Tente fazer login"
echo "   3. Se o erro persistir, verifique os logs:"
echo "      docker compose logs -f laravel"
echo ""

