#!/bin/bash

echo "⚙️  Configurando Git para usar a chave SSH do GitHub..."
echo ""

# Verificar se a chave existe
if [ ! -f ~/.ssh/id_ed25519_github ]; then
    echo "❌ Chave SSH não encontrada em ~/.ssh/id_ed25519_github"
    echo "   Execute primeiro: ./gerar-chave-ssh-agora.sh"
    exit 1
fi

# Criar ou atualizar arquivo config do SSH
echo "📝 Configurando ~/.ssh/config..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Adicionar configuração para GitHub
cat >> ~/.ssh/config << 'EOF'

# GitHub
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github
  IdentitiesOnly yes
EOF

chmod 600 ~/.ssh/config

echo "✅ Configuração adicionada ao ~/.ssh/config"
echo ""
echo "📋 Testando conexão..."
ssh -T git@github.com 2>&1

echo ""
echo "✅ Configuração concluída!"
echo ""
echo "💡 Agora você pode usar Git com SSH:"
echo "   git clone git@github.com:usuario/repositorio.git"
echo "   git remote set-url origin git@github.com:usuario/repositorio.git"

