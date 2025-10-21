# 📚 Documentación del Sistema de Comandas

Bienvenido a la documentación completa del Sistema de Comandas para Restaurantes.

## 🗂️ Índice General

### 🏗️ Arquitectura

- **[Arquitectura del Sistema](./arquitectura/ARQUITECTURA.md)**
  - Visión general de la arquitectura
  - Patrones de diseño utilizados
  - Capas del sistema
  - Microservicios
  - Comunicación entre servicios
  - Escalabilidad y resiliencia

- **[Stack Tecnológico](./arquitectura/STACK_TECNOLOGICO.md)**
  - Tecnologías del backend
  - Tecnologías del frontend
  - Mobile framework
  - Base de datos
  - DevOps e infraestructura
  - Integraciones externas
  - Justificación de elecciones

### 🗄️ Base de Datos

- **[Diagrama Entidad-Relación](./base-de-datos/DIAGRAMA_ER.md)**
  - Diagrama completo del sistema
  - Entidades principales
  - Relaciones entre entidades
  - Índices y optimizaciones

- **[Esquemas SQL](./base-de-datos/ESQUEMAS.md)**
  - Definiciones de tablas
  - Constraints y validaciones
  - Triggers y procedimientos
  - Datos de ejemplo

### 🔌 APIs

- **[Documentación de APIs](./apis/README.md)**
  - Endpoints REST
  - Autenticación y autorización
  - Ejemplos de requests/responses
  - Códigos de error
  - Rate limiting
  - WebSockets
  - GraphQL (opcional)

### 📦 Módulos del Sistema

#### Módulos Core
- **[Pedidos](./modulos/PEDIDOS.md)** - Gestión completa de pedidos
- **[KDS (Kitchen Display System)](./modulos/KDS.md)** - Sistema de pantallas de cocina
- **Facturación** - Sistema de facturación electrónica
- **Delivery** - Gestión de entregas y repartidores
- **Pagos** - Procesamiento de pagos
- **Notificaciones** - Sistema multi-canal de notificaciones

#### Módulos Adicionales
- **Inventario** - Control de stock e ingredientes
- **Lealtad** - Programa de puntos y recompensas
- **Analytics** - Reportes e inteligencia de negocios
- **Personal** - Gestión de empleados y turnos
- **Reservaciones** - Sistema de reservas de mesas
- **Marketing/CRM** - Gestión de clientes
- **Pedidos Online** - E-commerce y autoservicio

### 📖 Guías

- **[Guía de Instalación](./guias/INSTALACION.md)**
  - Requisitos previos
  - Instalación con Docker
  - Instalación manual
  - Configuración de base de datos
  - Variables de entorno
  - Troubleshooting

- **[Guía de Configuración](./guias/CONFIGURACION.md)**
  - Configuración inicial del restaurante
  - Integraciones (Stripe, Twilio, etc.)
  - Notificaciones
  - KDS
  - Delivery
  - Facturación
  - Seguridad

- **Guía de Desarrollo** (Próximamente)
  - Estructura del código
  - Convenciones de código
  - Testing
  - Git workflow
  - CI/CD

- **Guía de Despliegue** (Próximamente)
  - Despliegue en AWS
  - Despliegue en Google Cloud
  - Despliegue en Azure
  - Docker en producción
  - Kubernetes

## 🚀 Quick Start

### Para Desarrolladores

1. **Leer primero:**
   - [README Principal](../README.md)
   - [Arquitectura del Sistema](./arquitectura/ARQUITECTURA.md)
   - [Stack Tecnológico](./arquitectura/STACK_TECNOLOGICO.md)

2. **Instalación:**
   - Seguir [Guía de Instalación](./guias/INSTALACION.md)

3. **Configuración:**
   - Seguir [Guía de Configuración](./guias/CONFIGURACION.md)

4. **Desarrollo:**
   - Revisar documentación de APIs
   - Revisar documentación de módulos relevantes

### Para Administradores

1. **Instalación del sistema:**
   - [Guía de Instalación](./guias/INSTALACION.md)

2. **Configuración inicial:**
   - [Guía de Configuración](./guias/CONFIGURACION.md)
   - Configurar información del restaurante
   - Configurar menú y productos
   - Configurar integraciones (pagos, notificaciones)

3. **Gestión diaria:**
   - Panel administrativo
   - Reportes y analytics

