#!/bin/bash

echo "📦 Preparando commit e push..."
echo ""

# Verificar se estamos em um repositório Git
if [ ! -d .git ]; then
    echo "❌ Este diretório não é um repositório Git"
    exit 1
fi

# Alterar remote para SSH (se ainda estiver em HTTPS)
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null)
if [[ "$CURRENT_REMOTE" == *"https://github.com"* ]]; then
    echo "🔄 Alterando remote de HTTPS para SSH..."
    git remote set-url origin git@github.com:marvinrs/olist_checkout.git
    echo "✅ Remote alterado para SSH"
    echo ""
fi

# Verificar status
echo "📋 Status do repositório:"
git status --short
echo ""

# Adicionar todos os arquivos
echo "➕ Adicionando arquivos..."
git add .
echo "✅ Arquivos adicionados"
echo ""

# Fazer commit
echo "💾 Fazendo commit..."
git commit -m "feat: adiciona correções e melhorias

- Corrige erro JWT/Carbon convertendo valores para inteiros
- Corrige erro de preço no frontend (toFixed com strings)
- Adiciona página de criar novo produto
- Adiciona scripts para gerar e configurar chave SSH
- Melhora normalização de dados da API
- Atualiza configurações do Docker Compose"

if [ $? -eq 0 ]; then
    echo "✅ Commit realizado com sucesso"
    echo ""
    
    # Fazer push
    echo "🚀 Fazendo push para o GitHub..."
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Push realizado com sucesso!"
        echo ""
        echo "🌐 Repositório atualizado em:"
        echo "   https://github.com/marvinrs/olist_checkout"
    else
        echo ""
        echo "❌ Erro ao fazer push"
        echo "   Verifique se a chave SSH está configurada corretamente"
        exit 1
    fi
else
    echo ""
    echo "⚠️  Nenhuma alteração para commitar"
    exit 0
fi

