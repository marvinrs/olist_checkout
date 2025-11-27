# Execute Agora no Terminal WSL

## Comando Rápido

Copie e cole este comando no terminal WSL:

```bash
chmod +x gerar-chave-ssh-agora.sh && ./gerar-chave-ssh-agora.sh
```

## Ou Execute os Comandos Manualmente

```bash
# 1. Criar diretório
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 2. Gerar chave
ssh-keygen -t ed25519 -C "github-$(date +%Y%m%d)" -f ~/.ssh/id_ed25519_github -N ""

# 3. Ver a chave pública
cat ~/.ssh/id_ed25519_github.pub
```

## Depois de Executar

1. O script vai mostrar a chave pública
2. Copie a linha COMPLETA (começando com `ssh-ed25519`)
3. Cole no GitHub: https://github.com/settings/keys

