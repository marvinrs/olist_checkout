# Como Corrigir a Chave SSH para GitHub

## Problema

O GitHub está rejeitando a chave com a mensagem: "Key is invalid. You must supply a key in OpenSSH public key format"

## Solução: Gerar Nova Chave no Formato Correto

### Passo 1: Gerar Nova Chave SSH

Execute no terminal WSL:

```bash
# Criar diretório .ssh se não existir
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Gerar chave SSH Ed25519 (formato correto)
ssh-keygen -t ed25519 -C "github-$(date +%Y%m%d)" -f ~/.ssh/id_ed25519_github -N ""
```

**Quando solicitado:**
- Pressione Enter para usar senha vazia
- Ou digite uma senha para proteger a chave

### Passo 2: Ver a Chave Pública

```bash
cat ~/.ssh/id_ed25519_github.pub
```

A chave deve começar com:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...
```

### Passo 3: Copiar a Chave Completa

A chave pública completa deve ter este formato:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... github-20251127
```

**IMPORTANTE:** Copie a linha COMPLETA, incluindo:
- O tipo: `ssh-ed25519`
- A chave em base64 (toda a parte longa)
- O comentário no final (opcional)

### Passo 4: Adicionar no GitHub

1. Acesse: https://github.com/settings/keys
2. Clique em "New SSH key"
3. **Título:** Digite um nome (ex: "Meu Computador")
4. **Key type:** Selecione "Authentication Key"
5. **Key:** Cole a chave COMPLETA (começando com `ssh-ed25519`)
6. Clique em "Add SSH key"

## Formato Correto vs Incorreto

### ✅ Formato Correto:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... comentario@opcional
```

### ❌ Formato Incorreto:
- Apenas base64 sem o prefixo
- Chave codificada em base64 múltiplas vezes
- Chave privada (nunca compartilhe!)

## Verificar se Funcionou

```bash
ssh -T git@github.com
```

Você deve ver:
```
Hi username! You've successfully authenticated...
```

## Alternativa: Usar RSA (se Ed25519 não funcionar)

```bash
ssh-keygen -t rsa -b 4096 -C "github-$(date +%Y%m%d)" -f ~/.ssh/id_rsa_github
cat ~/.ssh/id_rsa_github.pub
```

A chave RSA deve começar com:
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ...
```

