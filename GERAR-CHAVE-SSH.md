# Como Gerar Chave SSH para GitHub

## Opção 1: Usando o Script (Recomendado)

Execute no terminal WSL:

```bash
chmod +x gerar-chave-ssh-github.sh
./gerar-chave-ssh-github.sh
```

## Opção 2: Comandos Manuais

Execute os seguintes comandos no terminal WSL:

```bash
# 1. Criar diretório .ssh se não existir
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 2. Gerar a chave SSH Ed25519 (recomendado pelo GitHub)
ssh-keygen -t ed25519 -C "seu-email@exemplo.com" -f ~/.ssh/id_ed25519_github

# Quando solicitado, pressione Enter para usar senha vazia
# ou digite uma senha para proteger a chave
```

## Opção 3: Gerar sem senha (para automação)

```bash
ssh-keygen -t ed25519 -C "github-$(date +%Y%m%d)" -f ~/.ssh/id_ed25519_github -N ""
```

## Ver a Chave Pública

```bash
cat ~/.ssh/id_ed25519_github.pub
```

## Adicionar ao GitHub

1. Copie o conteúdo da chave pública (saída do comando acima)
2. Acesse: https://github.com/settings/keys
3. Clique em "New SSH key"
4. Cole a chave pública e salve

## Configurar o SSH para usar a chave

Crie ou edite o arquivo `~/.ssh/config`:

```bash
nano ~/.ssh/config
```

Adicione:

```
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github
```

Salve e teste:

```bash
ssh -T git@github.com
```

## Alternativa: Usar RSA (se Ed25519 não funcionar)

```bash
ssh-keygen -t rsa -b 4096 -C "seu-email@exemplo.com" -f ~/.ssh/id_rsa_github
```

