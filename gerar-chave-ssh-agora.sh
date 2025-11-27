#!/bin/bash

echo "🔑 Gerando chave SSH para GitHub..."
echo ""

# Criar diretório .ssh se não existir
if [ ! -d ~/.ssh ]; then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    echo "✓ Diretório ~/.ssh criado"
fi

# Gerar chave SSH Ed25519
echo "Gerando chave SSH Ed25519..."
ssh-keygen -t ed25519 -C "github-$(date +%Y%m%d)" -f ~/.ssh/id_ed25519_github -N ""

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Chave SSH gerada com sucesso!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 SUA CHAVE PÚBLICA (COPIE TUDO ABAIXO):"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    cat ~/.ssh/id_ed25519_github.pub
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📝 PRÓXIMOS PASSOS:"
    echo "1. Copie a chave pública acima (linha completa)"
    echo "2. Acesse: https://github.com/settings/keys"
    echo "3. Clique em 'New SSH key'"
    echo "4. Título: Digite um nome (ex: 'Meu Computador')"
    echo "5. Key type: Selecione 'Authentication Key'"
    echo "6. Key: Cole a chave completa que você copiou"
    echo "7. Clique em 'Add SSH key'"
    echo ""
    echo "💡 Para testar a conexão depois:"
    echo "   ssh -T git@github.com"
    echo ""
else
    echo "❌ Erro ao gerar a chave SSH"
    exit 1
fi

