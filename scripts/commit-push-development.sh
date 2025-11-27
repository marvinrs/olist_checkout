#!/bin/bash

echo "🌿 Commit e push na branch development..."
echo ""

# Verificar se estamos em um repositório Git
if [ ! -d .git ]; then
    echo "❌ Este diretório não é um repositório Git"
    exit 1
fi

# Verificar se estamos na branch development
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "development" ]; then
    echo "⚠️  Você está na branch '$CURRENT_BRANCH'"
    echo "🔄 Mudando para a branch development..."
    
    # Verificar se a branch existe
    if git show-ref --verify --quiet refs/heads/development; then
        git checkout development
        echo "✅ Checkout para branch development"
    else
        echo "📝 Criando branch development..."
        git checkout -b development
        echo "✅ Branch 'development' criada"
    fi
    echo ""
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

# Verificar se há alterações
if [ -z "$(git status --porcelain)" ]; then
    echo "ℹ️  Nenhuma alteração para commitar"
    exit 0
fi

# Adicionar todos os arquivos
echo "➕ Adicionando arquivos..."
git add .
echo "✅ Arquivos adicionados"
echo ""

# Fazer commit
echo "💾 Fazendo commit na branch development..."
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
    echo "🚀 Fazendo push da branch development para o GitHub..."
    git push -u origin development
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Push realizado com sucesso!"
        echo ""
        echo "🌿 Branch 'development' atualizada no GitHub"
        echo "🌐 Ver em: https://github.com/marvinrs/olist_checkout/tree/development"
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

