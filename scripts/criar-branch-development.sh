#!/bin/bash

echo "🌿 Criando branch development..."
echo ""

# Verificar se estamos em um repositório Git
if [ ! -d .git ]; then
    echo "❌ Este diretório não é um repositório Git"
    exit 1
fi

# Verificar se a branch já existe
if git show-ref --verify --quiet refs/heads/development; then
    echo "⚠️  A branch 'development' já existe"
    read -p "Deseja fazer checkout para ela? (s/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        git checkout development
        echo "✅ Checkout para branch development"
    else
        echo "Operação cancelada"
        exit 0
    fi
else
    # Criar e fazer checkout para a nova branch
    git checkout -b development
    echo "✅ Branch 'development' criada e checkout realizado"
fi

echo ""
echo "📋 Status atual:"
git status --short
echo ""

# Verificar se há alterações para commitar
if [ -n "$(git status --porcelain)" ]; then
    echo "➕ Adicionando arquivos..."
    git add .
    echo "✅ Arquivos adicionados"
    echo ""
    
    echo "💾 Fazendo commit na branch development..."
    git commit -m "feat: adiciona correções e melhorias

- Corrige erro JWT/Carbon convertendo valores para inteiros
- Corrige erro de preço no frontend (toFixed com strings)
- Adiciona página de criar novo produto
- Adiciona scripts para gerar e configurar chave SSH
- Melhora normalização de dados da API
- Atualiza configurações do Docker Compose"
    
    if [ $? -eq 0 ]; then
        echo "✅ Commit realizado com sucesso na branch development"
        echo ""
        
        # Perguntar se deseja fazer push
        read -p "Deseja fazer push da branch development? (s/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            echo "🚀 Fazendo push da branch development..."
            
            # Alterar remote para SSH se necessário
            CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null)
            if [[ "$CURRENT_REMOTE" == *"https://github.com"* ]]; then
                git remote set-url origin git@github.com:marvinrs/olist_checkout.git
            fi
            
            git push -u origin development
            
            if [ $? -eq 0 ]; then
                echo ""
                echo "✅ Push realizado com sucesso!"
                echo ""
                echo "🌿 Branch 'development' criada e enviada para o GitHub"
                echo "🌐 Ver em: https://github.com/marvinrs/olist_checkout/tree/development"
            else
                echo ""
                echo "❌ Erro ao fazer push"
                exit 1
            fi
        else
            echo ""
            echo "ℹ️  Branch criada localmente. Para fazer push depois:"
            echo "   git push -u origin development"
        fi
    else
        echo ""
        echo "⚠️  Nenhuma alteração para commitar"
    fi
else
    echo "ℹ️  Nenhuma alteração pendente para commitar"
fi

echo ""
echo "📊 Branches disponíveis:"
git branch -a

