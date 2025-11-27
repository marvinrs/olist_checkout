# Guia de Instalação - Olist Checkout

## Passo a Passo Completo

### 1. Pré-requisitos
- Docker Desktop instalado e rodando
- Git instalado
- Pelo menos 4GB de RAM disponível

### 2. Clonar o Repositório
```bash
git clone <repository-url>
cd olist_checkout
```

### 3. Configurar Variáveis de Ambiente

#### Backend
```bash
cp backend/.env.example backend/.env
```

Edite `backend/.env` e configure:
```env
APP_NAME="Olist Checkout"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=pgsql
DB_HOST=postgres
DB_PORT=5432
DB_DATABASE=olist_checkout
DB_USERNAME=postgres
DB_PASSWORD=postgres
```

#### Frontend
```bash
cp frontend/.env.example frontend/.env
```

Edite `frontend/.env` e configure:
```env
NEXT_PUBLIC_API_URL=http://localhost:8000/api
```

### 4. Construir e Iniciar os Containers

```bash
docker compose up -d --build
```

Este comando irá:
- Construir as imagens Docker
- Criar os containers
- Instalar dependências
- Executar migrations
- Popular o banco de dados com dados de exemplo

### 5. Verificar se Tudo Está Funcionando

#### Verificar Status dos Containers
```bash
docker compose ps
```

Todos os containers devem estar com status "Up".

#### Verificar Logs
```bash
# Logs do Laravel
docker compose logs laravel

# Logs do Next.js
docker compose logs nextjs

# Logs do PostgreSQL
docker compose logs postgres
```

### 6. Acessar a Aplicação

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Health Check**: http://localhost:8000/up

### 7. Credenciais Padrão

Após a instalação, você pode usar:
- **Email**: admin@olist.com
- **Senha**: password

### 8. Comandos Úteis

#### Executar Comandos no Container Laravel
```bash
# Acessar o container
docker compose exec laravel bash

# Executar migrations
docker compose exec laravel php artisan migrate

# Executar seeders
docker compose exec laravel php artisan db:seed

# Limpar cache
docker compose exec laravel php artisan cache:clear
docker compose exec laravel php artisan config:clear

# Gerar chave JWT
docker compose exec laravel php artisan jwt:secret
```

#### Executar Comandos no Container Next.js
```bash
# Acessar o container
docker compose exec nextjs sh

# Instalar dependências
docker compose exec nextjs npm install
```

#### Parar os Containers
```bash
docker compose down
```

#### Parar e Remover Volumes (limpar banco de dados)
```bash
docker compose down -v
```

### 9. Troubleshooting

#### Erro: Porta já em uso
Se as portas 3000, 8000 ou 5432 estiverem em uso, edite o `docker-compose.yml` e altere as portas:
```yaml
ports:
  - "8001:8000"  # Altere 8000 para 8001
```

#### Erro: Permissões
```bash
docker compose exec laravel chmod -R 775 storage bootstrap/cache
```

#### Erro: Banco de dados não conecta
1. Verifique se o container do PostgreSQL está rodando:
```bash
docker compose ps postgres
```

2. Verifique os logs:
```bash
docker compose logs postgres
```

3. Reinicie o container:
```bash
docker compose restart postgres
```

#### Erro: JWT Secret não configurado
```bash
docker compose exec laravel php artisan jwt:secret --force
```

#### Limpar Tudo e Recomeçar
```bash
docker compose down -v
docker compose up -d --build
```

### 10. Desenvolvimento

#### Hot Reload
O Next.js e o Laravel estão configurados para hot reload automático. Qualquer alteração nos arquivos será refletida automaticamente.

#### Adicionar Novas Dependências

**Backend (Laravel)**:
```bash
docker compose exec laravel composer require nome-do-pacote
```

**Frontend (Next.js)**:
```bash
docker compose exec nextjs npm install nome-do-pacote
```

### 11. Testes

```bash
# Executar testes do backend
docker compose exec laravel php artisan test
```

### 12. Produção

Para produção, você deve:
1. Alterar `APP_ENV=production` e `APP_DEBUG=false` no `.env`
2. Gerar uma nova `APP_KEY`
3. Configurar variáveis de ambiente adequadas
4. Usar um servidor web adequado (Nginx/Apache) em vez do servidor de desenvolvimento do PHP
5. Configurar SSL/HTTPS
6. Otimizar o build do Next.js: `npm run build`

## Suporte

Se encontrar problemas, verifique:
1. Os logs dos containers
2. As variáveis de ambiente
3. As portas disponíveis
4. Os recursos do sistema (RAM, CPU)

