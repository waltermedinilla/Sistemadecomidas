# 🏗️ Arquitectura del Sistema de Comandas

## 📋 Índice

- [Visión General](#visión-general)
- [Arquitectura de Alto Nivel](#arquitectura-de-alto-nivel)
- [Patrones de Diseño](#patrones-de-diseño)
- [Capas del Sistema](#capas-del-sistema)
- [Microservicios](#microservicios)
- [Comunicación entre Servicios](#comunicación-entre-servicios)
- [Escalabilidad](#escalabilidad)
- [Seguridad](#seguridad)
- [Resiliencia](#resiliencia)

## 🎯 Visión General

El sistema está diseñado como una **arquitectura de microservicios** con las siguientes características:

- **Desacoplamiento**: Cada servicio es independiente
- **Escalabilidad horizontal**: Cada microservicio puede escalar independientemente
- **Tolerancia a fallos**: Si un servicio falla, no afecta a los demás
- **Tecnología flexible**: Cada servicio puede usar la tecnología más apropiada
- **Desarrollo paralelo**: Equipos pueden trabajar en servicios diferentes simultáneamente

## 🏛️ Arquitectura de Alto Nivel

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         CAPA DE PRESENTACIÓN                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐ │
│  │  Web Admin   │  │     KDS      │  │     POS      │  │ App Móvil   │ │
│  │   (React)    │  │   (React)    │  │   (React)    │  │(React Native)│ │
│  └──────────────┘  └──────────────┘  └──────────────┘  └─────────────┘ │
│                                                                          │
│  ┌──────────────┐  ┌──────────────┐                                     │
│  │ App Delivery │  │  Web Cliente │                                     │
│  │(React Native)│  │   (Next.js)  │                                     │
│  └──────────────┘  └──────────────┘                                     │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                          API GATEWAY (Nginx)                             │
│                    Load Balancer + Reverse Proxy                         │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                        CAPA DE APLICACIÓN                                │
│                    Backend API (NestJS/Express)                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  REST API                   GraphQL                WebSockets            │
│  /api/v1/*                  /graphql              /socket.io            │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                      CAPA DE MICROSERVICIOS                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ Pedidos  │  │Factura-  │  │ Delivery │  │  Pagos   │  │Notifica- │  │
│  │ Service  │  │  ción    │  │ Service  │  │ Service  │  │  ciones  │  │
│  │          │  │ Service  │  │          │  │          │  │ Service  │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
│                                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐                │
│  │Inventario│  │Analytics │  │ Usuarios │  │   Auth   │                │
│  │ Service  │  │ Service  │  │ Service  │  │ Service  │                │
│  │          │  │          │  │          │  │          │  │                │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘                │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                     MESSAGE BROKER (Redis/RabbitMQ)                      │
│                    Event Bus para comunicación asíncrona                 │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                      CAPA DE INTEGRACIÓN                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐ │
│  │   Gateway    │  │  SMS/WhatsApp│  │    Email     │  │    Push     │ │
│  │    Pagos     │  │   (Twilio)   │  │  (SendGrid)  │  │  (Firebase) │ │
│  │(Stripe/MP)   │  │              │  │              │  │             │ │
│  └──────────────┘  └──────────────┘  └──────────────┘  └─────────────┘ │
│                                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                  │
│  │  Google Maps │  │ Facturación  │  │   Storage    │                  │
│  │     API      │  │  Electrónica │  │   (AWS S3)   │                  │
│  │              │  │   (AFIP)     │  │              │                  │
│  └──────────────┘  └──────────────┘  └──────────────┘                  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                          CAPA DE DATOS                                   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────────────┐  ┌──────────────────┐  ┌────────────────────┐    │
│  │   PostgreSQL     │  │      Redis       │  │      MongoDB       │    │
│  │  (Base Principal)│  │  (Cache/Queue)   │  │   (Logs/Analytics) │    │
│  └──────────────────┘  └──────────────────┘  └────────────────────┘    │
│                                                                          │
│  ┌──────────────────┐                                                   │
│  │    AWS S3        │                                                   │
│  │ (Imágenes/Files) │                                                   │
│  └──────────────────┘                                                   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

## 🎨 Patrones de Diseño

### 1. Microservicios
Cada funcionalidad principal es un servicio independiente que puede ser desarrollado, desplegado y escalado por separado.

### 2. API Gateway
Punto único de entrada para todas las peticiones del frontend. Maneja:
- Enrutamiento
- Autenticación
- Rate limiting
- Load balancing

### 3. Event-Driven Architecture
Los servicios se comunican mediante eventos asíncronos usando un message broker (Redis/RabbitMQ):
- `order.created`
- `order.updated`
- `payment.processed`
- `delivery.assigned`

### 4. CQRS (Command Query Responsibility Segregation)
Separación de operaciones de lectura y escritura para optimizar performance:
- **Commands**: Crear pedido, actualizar inventario
- **Queries**: Listar pedidos, obtener reportes

### 5. Repository Pattern
Abstracción de la capa de datos para facilitar testing y cambios de base de datos.

### 6. Dependency Injection
Todos los servicios usan DI para mejorar testabilidad y mantenibilidad.

## 📦 Capas del Sistema

### Capa de Presentación
**Responsabilidad**: Interfaz de usuario

**Componentes**:
- Web Admin Dashboard
- Kitchen Display System (KDS)
- Point of Sale (POS)
- App Móvil Cliente
- App Móvil Delivery

**Tecnologías**: React, Next.js, React Native, TypeScript

### Capa de API Gateway
**Responsabilidad**: Punto único de entrada, enrutamiento, autenticación

**Componentes**:
- Nginx (Reverse Proxy)
- API Gateway Service

**Funciones**:
- Load Balancing
- Rate Limiting
- JWT Validation
- Request/Response Logging

### Capa de Aplicación (Backend)
**Responsabilidad**: Lógica de negocio, validación, orquestación

**Componentes**:
- REST API
- GraphQL API
- WebSocket Server

**Tecnologías**: NestJS, TypeScript, Socket.io

### Capa de Microservicios
**Responsabilidad**: Implementación de funcionalidades específicas

Ver sección [Microservicios](#microservicios) para detalles.

### Capa de Integración
**Responsabilidad**: Comunicación con servicios externos

**Servicios externos**:
- Pasarelas de pago
- Servicios de mensajería (SMS, Email, Push)
- APIs de mapas
- Facturación electrónica
- Cloud storage

### Capa de Datos
**Responsabilidad**: Persistencia y almacenamiento

**Componentes**:
- PostgreSQL (datos relacionales)
- Redis (cache, sessions, queues)
- MongoDB (logs, analytics)
- AWS S3 (archivos)

## 🔧 Microservicios

### 1. Servicio de Pedidos
**Puerto**: 4001
**Responsabilidad**: Gestión completa del ciclo de vida de pedidos

**Funcionalidades**:
- Crear, actualizar, cancelar pedidos
- Gestión de estados (pendiente, en preparación, listo, entregado)
- Modificaciones de pedidos
- Historial de pedidos

**Base de Datos**: PostgreSQL (tablas: orders, order_items)

**Eventos emitidos**:
- `order.created`
- `order.updated`
- `order.cancelled`
- `order.completed`

**Eventos consumidos**:
- `payment.confirmed`
- `inventory.updated`

### 2. Servicio de Facturación
**Puerto**: 4002
**Responsabilidad**: Generación y gestión de facturas

**Funcionalidades**:
- Generar facturas electrónicas
- División de cuentas
- Notas de crédito
- Reportes fiscales
- Integración con sistemas fiscales (AFIP, SAT, SUNAT)

**Base de Datos**: PostgreSQL (tablas: invoices, invoice_items, tax_info)

**Eventos emitidos**:
- `invoice.generated`
- `invoice.cancelled`

**Eventos consumidos**:
- `order.completed`
- `payment.processed`

### 3. Servicio de Delivery
**Puerto**: 4003
**Responsabilidad**: Gestión de entregas y repartidores

**Funcionalidades**:
- Asignación automática de repartidores
- Tracking GPS en tiempo real
- Optimización de rutas
- Gestión de zonas de entrega
- Rating de repartidores

**Base de Datos**: PostgreSQL (tablas: deliveries, drivers, delivery_zones)

**Eventos emitidos**:
- `delivery.assigned`
- `delivery.in_transit`
- `delivery.completed`

**Eventos consumidos**:
- `order.ready_for_delivery`

### 4. Servicio de Pagos
**Puerto**: 4004
**Responsabilidad**: Procesamiento de pagos

**Funcionalidades**:
- Procesar múltiples métodos de pago
- Pre-autorización de tarjetas
- Reembolsos
- Reconciliación de pagos
- Integración con gateways (Stripe, MercadoPago, PayPal)

**Base de Datos**: PostgreSQL (tablas: payments, transactions, payment_methods)

**Eventos emitidos**:
- `payment.processed`
- `payment.confirmed`
- `payment.failed`
- `payment.refunded`

**Eventos consumidos**:
- `order.created`
- `invoice.generated`

### 5. Servicio de Notificaciones
**Puerto**: 4005
**Responsabilidad**: Envío de notificaciones multi-canal

**Funcionalidades**:
- SMS (Twilio)
- WhatsApp (WhatsApp Business API)
- Email (SendGrid)
- Push Notifications (Firebase)
- Plantillas de mensajes
- Programación de notificaciones

**Base de Datos**: MongoDB (logs de notificaciones)

**Eventos emitidos**:
- `notification.sent`
- `notification.failed`

**Eventos consumidos**:
- `order.created`
- `delivery.assigned`
- `payment.confirmed`
- `order.ready`

### 6. Servicio de Inventario
**Puerto**: 4006
**Responsabilidad**: Control de stock e ingredientes

**Funcionalidades**:
- Gestión de productos
- Control de stock en tiempo real
- Alertas de stock bajo
- Gestión de recetas (deducción automática de ingredientes)
- Órdenes de compra
- Gestión de proveedores

**Base de Datos**: PostgreSQL (tablas: products, inventory, recipes, suppliers)

**Eventos emitidos**:
- `inventory.low_stock`
- `inventory.updated`
- `product.out_of_stock`

**Eventos consumidos**:
- `order.created`

### 7. Servicio de Analytics
**Puerto**: 4007
**Responsabilidad**: Análisis de datos y reportes

**Funcionalidades**:
- Dashboard de métricas
- Reportes de ventas
- Análisis de productos más vendidos
- Predicción de demanda
- Análisis de rentabilidad
- Reportes personalizados

**Base de Datos**: MongoDB (datos agregados), PostgreSQL (consultas complejas)

**Eventos consumidos**:
- Todos los eventos del sistema para análisis

### 8. Servicio de Usuarios
**Puerto**: 4008
**Responsabilidad**: Gestión de usuarios y perfiles

**Funcionalidades**:
- CRUD de usuarios
- Gestión de roles y permisos
- Perfiles de clientes
- Programa de lealtad
- Historial de pedidos por usuario

**Base de Datos**: PostgreSQL (tablas: users, roles, permissions, loyalty_points)

### 9. Servicio de Autenticación
**Puerto**: 4009
**Responsabilidad**: Autenticación y autorización

**Funcionalidades**:
- Login/Logout
- Registro de usuarios
- JWT tokens
- Refresh tokens
- OAuth (Google, Facebook)
- 2FA (Two-Factor Authentication)
- Password reset

**Base de Datos**: Redis (sessions, tokens), PostgreSQL (users)

## 🔄 Comunicación entre Servicios

### Síncrona (REST/GraphQL)
Usada para operaciones que requieren respuesta inmediata:

```
Frontend → API Gateway → Microservicio → Respuesta
```

**Ejemplo**: Obtener detalles de un pedido

### Asíncrona (Event-Driven)
Usada para operaciones que no requieren respuesta inmediata:

```
Microservicio A → Event Bus → Microservicio B
```

**Ejemplo**:
1. Servicio de Pedidos emite `order.created`
2. Servicio de Inventario consume el evento y actualiza stock
3. Servicio de Notificaciones consume el evento y envía SMS al cliente

### Tiempo Real (WebSockets)
Usada para actualizaciones en tiempo real:

```
Backend → WebSocket → Frontend (actualización automática)
```

**Ejemplo**: Actualización de pedidos en el KDS

## ⚡ Escalabilidad

### Escalado Horizontal
Cada microservicio puede escalarse independientemente:

```
Load Balancer
      ↓
┌─────────────────┐
│ Pedidos Service │ ← Instancia 1
│ Pedidos Service │ ← Instancia 2
│ Pedidos Service │ ← Instancia 3
└─────────────────┘
```

### Cache Strategy
- **Redis**: Cache de sesiones, datos frecuentemente accedidos
- **CDN**: Assets estáticos (imágenes, CSS, JS)

### Database Optimization
- **Read Replicas**: Para consultas de solo lectura
- **Sharding**: Particionamiento horizontal de datos
- **Indexing**: Índices en campos frecuentemente consultados

### Queue Management
- **Bull Queue**: Para procesar tareas asíncronas
- Ejemplo: Envío masivo de notificaciones

## 🔒 Seguridad

### Autenticación
- **JWT Tokens**: Para autenticación stateless
- **Refresh Tokens**: Para renovación segura de tokens
- **OAuth 2.0**: Integración con proveedores externos

### Autorización
- **RBAC** (Role-Based Access Control): Permisos basados en roles
- **Middleware de autorización**: En cada endpoint

### Encriptación
- **HTTPS/TLS**: Todas las comunicaciones encriptadas
- **Bcrypt**: Hash de contraseñas
- **Encriptación de datos sensibles**: PII, información de pago

### API Security
- **Rate Limiting**: Prevención de abusos
- **CORS**: Control de orígenes permitidos
- **Input Validation**: Validación de todos los inputs
- **SQL Injection Prevention**: Uso de ORMs y prepared statements

### Secrets Management
- **Variables de entorno**: Para credenciales
- **Vault**: Para secretos críticos (opcional)

## 🛡️ Resiliencia

### Circuit Breaker Pattern
Si un servicio falla, el circuit breaker previene llamadas adicionales y retorna un fallback.

### Retry Logic
Reintentos automáticos con exponential backoff para operaciones fallidas.

### Health Checks
Cada microservicio expone un endpoint `/health` para monitoreo.

### Graceful Degradation
Si un servicio no crítico falla, el sistema continúa funcionando con funcionalidad reducida.

### Backup & Recovery
- Backups automáticos diarios de PostgreSQL
- Replicación de Redis
- Disaster recovery plan

## 📊 Monitoreo y Logging

### Logging
- **Centralized Logging**: ELK Stack (Elasticsearch, Logstash, Kibana)
- **Structured Logs**: JSON format
- **Log Levels**: ERROR, WARN, INFO, DEBUG

### Monitoring
- **Prometheus**: Métricas del sistema
- **Grafana**: Visualización de métricas
- **Alertas**: Notificaciones automáticas de problemas

### Tracing
- **Distributed Tracing**: Seguimiento de requests a través de microservicios
- **Correlation IDs**: Para rastrear requests

## 🚀 Deployment

### Containerización
- **Docker**: Cada microservicio en su contenedor
- **Docker Compose**: Para desarrollo local
- **Kubernetes**: Para producción (orquestación de contenedores)

### CI/CD
- **GitHub Actions**: Pipeline de CI/CD
- **Automated Testing**: Tests ejecutados en cada PR
- **Automated Deployment**: Deploy automático a staging/production

### Environments
- **Development**: Local
- **Staging**: Pre-producción
- **Production**: Producción

---

**Próximos Pasos**: Ver [Stack Tecnológico](./STACK_TECNOLOGICO.md) para detalles de implementación.
