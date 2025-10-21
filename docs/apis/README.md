# 🔌 Documentación de APIs

## 📋 Índice

- [Información General](#información-general)
- [Autenticación](#autenticación)
- [Endpoints por Módulo](#endpoints-por-módulo)
- [Códigos de Respuesta](#códigos-de-respuesta)
- [Rate Limiting](#rate-limiting)
- [Versionado](#versionado)
- [WebSockets](#websockets)

## 🌐 Información General

### Base URL
```
Development:  http://localhost:4000/api/v1
Staging:      https://staging-api.turestaurante.com/api/v1
Production:   https://api.turestaurante.com/api/v1
```

### Content-Type
Todas las requests deben enviar:
```
Content-Type: application/json
```

### Formato de Respuesta

#### Respuesta Exitosa
```json
{
  "success": true,
  "data": { ... },
  "message": "Operación exitosa"
}
```

#### Respuesta con Error
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Los datos proporcionados no son válidos",
    "details": [
      {
        "field": "email",
        "message": "Email inválido"
      }
    ]
  }
}
```

#### Respuesta Paginada
```json
{
  "success": true,
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "totalPages": 8,
    "hasNext": true,
    "hasPrev": false
  }
}
```

## 🔐 Autenticación

### Registro de Usuario
```http
POST /auth/register
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "full_name": "Juan Pérez",
  "phone": "+54 11 1234-5678"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "full_name": "Juan Pérez",
      "role": "customer"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIs...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
      "expiresIn": 3600
    }
  }
}
```

### Login
```http
POST /auth/login
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "user": { ... },
    "tokens": {
      "accessToken": "...",
      "refreshToken": "...",
      "expiresIn": 3600
    }
  }
}
```

### Refresh Token
```http
POST /auth/refresh
```

**Request Body:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

### Logout
```http
POST /auth/logout
Authorization: Bearer {accessToken}
```

### Headers de Autenticación
Para endpoints protegidos, incluir:
```
Authorization: Bearer {accessToken}
```

## 📦 Endpoints por Módulo

### 🛒 Pedidos (Orders)

#### Listar Pedidos
```http
GET /orders?page=1&limit=20&status=pending&type=delivery
Authorization: Bearer {token}
```

**Query Parameters:**
- `page` (optional): Número de página (default: 1)
- `limit` (optional): Elementos por página (default: 20, max: 100)
- `status` (optional): Filtrar por estado
- `type` (optional): Filtrar por tipo (dine_in, takeout, delivery)
- `customer_id` (optional): Filtrar por cliente
- `from_date` (optional): Fecha inicial (ISO 8601)
- `to_date` (optional): Fecha final (ISO 8601)

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "order_number": "ORD-2024-00001",
      "customer": {
        "id": "uuid",
        "full_name": "Juan Pérez",
        "phone": "+54 11 1234-5678"
      },
      "type": "delivery",
      "status": "preparing",
      "items": [
        {
          "id": "uuid",
          "product": {
            "id": "uuid",
            "name": "Pizza Margarita",
            "image_url": "..."
          },
          "quantity": 2,
          "unit_price": 1500.00,
          "subtotal": 3000.00,
          "addons": [
            {
              "name": "Extra queso",
              "price": 200.00
            }
          ],
          "notes": "Sin cebolla"
        }
      ],
      "subtotal": 3000.00,
      "tax": 630.00,
      "delivery_fee": 300.00,
      "total": 3930.00,
      "created_at": "2024-10-21T10:30:00Z",
      "estimated_time": 30
    }
  ],
  "pagination": { ... }
}
```

#### Obtener Pedido
```http
GET /orders/:id
Authorization: Bearer {token}
```

#### Crear Pedido
```http
POST /orders
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "customer_id": "uuid",
  "type": "delivery",
  "table_id": null,
  "items": [
    {
      "product_id": "uuid",
      "quantity": 2,
      "notes": "Sin cebolla",
      "addons": ["addon-uuid-1", "addon-uuid-2"]
    }
  ],
  "delivery_address_id": "uuid",
  "notes": "Timbre roto, llamar al celular",
  "scheduled_for": null
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "order_number": "ORD-2024-00001",
    "status": "pending",
    ...
  },
  "message": "Pedido creado exitosamente"
}
```