## 📊 Diagramas Importantes

### Flujo de un Pedido

```
Cliente → Crear Pedido → Confirmar → Cocina (KDS) → Preparar
                                                         ↓
                                                      Listo
                                                         ↓
                                        ┌────────────────┴────────────────┐
                                        │                                  │
                                   Dine-in                            Delivery
                                        │                                  │
                                    Servir                          Asignar Repartidor
                                        │                                  │
                                        └────────────────┬─────────────────┘
                                                         ↓
                                                   Completado
                                                         ↓
                                                  Generar Factura
                                                         ↓
                                                  Procesar Pago
```

### Arquitectura de Microservicios

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│ Frontend │────>│    API   │────>│ Pedidos  │────>│   DB     │
│   Apps   │     │ Gateway  │     │ Service  │     │          │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
                       │                 │
                       │                 │
                       ↓                 ↓
                 ┌──────────┐     ┌──────────┐
                 │ Delivery │     │  Pagos   │
                 │ Service  │     │ Service  │
                 └──────────┘     └──────────┘
```

## 🎯 Casos de Uso Principales

### 1. Cliente hace un pedido de delivery

```
1. Cliente abre app móvil
2. Selecciona productos del menú
3. Agrega dirección de entrega
4. Confirma pedido
5. Sistema calcula delivery fee
6. Cliente paga
7. Pedido aparece en KDS de cocina
8. Cocina prepara y marca como listo
9. Sistema asigna repartidor automáticamente
10. Repartidor recoge pedido
11. Cliente recibe tracking en tiempo real
12. Repartidor entrega
13. Sistema genera factura electrónica
```

### 2. Mesero toma un pedido en mesa

```
1. Mesero abre POS en tablet
2. Selecciona mesa
3. Agrega productos
4. Envía a cocina
5. KDS muestra pedido
6. Cocina prepara
7. Mesero recibe notificación (pedido listo)
8. Mesero sirve
9. Cliente solicita cuenta
10. Mesero genera factura
11. Cliente paga (efectivo o tarjeta)
12. Mesero cierra la mesa
```

## 🔍 Glosario

| Término | Definición |
|---------|------------|
| **KDS** | Kitchen Display System - Pantalla de cocina |
| **POS** | Point of Sale - Punto de venta |
| **Bump** | Acción de marcar un pedido como completado en el KDS |
| **Dine-in** | Comer en el local |
| **Takeout** | Para llevar |
| **Delivery** | Entrega a domicilio |
| **CAE** | Código de Autorización Electrónica (Argentina) |
| **CUIT** | Clave Única de Identificación Tributaria (Argentina) |
| **JWT** | JSON Web Token - Para autenticación |
| **WebSocket** | Protocolo de comunicación bidireccional en tiempo real |

## 📞 Soporte

### Documentación Adicional

- **Swagger/OpenAPI**: `http://localhost:4000/docs` (API interactiva)
- **Postman Collection**: [Descargar colección](./apis/postman-collection.json)

### Canales de Ayuda

- 📧 Email: support@turestaurante.com
- 💬 Slack: [Unirse al workspace](#)
- 🐛 Issues: [GitHub Issues](#)
- 📖 Wiki: [Ver Wiki](#)

### Contribuir a la Documentación

¿Encontraste un error o quieres mejorar la documentación?

1. Fork del repositorio
2. Crea una rama: `git checkout -b docs/mejora-descripcion`
3. Haz cambios en `/docs`
4. Commit: `git commit -m "docs: mejorar descripción de X"`
5. Push: `git push origin docs/mejora-descripcion`
6. Crea Pull Request

## 📝 Changelog de Documentación

### v1.0.0 (2024-10-21)
- ✅ Documentación inicial completa
- ✅ Arquitectura del sistema
- ✅ Stack tecnológico
- ✅ Diagramas de base de datos
- ✅ Documentación de APIs
- ✅ Módulos principales (Pedidos, KDS)
- ✅ Guías de instalación y configuración

### Próximas Versiones
- ⏳ Documentación de todos los módulos
- ⏳ Guía de desarrollo
- ⏳ Guía de despliegue
- ⏳ Videos tutoriales
- ⏳ FAQ

---

**Última actualización**: Octubre 21, 2024
**Versión**: 1.0.0
