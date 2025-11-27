#!/bin/bash

echo "🔑 Gerando chave SSH para GitHub..."
echo ""

# Verifica se o diretório .ssh existe
if [ ! -d ~/.ssh ]; then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    echo "✓ Diretório ~/.ssh criado"
fi

# Gera a chave SSH Ed25519 (recomendado pelo GitHub)
echo "Gerando chave SSH Ed25519..."
ssh-keygen -t ed25519 -C "github-$(date +%Y%m%d)" -f ~/.ssh/id_ed25519_github -N ""

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Chave SSH gerada com sucesso!"
    echo ""
    echo "📋 Sua chave pública está em: ~/.ssh/id_ed25519_github.pub"
    echo ""
    echo "📝 Conteúdo da chave pública:"
    echo "----------------------------------------"
    cat ~/.ssh/id_ed25519_github.pub
    echo "----------------------------------------"
    echo ""
    echo "📋 Próximos passos:"
    echo "1. Copie o conteúdo da chave pública acima"
    echo "2. Acesse: https://github.com/settings/keys"
    echo "3. Clique em 'New SSH key'"
    echo "4. Cole a chave pública e salve"
    echo ""
    echo "💡 Para usar esta chave, adicione ao ~/.ssh/config:"
    echo "Host github.com"
    echo "  HostName github.com"
    echo "  User git"
    echo "  IdentityFile ~/.ssh/id_ed25519_github"
    echo ""
else
    echo "❌ Erro ao gerar a chave SSH"
    exit 1
fi