#### Actualizar Estado de Pedido
```http
PATCH /orders/:id/status
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "status": "preparing",
  "notes": "Iniciando preparación"
}
```

#### Cancelar Pedido
```http
POST /orders/:id/cancel
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "reason": "Cliente solicitó cancelación"
}
```

#### Actualizar Ítem del Pedido
```http
PATCH /orders/:orderId/items/:itemId
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "status": "ready",
  "notes": "Listo para servir"
}
```

---

### 🍔 Productos (Products)

#### Listar Productos
```http
GET /products?category=burgers&available=true&page=1&limit=20
```

**Query Parameters:**
- `category` (optional): ID de categoría
- `available` (optional): true/false
- `featured` (optional): true/false
- `search` (optional): Búsqueda por nombre
- `page`, `limit`: Paginación

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Pizza Margarita",
      "description": "Pizza tradicional con tomate y mozzarella",
      "price": 1500.00,
      "category": {
        "id": "uuid",
        "name": "Pizzas"
      },
      "image_url": "https://...",
      "prep_time": 15,
      "calories": 850,
      "allergens": ["gluten", "lactosa"],
      "is_vegetarian": true,
      "is_vegan": false,
      "available": true,
      "addons": [
        {
          "id": "uuid",
          "name": "Extra queso",
          "price": 200.00
        }
      ]
    }
  ],
  "pagination": { ... }
}
```

#### Obtener Producto
```http
GET /products/:id
```

#### Crear Producto (Admin)
```http
POST /products
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "name": "Pizza Margarita",
  "description": "Pizza tradicional...",
  "price": 1500.00,
  "category_id": "uuid",
  "image_url": "https://...",
  "prep_time": 15,
  "allergens": ["gluten", "lactosa"],
  "is_vegetarian": true,
  "available": true
}
```

#### Actualizar Producto (Admin)
```http
PATCH /products/:id
Authorization: Bearer {token}
```

#### Eliminar Producto (Admin - Soft Delete)
```http
DELETE /products/:id
Authorization: Bearer {token}
```

---

### 📂 Categorías (Categories)

#### Listar Categorías
```http
GET /categories
```

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Pizzas",
      "description": "Nuestras deliciosas pizzas",
      "image_url": "https://...",
      "products_count": 15,
      "subcategories": [
        {
          "id": "uuid",
          "name": "Pizzas Vegetarianas",
          "products_count": 5
        }
      ]
    }
  ]
}
```

---

### 🧾 Facturas (Invoices)

#### Listar Facturas
```http
GET /invoices?page=1&limit=20&status=paid
Authorization: Bearer {token}
```

#### Obtener Factura
```http
GET /invoices/:id
Authorization: Bearer {token}
```

#### Crear Factura
```http
POST /invoices
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "order_id": "uuid",
  "customer_id": "uuid",
  "customer_name": "Juan Pérez",
  "customer_tax_id": "20-12345678-9",
  "invoice_type": "B",
  "items": [
    {
      "description": "Pizza Margarita x2",
      "quantity": 2,
      "unit_price": 1500.00,
      "tax_rate": 21.00
    }
  ]
}
```

#### Descargar PDF de Factura
```http
GET /invoices/:id/pdf
Authorization: Bearer {token}
```

---

### 💳 Pagos (Payments)

#### Crear Pago
```http
POST /payments
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "order_id": "uuid",
  "amount": 3930.00,
  "payment_method_id": "uuid",
  "gateway": "mercadopago",
  "metadata": {
    "card_last_digits": "1234"
  }
}
```

#### Procesar Pago con Stripe
```http
POST /payments/stripe/process
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "order_id": "uuid",
  "payment_intent_id": "pi_xxx",
  "amount": 3930.00
}
```

#### Procesar Pago con MercadoPago
```http
POST /payments/mercadopago/process
Authorization: Bearer {token}
```

#### Verificar Estado de Pago
```http
GET /payments/:id/status
Authorization: Bearer {token}
```

#### Crear Reembolso
```http
POST /payments/:id/refund
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "amount": 3930.00,
  "reason": "Pedido cancelado por el cliente"
}
```

---

### 🚚 Delivery

#### Listar Entregas
```http
GET /deliveries?status=in_transit&driver_id=uuid
Authorization: Bearer {token}
```

