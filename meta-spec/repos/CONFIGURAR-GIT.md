# Configurar Git para Usar SSH

## ✅ Chave SSH Adicionada!

Agora vamos configurar o Git para usar sua chave SSH automaticamente.

## Opção 1: Script Automático

Execute no terminal WSL:

```bash
chmod +x scripts/configurar-git-ssh.sh && ./scripts/configurar-git-ssh.sh
```

## Opção 2: Configuração Manual

### 1. Configurar o arquivo ~/.ssh/config

```bash
nano ~/.ssh/config
```

Adicione estas linhas:

```
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github
  IdentitiesOnly yes
```

Salve (Ctrl+O, Enter, Ctrl+X)

### 2. Ajustar permissões

```bash
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519_github
```

### 3. Testar conexão

```bash
ssh -T git@github.com
```

Você deve ver:
```
Hi username! You've successfully authenticated...
```

## Usar SSH nos Repositórios

### Para repositórios novos:

```bash
git clone git@github.com:usuario/repositorio.git
```

### Para repositórios existentes (alterar de HTTPS para SSH):

```bash
# Ver remote atual
git remote -v

# Alterar para SSH
git remote set-url origin git@github.com:usuario/repositorio.git

# Verificar
git remote -v
```

## Verificar se está funcionando

```bash
# Testar conexão
ssh -T git@github.com

# Fazer um push de teste
git push
```

## Pronto! 🎉

Agora você pode usar Git com SSH sem precisar digitar senha toda vez.

