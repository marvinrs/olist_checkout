# Como Criar os Arquivos .env.example

Como os arquivos `.env.example` podem estar bloqueados pelo sistema, siga uma das opções abaixo:

## Opção 1: Usando o Script (Recomendado)

No terminal (Linux/Mac/WSL):
```bash
chmod +x setup-env.sh
./setup-env.sh
```

## Opção 2: Criar Manualmente

### Backend (.env.example)

Crie o arquivo `backend/.env.example` com o seguinte conteúdo:

```env
APP_NAME="Olist Checkout"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_TIMEZONE=UTC
APP_URL=http://localhost:8000
APP_LOCALE=pt_BR
APP_FALLBACK_LOCALE=pt_BR
APP_FAKER_LOCALE=pt_BR

APP_MAINTENANCE_DRIVER=file
APP_MAINTENANCE_STORE=database

BCRYPT_ROUNDS=12

LOG_CHANNEL=stack
LOG_STACK=single
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=pgsql
DB_HOST=postgres
DB_PORT=5432
DB_DATABASE=olist_checkout
DB_USERNAME=postgres
DB_PASSWORD=postgres

SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_ENCRYPT=false
SESSION_PATH=/
SESSION_DOMAIN=null

BROADCAST_CONNECTION=log
FILESYSTEM_DISK=local
QUEUE_CONNECTION=database

CACHE_STORE=database
CACHE_PREFIX=

MEMCACHED_HOST=127.0.0.1

REDIS_CLIENT=phpredis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=log
MAIL_HOST=127.0.0.1
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

JWT_SECRET=
JWT_TTL=60
JWT_REFRESH_TTL=20160
JWT_ALGO=HS256

FRONTEND_URL=http://localhost:3000
```

### Frontend (.env.example)

Crie o arquivo `frontend/.env.example` com o seguinte conteúdo:

```env
NEXT_PUBLIC_API_URL=http://localhost:8000/api
```

## Opção 3: Copiar dos Arquivos Temporários

Se os arquivos `backend/env.example` e `frontend/env.example` existirem, você pode renomeá-los:

```bash
# Linux/Mac/WSL
mv backend/env.example backend/.env.example
mv frontend/env.example frontend/.env.example

# Windows (PowerShell)
Rename-Item backend/env.example backend/.env.example
Rename-Item frontend/env.example frontend/.env.example
```

## Depois de Criar os Arquivos

Após criar os arquivos `.env.example`, copie-os para `.env`:

```bash
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env
```

