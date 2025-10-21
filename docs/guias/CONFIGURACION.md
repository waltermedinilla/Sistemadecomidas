# ⚙️ Guía de Configuración

## 📋 Tabla de Contenidos

- [Configuración Inicial del Restaurante](#configuración-inicial-del-restaurante)
- [Configuración de Integraciones](#configuración-de-integraciones)
- [Configuración de Notificaciones](#configuración-de-notificaciones)
- [Configuración del KDS](#configuración-del-kds)
- [Configuración de Delivery](#configuración-de-delivery)
- [Configuración de Facturación](#configuración-de-facturación)
- [Configuración de Pagos](#configuración-de-pagos)
- [Seguridad y Permisos](#seguridad-y-permisos)

## 🏪 Configuración Inicial del Restaurante

### 1. Información del Restaurante

Después de la instalación, configurar datos del restaurante en el Panel Admin:

```
Admin Panel > Configuración > Información del Restaurante
```

**Datos requeridos:**
- Nombre del restaurante
- Dirección principal
- Teléfono de contacto
- Email de contacto
- Logotipo
- Horarios de operación
- Zona horaria

**Ejemplo:**
```json
{
  "name": "La Buena Mesa",
  "address": "Av. Corrientes 1234, Buenos Aires",
  "phone": "+54 11 1234-5678",
  "email": "contacto@labuename.com",
  "timezone": "America/Argentina/Buenos_Aires",
  "hours": {
    "monday": { "open": "11:00", "close": "23:00" },
    "tuesday": { "open": "11:00", "close": "23:00" },
    "wednesday": { "open": "11:00", "close": "23:00" },
    "thursday": { "open": "11:00", "close": "23:00" },
    "friday": { "open": "11:00", "close": "01:00" },
    "saturday": { "open": "11:00", "close": "01:00" },
    "sunday": { "open": "12:00", "close": "23:00" }
  }
}
```

### 2. Configurar Menú y Productos

#### Crear Categorías

```
Admin Panel > Menú > Categorías > Nueva Categoría
```

**Ejemplo de categorías:**
- Entradas
- Pizzas
- Pastas
- Carnes
- Ensaladas
- Postres
- Bebidas

#### Agregar Productos

```
Admin Panel > Menú > Productos > Nuevo Producto
```

**Campos importantes:**
- Nombre
- Descripción
- Precio
- Categoría
- Imagen
- Tiempo de preparación (minutos)
- Alérgenos
- Opciones dietéticas (vegetariano, vegano, sin gluten)
- Disponibilidad

**Ejemplo:**
```json
{
  "name": "Pizza Margarita",
  "description": "Pizza tradicional con tomate, mozzarella y albahaca",
  "price": 1500,
  "category_id": "uuid-pizzas",
  "prep_time": 15,
  "allergens": ["gluten", "lactosa"],
  "is_vegetarian": true,
  "available": true
}
```

#### Configurar Addons

```
Admin Panel > Menú > Productos > [Seleccionar Producto] > Addons
```

**Ejemplos:**
- Extra queso (+$200)
- Doble carne (+$300)
- Papas fritas (+$250)

### 3. Configurar Mesas (Para Dine-in)

```
Admin Panel > Configuración > Mesas > Nueva Mesa
```

**Información por mesa:**
- Número de mesa
- Capacidad (número de asientos)
- Zona (terraza, interior, VIP)
- Código QR para pedidos

**Zonas recomendadas:**
- Interior
- Terraza
- Bar
- VIP
- Salón privado

### 4. Configurar Impuestos

```
Admin Panel > Configuración > Facturación > Impuestos
```

**Ejemplos según país:**

**Argentina:**
- IVA 21% (general)
- IVA 10.5% (algunos alimentos)

**México:**
- IVA 16%

**Perú:**
- IGV 18%

## 🔌 Configuración de Integraciones

### 1. Stripe (Pagos con Tarjeta)

#### Obtener Credenciales

1. Crear cuenta en [Stripe](https://stripe.com)
2. Ir a Dashboard > Developers > API Keys
3. Copiar:
   - Secret Key (sk_test_...)
   - Publishable Key (pk_test_...)

#### Configurar en Backend

```bash
# .env
STRIPE_SECRET_KEY=sk_test_xxxxxxxxxxxxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxxx
```

#### Configurar Webhook

1. En Stripe Dashboard > Developers > Webhooks
2. Agregar endpoint: `https://tu-dominio.com/api/v1/webhooks/stripe`
3. Eventos a escuchar:
   - `payment_intent.succeeded`
   - `payment_intent.payment_failed`
   - `charge.refunded`

```bash
# .env
STRIPE_WEBHOOK_SECRET=whsec_xxxxxxxxxxxxx
```

### 2. MercadoPago (Latinoamérica)

#### Obtener Credenciales

1. Crear cuenta en [MercadoPago](https://mercadopago.com)
2. Ir a Configuración > Credenciales
3. Copiar Access Token y Public Key

#### Configurar

```bash
# .env
MERCADOPAGO_ACCESS_TOKEN=TEST-xxxxxxxxxxxxx
MERCADOPAGO_PUBLIC_KEY=TEST-xxxxxxxxxxxxx
```

### 3. Twilio (SMS)

#### Configurar Twilio

1. Crear cuenta en [Twilio](https://twilio.com)
2. Obtener número de teléfono
3. Copiar credenciales

```bash
# .env
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=xxxxxxxxxxxxx
TWILIO_PHONE_NUMBER=+1234567890
```

#### Verificar Configuración

```bash
# Test SMS
curl -X POST http://localhost:4000/api/v1/notifications/test-sms \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"phone": "+5491112345678", "message": "Test SMS"}'
```

### 4. SendGrid (Email)

#### Configurar SendGrid

1. Crear cuenta en [SendGrid](https://sendgrid.com)
2. Crear API Key
3. Verificar dominio (opcional pero recomendado)

```bash
# .env
SENDGRID_API_KEY=SG.xxxxxxxxxxxxx
SENDGRID_FROM_EMAIL=noreply@turestaurante.com
SENDGRID_FROM_NAME=Tu Restaurante
```

#### Plantillas de Email

Crear plantillas en SendGrid para:
- Confirmación de pedido
- Pedido listo
- Factura
- Reseteo de contraseña

### 5. Firebase (Push Notifications)

#### Configurar Firebase

1. Crear proyecto en [Firebase Console](https://console.firebase.google.com)
2. Agregar app (Android/iOS)
3. Descargar archivo de configuración
4. Ir a Project Settings > Service Accounts
5. Generar nueva clave privada

```bash
# .env
FIREBASE_PROJECT_ID=tu-proyecto-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@tu-proyecto.iam.gserviceaccount.com
```

### 6. Google Maps API

#### Obtener API Key

1. Ir a [Google Cloud Console](https://console.cloud.google.com)
2. Crear proyecto
3. Habilitar APIs:
   - Maps JavaScript API
   - Places API
   - Geocoding API
   - Directions API
4. Crear credenciales (API Key)

```bash
# .env
GOOGLE_MAPS_API_KEY=AIzaxxxxxxxxxxxxxxxxxx
```

#### Restricciones de Seguridad

En Google Cloud Console:
- Restricción de aplicación: HTTP referrers
- Agregar: `https://tudominio.com/*`

### 7. AWS S3 (Storage)

#### Configurar S3

1. Crear cuenta AWS
2. Crear bucket S3
3. Crear usuario IAM con permisos S3
4. Generar Access Keys

```bash
# .env
AWS_ACCESS_KEY_ID=AKIAxxxxxxxxxx
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxx
AWS_REGION=us-east-1
AWS_S3_BUCKET=restaurant-assets
```

#### Política del Bucket

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::restaurant-assets/*"
    }
  ]
}
```

## 🔔 Configuración de Notificaciones

### Plantillas de Notificaciones

```
Admin Panel > Configuración > Notificaciones > Plantillas
```

#### Eventos Disponibles

1. **order.created** - Nuevo pedido creado
2. **order.confirmed** - Pedido confirmado
3. **order.preparing** - Pedido en preparación
4. **order.ready** - Pedido listo
5. **order.delivering** - Pedido en camino
6. **order.completed** - Pedido completado
7. **payment.confirmed** - Pago confirmado
8. **delivery.assigned** - Repartidor asignado

#### Ejemplo de Plantilla SMS

```
Evento: order.ready
Canal: SMS
Mensaje: Hola {customer_name}! Tu pedido #{order_number} está listo. Te esperamos en {restaurant_name}. Gracias!
```

#### Variables Disponibles

- `{customer_name}` - Nombre del cliente
- `{order_number}` - Número de pedido
- `{restaurant_name}` - Nombre del restaurante
- `{total}` - Total del pedido
- `{estimated_time}` - Tiempo estimado
- `{delivery_address}` - Dirección de entrega
- `{driver_name}` - Nombre del repartidor

### Preferencias de Notificaciones

Permitir a usuarios configurar qué notificaciones recibir:

```
User Profile > Notificaciones > Preferencias
```

- ☑️ Email - Confirmación de pedido
- ☑️ SMS - Pedido listo
- ☑️ Push - Pedido en camino
- ☐ Email - Promociones

## 📺 Configuración del KDS

### Configuración por Estación

```
Admin Panel > KDS > Configuración > Nueva Estación
```

**Ejemplo: Estación de Parrilla**
```json
{
  "name": "Parrilla",
  "station_code": "grill",
  "filter_products": ["burger", "steak", "chicken"],
  "theme": "dark",
  "grid_columns": 3,
  "show_customer_names": false,
  "enable_sounds": true,
  "auto_bump": false
}
```

### Thresholds de Tiempo

```json
{
  "normal_threshold": 10,      // minutos - color verde
  "urgent_threshold": 15,       // minutos - color amarillo
  "very_urgent_threshold": 20,  // minutos - color rojo
  "delivery_adjustment": -2     // delivery es 2 min más urgente
}
```

### Sonidos

Subir archivos de audio personalizados:

```
Admin Panel > KDS > Configuración > Sonidos
```

- `new_order.mp3` - Nuevo pedido
- `urgent.mp3` - Pedido urgente
- `bump.mp3` - Confirmación de bump

## 🚚 Configuración de Delivery

### 1. Zonas de Entrega

```
Admin Panel > Delivery > Zonas > Nueva Zona
```

**Ejemplo:**
```json
{
  "name": "Centro",
  "polygon": [
    {"lat": -34.601, "lng": -58.381},
    {"lat": -34.603, "lng": -58.381},
    {"lat": -34.603, "lng": -58.378},
    {"lat": -34.601, "lng": -58.378}
  ],
  "base_fee": 300,
  "per_km_fee": 50,
  "min_order_amount": 1000,
  "estimated_time": 30,
  "active": true
}
```

### 2. Configurar Repartidores

```
Admin Panel > Delivery > Repartidores > Nuevo Repartidor
```

**Información requerida:**
- Usuario asociado
- Vehículo
- Licencia de conducir
- Documentación del vehículo

### 3. Vehículos

```
Admin Panel > Delivery > Vehículos > Nuevo Vehículo
```

**Tipos:**
- Bicicleta
- Motocicleta
- Auto
- Van

### 4. Asignación Automática

```
Admin Panel > Delivery > Configuración > Asignación
```

**Algoritmos disponibles:**
- **Manual**: Admin asigna manualmente
- **Nearest**: Repartidor más cercano
- **Round Robin**: Rotación equitativa
- **Least Busy**: Menos entregas activas

## 🧾 Configuración de Facturación

### Facturación Electrónica (Argentina - AFIP)

#### 1. Obtener Certificado Digital

1. Generar Certificate Signing Request (CSR)
```bash
openssl req -new -newkey rsa:2048 -nodes \
  -keyout afip.key -out afip.csr
```

2. Solicitar certificado en AFIP
3. Descargar certificado (.crt)

#### 2. Configurar Credenciales

```bash
# .env
AFIP_CUIT=20123456789
AFIP_CERT_PATH=./certs/afip.crt
AFIP_KEY_PATH=./certs/afip.key
AFIP_ENVIRONMENT=testing  # o 'production'
```

#### 3. Configurar Punto de Venta

```
Admin Panel > Facturación > Puntos de Venta
```

**Información:**
- Número de punto de venta (AFIP)
- Tipo de factura (A, B, C)
- Próximo número de factura

### Otras Países

**México (SAT):**
```bash
CFDI_RFC=...
CFDI_CERTIFICATE_PATH=...
CFDI_KEY_PATH=...
```

**Perú (SUNAT):**
```bash
SUNAT_RUC=...
SUNAT_USERNAME=...
SUNAT_PASSWORD=...
```

## 💳 Configuración de Pagos

### Métodos de Pago

```
Admin Panel > Configuración > Métodos de Pago
```

**Habilitar/deshabilitar:**
- ☑️ Efectivo
- ☑️ Tarjeta de crédito/débito
- ☑️ Transferencia bancaria
- ☑️ Billeteras digitales (MercadoPago, PayPal)
- ☑️ Código QR
- ☐ Criptomonedas

### Configurar Comisiones

```json
{
  "cash": { "commission": 0 },
  "card": { "commission": 2.9 },  // %
  "mercadopago": { "commission": 3.5 },
  "paypal": { "commission": 4.0 }
}
```

## 🔐 Seguridad y Permisos

### Configurar Roles

```
Admin Panel > Usuarios > Roles
```

**Roles predefinidos:**
- Admin (acceso completo)
- Gerente (sin configuración crítica)
- Cajero (POS, facturación)
- Mesero (pedidos, mesas)
- Cocina (KDS)
- Repartidor (delivery)

### Permisos Granulares

```json
{
  "orders": {
    "create": ["admin", "manager", "cashier", "waiter"],
    "read": ["admin", "manager", "cashier", "waiter", "kitchen"],
    "update": ["admin", "manager", "cashier"],
    "delete": ["admin"]
  },
  "products": {
    "create": ["admin", "manager"],
    "read": ["all"],
    "update": ["admin", "manager"],
    "delete": ["admin"]
  }
}
```

### Configurar 2FA (Two-Factor Authentication)

```
Admin Panel > Seguridad > Autenticación de Dos Factores
```

**Opciones:**
- ☑️ Requerir 2FA para admins
- ☐ Requerir 2FA para todos
- Método: App autenticadora (Google Authenticator)

### Políticas de Contraseña

```json
{
  "min_length": 8,
  "require_uppercase": true,
  "require_lowercase": true,
  "require_numbers": true,
  "require_special_chars": true,
  "expiration_days": 90,
  "prevent_reuse": 5
}
```

## 📊 Monitoreo y Logs

### Configurar Nivel de Logs

```bash
# .env
LOG_LEVEL=info  # debug, info, warn, error
LOG_FORMAT=json
```

### Configurar Alertas

```
Admin Panel > Configuración > Alertas
```

**Alertas disponibles:**
- Sistema down
- Error rate > 5%
- Response time > 2s
- Base de datos desconectada
- Stock bajo

---

**Siguiente paso**: [Guía de Desarrollo](./DESARROLLO.md)
