# 🚀 Guía de Instalación

## 📋 Tabla de Contenidos

- [Requisitos Previos](#requisitos-previos)
- [Instalación con Docker (Recomendado)](#instalación-con-docker-recomendado)
- [Instalación Manual](#instalación-manual)
- [Configuración de Base de Datos](#configuración-de-base-de-datos)
- [Variables de Entorno](#variables-de-entorno)
- [Verificación de Instalación](#verificación-de-instalación)
- [Troubleshooting](#troubleshooting)

## ✅ Requisitos Previos

### Software Requerido

#### Opción 1: Con Docker (Más Fácil)
- **Docker** 20.10+ ([Instalar Docker](https://docs.docker.com/get-docker/))
- **Docker Compose** 2.0+ (incluido con Docker Desktop)
- **Git** 2.30+

#### Opción 2: Sin Docker (Manual)
- **Node.js** 20+ y npm 9+ ([Instalar Node.js](https://nodejs.org/))
- **PostgreSQL** 15+ ([Instalar PostgreSQL](https://www.postgresql.org/download/))
- **Redis** 7+ ([Instalar Redis](https://redis.io/download))
- **Git** 2.30+

### Verificar Instalaciones

```bash
# Docker
docker --version
docker-compose --version

# Node.js
node --version
npm --version

# PostgreSQL
psql --version

# Redis
redis-cli --version

# Git
git --version
```

## 🐳 Instalación con Docker (Recomendado)

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/programadecomidas-claude.git
cd programadecomidas-claude
```

### 2. Copiar Variables de Entorno

```bash
# Copiar ejemplo de variables de entorno
cp .env.example .env

# Editar con tus valores
nano .env  # o usa tu editor preferido
```

### 3. Configurar Variables de Entorno

Editar `.env` con valores apropiados:

```bash
# Aplicación
NODE_ENV=development
PORT=4000

# Base de Datos
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=restaurant_db
POSTGRES_USER=admin
POSTGRES_PASSWORD=your_secure_password_here

# Redis
REDIS_HOST=redis
REDIS_PORT=6379

# JWT
JWT_SECRET=your_jwt_secret_key_here_min_32_chars
JWT_EXPIRES_IN=1h
JWT_REFRESH_SECRET=your_refresh_secret_key_here
JWT_REFRESH_EXPIRES_IN=7d

# URLs
API_URL=http://localhost:4000
FRONTEND_URL=http://localhost:3000

# Integraciones (dejar vacío por ahora)
STRIPE_SECRET_KEY=
MERCADOPAGO_ACCESS_TOKEN=
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
SENDGRID_API_KEY=
FIREBASE_SERVER_KEY=
```

### 4. Construir y Levantar Contenedores

```bash
# Construir imágenes
docker-compose build

# Levantar servicios en background
docker-compose up -d

# Ver logs
docker-compose logs -f
```

### 5. Ejecutar Migraciones de Base de Datos

```bash
# Ejecutar migraciones
docker-compose exec backend npm run migration:run

# Ejecutar seeds (datos de prueba)
docker-compose exec backend npm run seed:run
```

### 6. Verificar que Todo Esté Corriendo

```bash
# Ver contenedores activos
docker-compose ps

# Debería mostrar:
# - postgres (PostgreSQL)
# - redis (Redis)
# - backend (API)
# - web-admin (Panel Admin)
# - kds (Kitchen Display)
```

### 7. Acceder a las Aplicaciones

- **API Backend**: http://localhost:4000
- **API Docs (Swagger)**: http://localhost:4000/docs
- **Panel Admin**: http://localhost:3000
- **KDS**: http://localhost:3001
- **POS**: http://localhost:3002

### 8. Credenciales por Defecto

```
Admin:
Email: admin@restaurant.com
Password: Admin123!

Gerente:
Email: manager@restaurant.com
Password: Manager123!

Cajero:
Email: cashier@restaurant.com
Password: Cashier123!
```

## 🔧 Instalación Manual

### 1. Clonar Repositorio

```bash
git clone https://github.com/tu-usuario/programadecomidas-claude.git
cd programadecomidas-claude
```

### 2. Instalar PostgreSQL

#### Windows
```bash
# Descargar instalador de postgresql.org
# Seguir wizard de instalación

# Crear base de datos
psql -U postgres
CREATE DATABASE restaurant_db;
CREATE USER admin WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE restaurant_db TO admin;
\q
```

#### macOS
```bash
# Con Homebrew
brew install postgresql@15

# Iniciar servicio
brew services start postgresql@15

# Crear base de datos
createdb restaurant_db
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib

sudo systemctl start postgresql
sudo systemctl enable postgresql

# Crear base de datos
sudo -u postgres psql
CREATE DATABASE restaurant_db;
CREATE USER admin WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE restaurant_db TO admin;
\q
```

### 3. Instalar Redis

#### Windows
```bash
# Descargar desde https://github.com/microsoftarchive/redis/releases
# O usar WSL2 con Linux

# Con WSL2
wsl --install
wsl
sudo apt install redis-server
sudo service redis-server start
```

#### macOS
```bash
brew install redis
brew services start redis
```

#### Linux
```bash
sudo apt install redis-server
sudo systemctl start redis
sudo systemctl enable redis
```

### 4. Instalar Dependencias del Backend

```bash
cd backend

# Instalar dependencias
npm install

# O con yarn
yarn install
```

### 5. Configurar Variables de Entorno

```bash
# En la carpeta backend
cp .env.example .env

# Editar .env con tus valores
nano .env
```

```bash
NODE_ENV=development
PORT=4000

POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=restaurant_db
POSTGRES_USER=admin
POSTGRES_PASSWORD=your_password

REDIS_HOST=localhost
REDIS_PORT=6379

JWT_SECRET=your_jwt_secret_min_32_characters
JWT_EXPIRES_IN=1h

# ... resto de variables
```

### 6. Ejecutar Migraciones

```bash
# Crear tablas
npm run migration:run

# Seed de datos de prueba
npm run seed:run
```

### 7. Iniciar Backend

```bash
# Modo desarrollo (con hot reload)
npm run start:dev

# Modo producción
npm run build
npm run start:prod
```

### 8. Instalar y Configurar Frontend

```bash
# En otra terminal
cd ../frontend/web-admin

# Instalar dependencias
npm install

# Configurar .env.local
cat > .env.local << EOF
NEXT_PUBLIC_API_URL=http://localhost:4000/api/v1
NEXT_PUBLIC_WS_URL=ws://localhost:4000
EOF

# Iniciar en desarrollo
npm run dev
```

### 9. Instalar KDS

```bash
cd ../kds

npm install

cat > .env.local << EOF
NEXT_PUBLIC_API_URL=http://localhost:4000/api/v1
NEXT_PUBLIC_WS_URL=ws://localhost:4000
EOF

npm run dev
```

## 🗄️ Configuración de Base de Datos

### Crear Estructura Completa

```bash
# Ejecutar migraciones
npm run migration:run

# Esto creará:
# - Todas las tablas
# - Índices
# - Foreign keys
# - Constraints
```

### Seed de Datos de Prueba

```bash
npm run seed:run

# Esto insertará:
# - Usuarios de prueba
# - Roles y permisos
# - Categorías de productos
# - Productos de ejemplo
# - Mesas
# - Zonas de delivery
```

### Verificar Base de Datos

```bash
# Conectar a PostgreSQL
psql -U admin -d restaurant_db

# Listar tablas
\dt

# Ver datos de usuarios
SELECT id, email, full_name, role_id FROM users;

# Ver productos
SELECT id, name, price, available FROM products LIMIT 10;

# Salir
\q
```

## 🔐 Variables de Entorno

### Backend (.env)

```bash
# ============================================
# APLICACIÓN
# ============================================
NODE_ENV=development
PORT=4000
API_PREFIX=/api/v1

# ============================================
# BASE DE DATOS
# ============================================
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=restaurant_db
POSTGRES_USER=admin
POSTGRES_PASSWORD=your_secure_password

# ============================================
# REDIS
# ============================================
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=  # Opcional

# ============================================
# AUTENTICACIÓN
# ============================================
JWT_SECRET=your_jwt_secret_key_minimum_32_characters
JWT_EXPIRES_IN=1h
JWT_REFRESH_SECRET=your_refresh_secret_key_minimum_32_characters
JWT_REFRESH_EXPIRES_IN=7d

# ============================================
# CORS
# ============================================
CORS_ORIGIN=http://localhost:3000,http://localhost:3001,http://localhost:3002

# ============================================
# UPLOADS
# ============================================
UPLOAD_DIR=./uploads
MAX_FILE_SIZE=5242880  # 5MB

# ============================================
# STRIPE (Pagos)
# ============================================
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# ============================================
# MERCADOPAGO (Pagos - Latinoamérica)
# ============================================
MERCADOPAGO_ACCESS_TOKEN=TEST-...
MERCADOPAGO_PUBLIC_KEY=TEST-...

# ============================================
# TWILIO (SMS)
# ============================================
TWILIO_ACCOUNT_SID=AC...
TWILIO_AUTH_TOKEN=...
TWILIO_PHONE_NUMBER=+1234567890

# ============================================
# WHATSAPP BUSINESS API
# ============================================
WHATSAPP_API_URL=https://graph.facebook.com/v17.0
WHATSAPP_PHONE_NUMBER_ID=...
WHATSAPP_ACCESS_TOKEN=...

# ============================================
# SENDGRID (Email)
# ============================================
SENDGRID_API_KEY=SG....
SENDGRID_FROM_EMAIL=noreply@turestaurante.com
SENDGRID_FROM_NAME=Tu Restaurante

# ============================================
# FIREBASE (Push Notifications)
# ============================================
FIREBASE_PROJECT_ID=...
FIREBASE_PRIVATE_KEY=...
FIREBASE_CLIENT_EMAIL=...

# ============================================
# GOOGLE MAPS API
# ============================================
GOOGLE_MAPS_API_KEY=AIza...

# ============================================
# AWS S3 (Storage)
# ============================================
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=us-east-1
AWS_S3_BUCKET=restaurant-assets

# ============================================
# CLOUDINARY (Alternativa a S3)
# ============================================
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...

# ============================================
# FACTURACIÓN ELECTRÓNICA
# ============================================
# Argentina - AFIP
AFIP_CUIT=...
AFIP_CERT_PATH=./certs/afip.crt
AFIP_KEY_PATH=./certs/afip.key

# ============================================
# LOGGING
# ============================================
LOG_LEVEL=debug  # debug, info, warn, error
LOG_FORMAT=json  # json, pretty
```

### Frontend (.env.local)

```bash
NEXT_PUBLIC_API_URL=http://localhost:4000/api/v1
NEXT_PUBLIC_WS_URL=ws://localhost:4000
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=AIza...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
NEXT_PUBLIC_MERCADOPAGO_PUBLIC_KEY=TEST-...
```

## ✅ Verificación de Instalación

### 1. Verificar Backend

```bash
# Health check
curl http://localhost:4000/health

# Respuesta esperada:
# {
#   "status": "ok",
#   "timestamp": "2024-10-21T10:30:00.000Z",
#   "database": "connected",
#   "redis": "connected"
# }
```

### 2. Verificar API

```bash
# Obtener categorías (no requiere auth)
curl http://localhost:4000/api/v1/categories

# Login
curl -X POST http://localhost:4000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@restaurant.com","password":"Admin123!"}'
```

### 3. Verificar Frontend

Abrir navegador en:
- http://localhost:3000 (Admin Panel)

Debería mostrar pantalla de login.

### 4. Verificar WebSockets

```javascript
// En consola del navegador
const socket = io('http://localhost:4000');
socket.on('connect', () => console.log('Connected!'));
```

## 🐛 Troubleshooting

### Error: "Cannot connect to database"

```bash
# Verificar que PostgreSQL esté corriendo
# Windows/Linux
sudo systemctl status postgresql

# macOS
brew services list | grep postgresql

# Verificar credenciales
psql -U admin -d restaurant_db -h localhost
```

### Error: "Cannot connect to Redis"

```bash
# Verificar que Redis esté corriendo
redis-cli ping

# Debería responder: PONG

# Iniciar Redis si no está corriendo
# Linux
sudo systemctl start redis

# macOS
brew services start redis
```

### Error: "Port 4000 already in use"

```bash
# Encontrar proceso usando el puerto
# Linux/macOS
lsof -i :4000

# Windows
netstat -ano | findstr :4000

# Matar proceso
kill -9 <PID>
```

### Error: "Module not found"

```bash
# Limpiar node_modules y reinstalar
rm -rf node_modules package-lock.json
npm install
```

### Error de Migraciones

```bash
# Revertir última migración
npm run migration:revert

# Volver a ejecutar
npm run migration:run

# Si falla, eliminar y recrear base de datos
psql -U postgres
DROP DATABASE restaurant_db;
CREATE DATABASE restaurant_db;
\q

npm run migration:run
```

### Docker: Contenedor no inicia

```bash
# Ver logs del contenedor
docker-compose logs backend

# Reconstruir imagen
docker-compose build --no-cache backend

# Reiniciar servicios
docker-compose down
docker-compose up -d
```

## 📞 Soporte

Si tienes problemas:

1. Revisa los logs: `docker-compose logs -f` o `npm run start:dev`
2. Verifica que todas las dependencias estén instaladas
3. Confirma que las variables de entorno estén correctas
4. Consulta la documentación: [Documentación Completa](../README.md)
5. Abre un issue en GitHub

---

**Siguiente paso**: [Guía de Configuración](./CONFIGURACION.md)
