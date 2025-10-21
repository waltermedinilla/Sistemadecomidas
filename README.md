# 🍽️ Sistema de Comandas para Restaurante

Sistema completo de gestión de comandas para restaurantes y comidas rápidas, con módulos de pedidos, cocina, facturación, delivery, notificaciones y más.

## 📋 Tabla de Contenidos

- [Descripción General](#descripción-general)
- [Características Principales](#características-principales)
- [Arquitectura](#arquitectura)
- [Módulos del Sistema](#módulos-del-sistema)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Stack Tecnológico](#stack-tecnológico)
- [Documentación](#documentación)
- [Instalación](#instalación)
- [Licencia](#licencia)

## 🎯 Descripción General

Sistema integral para la gestión de restaurantes que incluye:

- **Gestión de Pedidos**: Control completo del flujo de órdenes
- **Kitchen Display System (KDS)**: Pantalla para cocina en tiempo real
- **Sistema de Facturación**: Generación automática de facturas electrónicas
- **Delivery Management**: Gestión completa de entregas con tracking GPS
- **Notificaciones Multi-canal**: SMS, WhatsApp, Email, Push
- **Verificación de Pagos**: Múltiples métodos de pago integrados
- **Panel Web Administrativo**: Dashboard completo con analytics

## ✨ Características Principales

### 🔥 Core Features

- ✅ Gestión de pedidos en tiempo real
- ✅ Kitchen Display System (KDS) multi-estación
- ✅ Sistema de facturación electrónica
- ✅ Gestión de delivery con GPS tracking
- ✅ Notificaciones automáticas (SMS, WhatsApp, Email, Push)
- ✅ Verificación y procesamiento de pagos múltiples
- ✅ Panel administrativo web completo

### 🚀 Funcionalidades Avanzadas

- 📊 Analytics e Inteligencia de Negocios
- 📦 Control de Inventario en tiempo real
- 👥 Gestión de Personal y Turnos
- 🎁 Programa de Lealtad y Recompensas
- 📅 Sistema de Reservaciones
- 📱 App Móvil para Clientes
- 🏍️ App para Repartidores
- 💳 Múltiples métodos de pago
- 🌐 Pedidos Online / QR Self-Service
- 📈 Reportes y Dashboards en tiempo real

## 🏗️ Arquitectura

El sistema está construido con arquitectura de **microservicios** utilizando las siguientes capas:

```
┌─────────────────────────────────────────────────┐
│         CAPA DE PRESENTACIÓN                    │
│  Web Admin | KDS | POS | App Móvil | App Delivery│
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│         CAPA DE API/BACKEND                     │
│  API REST/GraphQL + WebSockets (Tiempo Real)    │
│  Microservicios: Pedidos | Facturación | Delivery│
│  Pagos | Notificaciones | Inventario | Analytics│
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│         CAPA DE INTEGRACIÓN                     │
│  Gateway Pagos | SMS/WhatsApp | Email | Push    │
│  Mapas/GPS | Facturación Electrónica            │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│         CAPA DE DATOS                           │
│  PostgreSQL | Redis | MongoDB | S3              │
└─────────────────────────────────────────────────┘
```

Ver [documentación completa de arquitectura](./docs/arquitectura/ARQUITECTURA.md)

## 📦 Módulos del Sistema

### Módulos Core

1. **[Gestión de Pedidos](./docs/modulos/PEDIDOS.md)** - Control de órdenes y comandas
2. **[Kitchen Display System](./docs/modulos/KDS.md)** - Display para cocina
3. **[Facturación](./docs/modulos/FACTURACION.md)** - Facturación electrónica
4. **[Delivery](./docs/modulos/DELIVERY.md)** - Gestión de entregas
5. **[Notificaciones](./docs/modulos/NOTIFICACIONES.md)** - Sistema multi-canal
6. **[Pagos](./docs/modulos/PAGOS.md)** - Procesamiento de pagos
7. **[Panel Administrativo](./docs/modulos/ADMIN.md)** - Dashboard web

### Módulos Adicionales

8. **[Inventario](./docs/modulos/INVENTARIO.md)** - Control de stock
9. **[Lealtad](./docs/modulos/LEALTAD.md)** - Programa de puntos
10. **[Analytics](./docs/modulos/ANALYTICS.md)** - Inteligencia de negocios
11. **[Personal](./docs/modulos/PERSONAL.md)** - Gestión de empleados
12. **[Reservaciones](./docs/modulos/RESERVACIONES.md)** - Sistema de reservas
13. **[Marketing/CRM](./docs/modulos/MARKETING.md)** - Gestión de clientes
14. **[Pedidos Online](./docs/modulos/ONLINE.md)** - E-commerce y autoservicio

## 📁 Estructura del Proyecto

```
ProgramadeComidas/
├── backend/                    # Backend (Microservicios)
│   ├── services/              # Servicios independientes
│   │   ├── pedidos/          # Servicio de pedidos
│   │   ├── facturacion/      # Servicio de facturación
│   │   ├── delivery/         # Servicio de delivery
│   │   ├── pagos/            # Servicio de pagos
│   │   ├── notificaciones/   # Servicio de notificaciones
│   │   ├── inventario/       # Servicio de inventario
│   │   ├── analytics/        # Servicio de analytics
│   │   ├── usuarios/         # Servicio de usuarios
│   │   └── auth/             # Servicio de autenticación
│   ├── shared/               # Código compartido
│   └── config/               # Configuraciones globales
│
├── frontend/                  # Frontend (Web)
│   ├── web-admin/            # Panel administrativo
│   ├── kds/                  # Kitchen Display System
│   ├── pos/                  # Punto de Venta
│   ├── app-cliente/          # App web cliente
│   └── app-delivery/         # App web delivery
│
├── mobile/                    # Aplicaciones móviles
│   ├── cliente/              # App móvil cliente
│   └── delivery/             # App móvil repartidores
│
├── database/                  # Base de datos
│   ├── migrations/           # Migraciones
│   ├── seeds/                # Seeds de prueba
│   └── schemas/              # Esquemas y modelos
│
├── infrastructure/            # Infraestructura
│   ├── docker/               # Docker configs
│   ├── kubernetes/           # K8s configs
│   └── nginx/                # Nginx configs
│
├── tests/                     # Tests
│   ├── unit/                 # Tests unitarios
│   ├── integration/          # Tests de integración
│   └── e2e/                  # Tests end-to-end
│
├── docs/                      # Documentación
│   ├── arquitectura/         # Docs de arquitectura
│   ├── base-de-datos/        # Docs de BD
│   ├── apis/                 # Docs de APIs
│   ├── modulos/              # Docs de módulos
│   └── guias/                # Guías de uso
│
└── scripts/                   # Scripts útiles
```

## 🛠️ Stack Tecnológico

### Backend
- **Runtime**: Node.js 20+
- **Framework**: NestJS (TypeScript)
- **API**: REST + GraphQL
- **Tiempo Real**: Socket.io
- **Base de Datos**: PostgreSQL 15+
- **Cache**: Redis 7+
- **Message Queue**: Redis Bull
- **ORM**: TypeORM / Prisma

### Frontend Web
- **Framework**: React 18+ con Next.js 14+
- **Lenguaje**: TypeScript
- **UI Library**: TailwindCSS + shadcn/ui
- **Estado**: Zustand / Redux Toolkit
- **Comunicación**: React Query + Axios
- **Tiempo Real**: Socket.io-client

### Mobile
- **Framework**: React Native / Flutter
- **Navegación**: React Navigation
- **Estado**: Zustand / Redux

### DevOps & Infraestructura
- **Contenedores**: Docker + Docker Compose
- **Orquestación**: Kubernetes (opcional)
- **Proxy**: Nginx
- **CI/CD**: GitHub Actions
- **Cloud**: AWS / Google Cloud / Azure
- **Monitoreo**: Prometheus + Grafana
- **Logs**: ELK Stack

### Integraciones
- **Pagos**: Stripe, MercadoPago, PayPal
- **SMS**: Twilio
- **WhatsApp**: WhatsApp Business API
- **Email**: SendGrid, AWS SES
- **Push**: Firebase Cloud Messaging
- **Mapas**: Google Maps API
- **Facturación**: Integración con sistemas fiscales (AFIP, SAT, SUNAT)

## 📚 Documentación

### Seguimiento del Proyecto

- **[📊 PROJECT TRACKER](./PROJECT_TRACKER.md)** ⭐ **NUEVO** - Checklist completo de todas las fases del proyecto

### Documentación Técnica

- [Arquitectura del Sistema](./docs/arquitectura/ARQUITECTURA.md)
- [Diagrama de Base de Datos](./docs/base-de-datos/DIAGRAMA_ER.md)
- [Esquemas de Base de Datos](./docs/base-de-datos/ESQUEMAS.md)
- [Documentación de APIs](./docs/apis/README.md)
- [Stack Tecnológico Detallado](./docs/arquitectura/STACK_TECNOLOGICO.md)

### Guías

- [Guía de Instalación](./docs/guias/INSTALACION.md)
- [Guía de Configuración](./docs/guias/CONFIGURACION.md)
- [Guía de Desarrollo](./docs/guias/DESARROLLO.md)
- [Guía de Despliegue](./docs/guias/DESPLIEGUE.md)

### Documentación de Módulos

Cada módulo tiene su propia documentación detallada en [./docs/modulos/](./docs/modulos/)

## 🚀 Instalación

### Requisitos Previos

- Node.js 20+ y npm/yarn/pnpm
- Docker y Docker Compose
- PostgreSQL 15+ (o usar Docker)
- Redis 7+ (o usar Docker)

### Instalación Rápida con Docker

```bash
# Clonar el repositorio
git clone <repository-url>
cd ProgramadeComidas

# Copiar variables de entorno
cp .env.example .env

# Levantar servicios con Docker
docker-compose up -d

# Acceder a:
# - Admin Panel: http://localhost:3000
# - API: http://localhost:4000
# - KDS: http://localhost:3001
```

Ver [Guía de Instalación Completa](./docs/guias/INSTALACION.md)

## 🧪 Testing

```bash
# Tests unitarios
npm run test

# Tests de integración
npm run test:integration

# Tests e2e
npm run test:e2e

# Coverage
npm run test:coverage
```

## 📈 Roadmap

### Fase 1 - MVP (Meses 1-2)
- ✅ Gestión básica de pedidos
- ✅ KDS básico
- ✅ Facturación simple
- ✅ Panel admin básico

### Fase 2 - Delivery (Mes 3)
- ⏳ Sistema de delivery
- ⏳ App para repartidores
- ⏳ Tracking GPS

### Fase 3 - Advanced (Meses 4-5)
- ⏳ Inventario
- ⏳ Analytics
- ⏳ Programa de lealtad

### Fase 4 - Mobile & Marketing (Mes 6)
- ⏳ App móvil clientes
- ⏳ CRM y Marketing
- ⏳ Reservaciones

## 🤝 Contribución

Por favor lee [CONTRIBUTING.md](./CONTRIBUTING.md) para detalles sobre nuestro código de conducta y el proceso para enviarnos pull requests.

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](./LICENSE) para más detalles.

## 👥 Equipo

- **Desarrollador Principal**: [Tu Nombre]
- **Arquitecto**: [Nombre]

## 📞 Soporte

Para soporte, email a support@turestaurante.com o únete a nuestro Slack.

---

**Versión**: 1.0.0
**Última Actualización**: Octubre 2025
**Estado**: 🚧 En Desarrollo
