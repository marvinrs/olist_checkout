# Comandos para Limpar Cache e Corrigir Erro JWT

Execute os seguintes comandos no terminal (WSL, PowerShell ou CMD):

## Opção 1: Script Automático (Linux/WSL)
```bash
chmod +x scripts/fix-jwt-error.sh
./scripts/fix-jwt-error.sh
```

## Opção 2: Script Automático (Windows)
```cmd
fix-jwt-error.bat
```

## Opção 3: Comandos Manuais

Execute um por um:

```bash
# Limpar cache de configuração
docker compose exec laravel php artisan config:clear

# Limpar cache geral
docker compose exec laravel php artisan cache:clear

# Limpar cache de rotas
docker compose exec laravel php artisan route:clear

# Limpar cache de views
docker compose exec laravel php artisan view:clear

# Reiniciar container
docker compose restart laravel
```

## Verificar se funcionou

Após executar os comandos, aguarde alguns segundos e tente fazer login novamente em:
- http://localhost:3000

O erro do Carbon deve estar resolvido!