#### Obtener Entrega
```http
GET /deliveries/:id
Authorization: Bearer {token}
```

#### Asignar Repartidor
```http
POST /deliveries/:id/assign
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "driver_id": "uuid"
}
```

#### Actualizar Estado de Entrega
```http
PATCH /deliveries/:id/status
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "status": "picked_up",
  "latitude": -34.6037,
  "longitude": -58.3816
}
```

#### Obtener Ubicación de Repartidor en Tiempo Real
```http
GET /deliveries/:id/tracking
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "delivery_id": "uuid",
    "status": "in_transit",
    "driver": {
      "id": "uuid",
      "name": "Carlos Rodríguez",
      "phone": "+54 11 9876-5432",
      "vehicle": "Moto Honda 150cc",
      "rating": 4.8
    },
    "current_location": {
      "latitude": -34.6037,
      "longitude": -58.3816,
      "timestamp": "2024-10-21T11:15:00Z"
    },
    "estimated_arrival": "2024-10-21T11:30:00Z",
    "distance_remaining_km": 2.5
  }
}
```

---

### 🔔 Notificaciones

#### Listar Notificaciones del Usuario
```http
GET /notifications?unread=true
Authorization: Bearer {token}
```

#### Marcar Notificación como Leída
```http
PATCH /notifications/:id/read
Authorization: Bearer {token}
```

#### Marcar Todas como Leídas
```http
POST /notifications/mark-all-read
Authorization: Bearer {token}
```

#### Configurar Preferencias de Notificaciones
```http
PUT /notifications/preferences
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "email": {
    "order_confirmation": true,
    "order_updates": true,
    "promotions": false
  },
  "sms": {
    "order_confirmation": true,
    "order_updates": true,
    "promotions": false
  },
  "push": {
    "order_confirmation": true,
    "order_updates": true,
    "promotions": true
  }
}
```

---

### 📦 Inventario (Admin)

#### Listar Ingredientes
```http
GET /inventory/ingredients?low_stock=true
Authorization: Bearer {token}
```

#### Actualizar Stock
```http
PATCH /inventory/ingredients/:id/stock
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "quantity": 10.5,
  "type": "add", // "add" o "subtract"
  "reason": "Compra a proveedor",
  "supplier_id": "uuid"
}
```

#### Listar Movimientos de Inventario
```http
GET /inventory/movements?ingredient_id=uuid&from_date=2024-10-01
Authorization: Bearer {token}
```

---

### 🎁 Programa de Lealtad

#### Obtener Cuenta de Lealtad
```http
GET /loyalty/account
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "user_id": "uuid",
    "points": 1250,
    "lifetime_points": 5680,
    "tier": {
      "id": "uuid",
      "name": "Gold",
      "multiplier": 1.5,
      "benefits": [
        "15% descuento en pedidos",
        "Entrega gratis"
      ]
    }
  }
}
```

#### Listar Recompensas Disponibles
```http
GET /loyalty/rewards
Authorization: Bearer {token}
```

#### Canjear Recompensa
```http
POST /loyalty/redeem
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "reward_id": "uuid",
  "order_id": "uuid"
}
```

#### Historial de Transacciones de Puntos
```http
GET /loyalty/transactions?page=1&limit=20
Authorization: Bearer {token}
```

---

### 📅 Reservaciones

#### Listar Reservaciones
```http
GET /reservations?date=2024-10-21&status=confirmed
Authorization: Bearer {token}
```

#### Crear Reservación
```http
POST /reservations
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "date": "2024-10-21",
  "time_slot": "20:00",
  "party_size": 4,
  "notes": "Cerca de la ventana si es posible"
}
```

#### Cancelar Reservación
```http
POST /reservations/:id/cancel
Authorization: Bearer {token}
```

---

### 👥 Usuarios y Perfil

#### Obtener Perfil
```http
GET /users/me
Authorization: Bearer {token}
```

#### Actualizar Perfil
```http
PATCH /users/me
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "full_name": "Juan Carlos Pérez",
  "phone": "+54 11 1234-5678"
}
```

#### Listar Direcciones
```http
GET /users/me/addresses
Authorization: Bearer {token}
```

#### Agregar Dirección
```http
POST /users/me/addresses
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "label": "Casa",
  "street": "Av. Corrientes 1234",
  "city": "Buenos Aires",
  "postal_code": "C1043",
  "is_default": true
}
```

