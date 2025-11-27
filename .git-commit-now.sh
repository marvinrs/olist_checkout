#!/bin/bash
cd "$(dirname "$0")"
git add .
git commit -m "refactor: organiza documentos e scripts em estrutura de pastas

- Cria estrutura meta-spec com pastas technical, business e repos
- Move todos os scripts .sh para pasta scripts/
- Organiza documentação técnica em meta-spec/technical
- Organiza documentação de repositório em meta-spec/repos
- Atualiza referências nos documentos para novos caminhos
- Remove arquivos duplicados da raiz do projeto"

echo "✅ Commit realizado!"
git log -1 --oneline

