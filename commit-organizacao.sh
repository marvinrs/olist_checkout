#!/bin/bash

echo "📦 Preparando commit da organização de arquivos..."
echo ""

# Verificar se estamos em um repositório Git
if [ ! -d .git ]; then
    echo "❌ Este diretório não é um repositório Git"
    exit 1
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
git commit -m "refactor: organiza documentos e scripts em estrutura de pastas

- Cria estrutura meta-spec com pastas technical, business e repos
- Move todos os scripts .sh para pasta scripts/
- Organiza documentação técnica em meta-spec/technical
- Organiza documentação de repositório em meta-spec/repos
- Atualiza referências nos documentos para novos caminhos
- Remove arquivos duplicados da raiz do projeto"

if [ $? -eq 0 ]; then
    echo "✅ Commit realizado com sucesso!"
    echo ""
    echo "📝 Para fazer push, execute:"
    echo "   git push origin main"
    echo "   ou"
    echo "   git push origin development"
else
    echo ""
    echo "⚠️  Nenhuma alteração para commitar"
    exit 0
fi

