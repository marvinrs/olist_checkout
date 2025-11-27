# Criar Branch Development e Fazer Commit

## Execute no Terminal WSL:

```bash
chmod +x scripts/criar-branch-development.sh && ./scripts/criar-branch-development.sh
```

## O que o script faz:

1. ✅ Cria a branch `development`
2. 🔄 Faz checkout para a nova branch
3. ➕ Adiciona todos os arquivos modificados
4. 💾 Faz commit na branch `development`
5. 🚀 Opcionalmente faz push para o GitHub

## Ou execute manualmente:

```bash
# 1. Criar e fazer checkout para a branch development
git checkout -b development

# 2. Verificar status
git status

# 3. Adicionar arquivos
git add .

# 4. Fazer commit
git commit -m "feat: adiciona correções e melhorias

- Corrige erro JWT/Carbon convertendo valores para inteiros
- Corrige erro de preço no frontend (toFixed com strings)
- Adiciona página de criar novo produto
- Adiciona scripts para gerar e configurar chave SSH
- Melhora normalização de dados da API
- Atualiza configurações do Docker Compose"

# 5. Fazer push da branch (primeira vez)
git push -u origin development

# Próximas vezes, apenas:
git push
```

## Verificar branches:

```bash
# Ver branches locais
git branch

# Ver todas as branches (locais e remotas)
git branch -a

# Voltar para main
git checkout main

# Voltar para development
git checkout development
```

## Estrutura de Branches:

- **main**: Branch principal (produção)
- **development**: Branch de desenvolvimento

## Pronto! 🎉

A branch `development` foi criada e você pode trabalhar nela.

