#!/bin/bash

echo "🔧 Resolvendo problema de SSH e fazendo commit/push..."
echo ""

# Verificar se estamos em um repositório Git
if [ ! -d .git ]; then
    echo "❌ Este diretório não é um repositório Git"
    exit 1
fi

# Verificar branch atual
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
echo "📍 Branch atual: $CURRENT_BRANCH"
echo ""

# Verificar se estamos na branch development, se não, mudar
if [ "$CURRENT_BRANCH" != "development" ]; then
    echo "🔄 Mudando para a branch development..."
    if git show-ref --verify --quiet refs/heads/development; then
        git checkout development
        echo "✅ Checkout para branch development"
    else
        git checkout -b development
        echo "✅ Branch 'development' criada"
    fi
    echo ""
fi

# Verificar status do SSH
echo "🔍 Verificando configuração SSH..."
SSH_TEST=$(ssh -T git@github.com 2>&1)

if echo "$SSH_TEST" | grep -q "successfully authenticated"; then
    echo "✅ SSH está funcionando corretamente!"
    USE_SSH=true
elif echo "$SSH_TEST" | grep -q "Permission denied"; then
    echo "❌ SSH não está configurado corretamente"
    echo ""
    echo "📋 Opções:"
    echo "   1. Configurar SSH agora (recomendado)"
    echo "   2. Usar HTTPS temporariamente para fazer commit/push"
    echo ""
    read -p "Escolha uma opção (1 ou 2): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[1]$ ]]; then
        echo ""
        echo "🔑 Configurando SSH..."
        
        # Verificar se a chave existe
        if [ ! -f ~/.ssh/id_ed25519_github ]; then
            echo "📝 Gerando nova chave SSH..."
            mkdir -p ~/.ssh
            chmod 700 ~/.ssh
            ssh-keygen -t ed25519 -C "github-$(date +%Y%m%d)" -f ~/.ssh/id_ed25519_github -N ""
            
            if [ $? -eq 0 ]; then
                echo ""
                echo "✅ Chave gerada com sucesso!"
                echo ""
                echo "📋 SUA CHAVE PÚBLICA (copie e adicione no GitHub):"
                echo "----------------------------------------"
                cat ~/.ssh/id_ed25519_github.pub
                echo "----------------------------------------"
                echo ""
                echo "🌐 Adicione esta chave em: https://github.com/settings/keys"
                echo ""
                read -p "Pressione Enter após adicionar a chave no GitHub..."
            fi
        else
            echo "📋 Chave SSH encontrada. Mostrando chave pública:"
            echo "----------------------------------------"
            cat ~/.ssh/id_ed25519_github.pub
            echo "----------------------------------------"
            echo ""
            echo "🌐 Verifique se esta chave está adicionada em: https://github.com/settings/keys"
            echo ""
            read -p "Pressione Enter para continuar..."
        fi
        
        # Configurar SSH config
        echo ""
        echo "📝 Configurando ~/.ssh/config..."
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
        
        # Remover configuração antiga do GitHub se existir
        if [ -f ~/.ssh/config ]; then
            grep -v "Host github.com" ~/.ssh/config > ~/.ssh/config.tmp 2>/dev/null || true
            mv ~/.ssh/config.tmp ~/.ssh/config 2>/dev/null || true
        fi
        
        # Adicionar nova configuração
        cat >> ~/.ssh/config << 'EOF'

# GitHub
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github
  IdentitiesOnly yes
EOF
        
        chmod 600 ~/.ssh/config
        chmod 600 ~/.ssh/id_ed25519_github 2>/dev/null || true
        
        echo "✅ Configuração SSH atualizada"
        echo ""
        echo "🔍 Testando conexão SSH..."
        ssh -T git@github.com 2>&1
        
        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            echo "✅ SSH configurado com sucesso!"
            USE_SSH=true
        else
            echo "⚠️  SSH ainda não está funcionando. Usando HTTPS temporariamente..."
            USE_SSH=false
        fi
    else
        USE_SSH=false
    fi
else
    USE_SSH=false
fi

echo ""

# Configurar remote baseado na escolha
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null)

if [ "$USE_SSH" = true ]; then
    if [[ "$CURRENT_REMOTE" == *"https://github.com"* ]]; then
        echo "🔄 Alterando remote de HTTPS para SSH..."
        git remote set-url origin git@github.com:marvinrs/olist_checkout.git
        echo "✅ Remote alterado para SSH"
    fi
else
    if [[ "$CURRENT_REMOTE" == *"git@github.com"* ]]; then
        echo "🔄 Alterando remote de SSH para HTTPS (temporário)..."
        git remote set-url origin https://github.com/marvinrs/olist_checkout.git
        echo "✅ Remote alterado para HTTPS"
    fi
fi

echo ""

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
    echo "🚀 Fazendo push da branch development..."
    git push -u origin development
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Push realizado com sucesso!"
        echo ""
        echo "🌿 Branch 'development' atualizada no GitHub"
        echo "🌐 Ver em: https://github.com/marvinrs/olist_checkout/tree/development"
        
        if [ "$USE_SSH" = false ]; then
            echo ""
            echo "💡 Dica: Configure SSH para não precisar digitar credenciais:"
            echo "   ./configurar-git-ssh.sh"
        fi
    else
        echo ""
        echo "❌ Erro ao fazer push"
        if [ "$USE_SSH" = false ]; then
            echo "   Você pode precisar configurar credenciais do GitHub"
            echo "   ou configurar SSH: ./configurar-git-ssh.sh"
        fi
        exit 1
    fi
else
    echo ""
    echo "⚠️  Nenhuma alteração para commitar"
    exit 0
fi

