#!/bin/bash

echo "🔍 Verificando chave SSH..."
echo ""

# Chave fornecida pelo usuário (parece estar em base64)
CHAVE_BASE64="b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZWQyNTUxOQAAACAPZl+qzUBwwJZw1yJ4rizLrM4oSSw0IcsYfvPawYwc2wAAAJhu/7lxbv+5cQAAAAtzc2gtZWQyNTUxOQAAACAPZl+qzUBwwJZw1yJ4rizLrM4oSSw0IcsYfvPawYwc2wAAAEBYxu6HjmKLJA+jCLe3ig6BKY28KDbji3KhbcFnVDJ6ew9mX6rNQHDAlnDXIniuLMuszihJLDQhyxh+89rBjBzbAAAAD2dpdGh1Yi0yMDI1MTEyNwECAwQFBg=="

echo "📋 Tentando decodificar a chave..."
echo ""

# Decodificar base64
CHAVE_DECODIFICADA=$(echo "$CHAVE_BASE64" | base64 -d 2>/dev/null)

if [ $? -eq 0 ]; then
    echo "✓ Chave decodificada"
    echo ""
    echo "Conteúdo decodificado:"
    echo "$CHAVE_DECODIFICADA" | head -c 200
    echo "..."
    echo ""
else
    echo "❌ Erro ao decodificar"
fi

echo ""
echo "🔑 Vamos gerar uma nova chave SSH no formato correto:"
echo ""

# Verificar se já existe uma chave
if [ -f ~/.ssh/id_ed25519_github.pub ]; then
    echo "📋 Chave existente encontrada:"
    echo "----------------------------------------"
    cat ~/.ssh/id_ed25519_github.pub
    echo "----------------------------------------"
    echo ""
    echo "✅ Use esta chave acima no GitHub"
else
    echo "Gerando nova chave SSH Ed25519..."
    ssh-keygen -t ed25519 -C "github-$(date +%Y%m%d)" -f ~/.ssh/id_ed25519_github -N ""
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Chave gerada com sucesso!"
        echo ""
        echo "📋 Sua chave pública (copie e cole no GitHub):"
        echo "----------------------------------------"
        cat ~/.ssh/id_ed25519_github.pub
        echo "----------------------------------------"
        echo ""
    fi
fi