---

### 📊 Analytics (Admin)

#### Dashboard General
```http
GET /analytics/dashboard?from_date=2024-10-01&to_date=2024-10-31
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "total_sales": 125000.00,
    "total_orders": 450,
    "avg_ticket": 277.78,
    "growth_rate": 15.5,
    "top_products": [
      {
        "product_id": "uuid",
        "name": "Pizza Margarita",
        "units_sold": 120,
        "revenue": 18000.00
      }
    ],
    "sales_by_day": [
      {
        "date": "2024-10-01",
        "sales": 4500.00,
        "orders": 18
      }
    ],
    "sales_by_hour": [...],
    "order_types": {
      "dine_in": 45,
      "takeout": 30,
      "delivery": 25
    }
  }
}
```

#### Reporte de Ventas
```http
GET /analytics/sales?period=monthly&year=2024&month=10
Authorization: Bearer {token}
```

---

## 📡 WebSockets

### Conexión
```javascript
const socket = io('wss://api.turestaurante.com', {
  auth: {
    token: 'Bearer eyJhbGciOiJIUzI1NiIs...'
  }
});
```

### Eventos del Servidor → Cliente

#### Nuevo Pedido (KDS)
```javascript
socket.on('order:created', (data) => {
  console.log('Nuevo pedido:', data);
  // {
  //   id: "uuid",
  //   order_number: "ORD-2024-00001",
  //   items: [...],
  //   ...
  // }
});
```

#### Actualización de Pedido
```javascript
socket.on('order:updated', (data) => {
  console.log('Pedido actualizado:', data);
  // {
  //   id: "uuid",
  //   status: "preparing",
  //   ...
  // }
});
```

#### Actualización de Ubicación de Delivery
```javascript
socket.on('delivery:location', (data) => {
  console.log('Nueva ubicación:', data);
  // {
  //   delivery_id: "uuid",
  //   latitude: -34.6037,
  //   longitude: -58.3816,
  //   timestamp: "2024-10-21T11:15:00Z"
  // }
});
```

#### Notificación Push
```javascript
socket.on('notification:new', (data) => {
  console.log('Nueva notificación:', data);
  // {
  //   id: "uuid",
  //   title: "Tu pedido está listo",
  //   body: "El pedido #123 está listo para recoger",
  //   ...
  // }
});
```

### Eventos del Cliente → Servidor

#### Unirse a Sala de Pedido
```javascript
socket.emit('order:join', { orderId: 'uuid' });
```

#### Salir de Sala de Pedido
```javascript
socket.emit('order:leave', { orderId: 'uuid' });
```

---

## ⚠️ Códigos de Respuesta HTTP

| Código | Significado | Uso |
|--------|-------------|-----|
| 200 | OK | Petición exitosa |
| 201 | Created | Recurso creado exitosamente |
| 204 | No Content | Petición exitosa sin contenido |
| 400 | Bad Request | Datos inválidos |
| 401 | Unauthorized | No autenticado |
| 403 | Forbidden | Sin permisos |
| 404 | Not Found | Recurso no encontrado |
| 409 | Conflict | Conflicto (ej: email duplicado) |
| 422 | Unprocessable Entity | Validación fallida |
| 429 | Too Many Requests | Rate limit excedido |
| 500 | Internal Server Error | Error del servidor |
| 503 | Service Unavailable | Servicio temporalmente no disponible |

---

## 🚦 Rate Limiting

### Límites por Tipo de Usuario

| Tipo | Requests por Minuto |
|------|---------------------|
| Sin autenticar | 30 |
| Cliente | 100 |
| Empleado | 300 |
| Admin | 1000 |

### Headers de Rate Limit
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1634567890
```

### Respuesta cuando se excede el límite (429)
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Demasiadas peticiones. Intenta nuevamente en 60 segundos.",
    "retry_after": 60
  }
}
```

---

## 🔄 Versionado

La API usa versionado en la URL:
```
/api/v1/orders
/api/v2/orders  (futura versión)
```

### Deprecación
Las versiones antiguas serán soportadas por al menos 6 meses después de lanzar una nueva versión.

---

**Para más detalles**, ver documentación interactiva en:
- Swagger UI: `https://api.turestaurante.com/docs`
- Postman Collection: [Link a colección]
