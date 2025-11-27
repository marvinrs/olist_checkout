#!/bin/bash

# Script para subir os containers do front e back
echo "🚀 Iniciando containers do Olist Checkout..."

# Verifica se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Erro: Docker não está rodando. Por favor, inicie o Docker Desktop."
    exit 1
fi

# Sobe os containers
echo "📦 Construindo e iniciando containers..."
docker compose up -d --build

# Aguarda os containers iniciarem
echo "⏳ Aguardando containers iniciarem..."
sleep 5

# Verifica o status
echo "📊 Status dos containers:"
docker compose ps

echo ""
echo "✅ Containers iniciados!"
echo ""
echo "🌐 Acesse:"
echo "   - Frontend: http://localhost:3000"
echo "   - Backend API: http://localhost:8000"
echo ""
echo "📝 Para ver os logs:"
echo "   - Backend: docker compose logs -f laravel"
echo "   - Frontend: docker compose logs -f nextjs"

