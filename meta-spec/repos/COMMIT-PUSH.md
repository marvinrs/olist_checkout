# Fazer Commit e Push

## Execute no Terminal WSL:

```bash
chmod +x scripts/commit-e-push.sh && ./scripts/commit-e-push.sh
```

## O que o script faz:

1. ✅ Verifica se é um repositório Git
2. 🔄 Altera o remote de HTTPS para SSH (se necessário)
3. 📋 Mostra o status das alterações
4. ➕ Adiciona todos os arquivos modificados
5. 💾 Faz commit com mensagem descritiva
6. 🚀 Faz push para o GitHub

## Ou execute manualmente:

```bash
# 1. Alterar remote para SSH (se necessário)
git remote set-url origin git@github.com:marvinrs/olist_checkout.git

# 2. Ver status
git status

# 3. Adicionar arquivos
git add .

# 4. Fazer commit
git commit -m "feat: adiciona correções e melhorias"

# 5. Fazer push
git push origin main
```

## Verificar se funcionou:

Acesse: https://github.com/marvinrs/olist_checkout

Você deve ver as alterações no repositório.

