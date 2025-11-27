#!/bin/bash

echo "🔍 Testando conexão SSH com GitHub..."
echo ""

# Testar conexão
ssh -T git@github.com 2>&1

echo ""
echo "✅ Se você viu 'Hi username! You've successfully authenticated...'"
echo "   significa que está funcionando perfeitamente!"
echo ""
echo "❌ Se apareceu erro, verifique:"
echo "   1. A chave foi adicionada corretamente no GitHub"
echo "   2. O arquivo ~/.ssh/id_ed25519_github existe"
echo "   3. As permissões estão corretas (chmod 600)"

