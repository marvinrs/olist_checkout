#!/bin/bash

# Script para corrigir problemas com o Next.js
echo "🔧 Corrigindo problemas do Next.js..."

# Para o container do Next.js
echo "⏹️  Parando container do Next.js..."
docker compose stop nextjs

# Remove o container
echo "🗑️  Removendo container do Next.js..."
docker compose rm -f nextjs

# Remove o volume do .next (cache corrompido)
echo "🧹 Limpando cache do Next.js..."
docker volume rm olist_checkout_nextjs_next 2>/dev/null || echo "Volume já removido ou não existe"

# Reconstrói e inicia o container
echo "🔨 Reconstruindo container do Next.js..."
docker compose up -d --build nextjs

# Aguarda o container iniciar
echo "⏳ Aguardando Next.js iniciar..."
sleep 10

# Mostra os logs
echo "📋 Últimos logs do Next.js:"
docker compose logs --tail 30 nextjs

echo ""
echo "✅ Pronto! Acesse http://localhost:3000"
echo "📝 Para ver os logs em tempo real: docker compose logs -f nextjs"

