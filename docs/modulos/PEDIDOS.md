# 🛒 Módulo de Gestión de Pedidos

## 📋 Descripción General

El módulo de pedidos es el núcleo del sistema. Gestiona todo el ciclo de vida de un pedido desde su creación hasta su completación o cancelación.

## 🎯 Características Principales

### 1. Tipos de Pedidos
- **Dine-in** (Comer en el local)
  - Asignación a mesa
  - División de cuenta
  - Múltiples meseros

- **Takeout** (Para llevar)
  - Tiempo estimado de preparación
  - Notificación cuando está listo

- **Delivery** (Entrega a domicilio)
  - Cálculo de zona de entrega
  - Asignación de repartidor
  - Tracking en tiempo real

### 2. Estados del Pedido

```
┌─────────┐     ┌───────────┐     ┌───────────┐     ┌──────┐     ┌───────────┐
│ Pending │────>│ Confirmed │────>│ Preparing │────>│ Ready│────>│ Completed │
└─────────┘     └───────────┘     └───────────┘     └──────┘     └───────────┘
     │                                                                    ▲
     │                                                                    │
     │          ┌───────────┐                                            │
     └─────────>│ Cancelled │                                            │
                └───────────┘                                            │
                                                                         │
                ┌────────────┐                                           │
                │ Delivering │──────────────────────────────────────────┘
                └────────────┘
```

**Flujo de Estados:**

1. **Pending**: Pedido creado, esperando confirmación
2. **Confirmed**: Pedido confirmado, en cola para preparación
3. **Preparing**: En proceso de preparación en cocina
4. **Ready**: Listo para servir/entregar
5. **Delivering**: En camino (solo para delivery)
6. **Completed**: Pedido completado
7. **Cancelled**: Pedido cancelado

### 3. Gestión de Ítems

Cada pedido contiene múltiples ítems con:
- Producto base
- Cantidad
- Addons/extras
- Modificaciones/notas especiales
- Precio unitario (snapshot del precio al momento del pedido)
- Estado individual (cada ítem puede tener estado diferente)

### 4. Modificaciones de Pedidos

**Antes de confirmar:**
- Agregar/quitar ítems
- Modificar cantidades
- Cambiar addons
- Actualizar notas

**Después de confirmar:**
- Agregar nuevos ítems (se envían a cocina como "pedido adicional")
- Cancelar ítems específicos (con autorización)
- No se pueden modificar ítems ya en preparación

### 5. Cálculos Automáticos

```typescript
// Ejemplo de cálculo
subtotal = sum(items.subtotal)
tax = subtotal * taxRate
deliveryFee = calculateDeliveryFee(zone, distance)
discount = applyDiscounts(subtotal, loyaltyPoints, coupons)
total = subtotal + tax + deliveryFee - discount
```

### 6. Pedidos Programados

Permite a clientes programar pedidos para fecha/hora futura:
- Eventos/catering
- Desayunos/almuerzos corporativos
- Fiestas de cumpleaños

## 🔧 Funcionalidades Técnicas

### Eventos Emitidos

```typescript
// Cuando se crea un pedido
emit('order.created', {
  orderId: string,
  customerId: string,
  type: 'dine_in' | 'takeout' | 'delivery',
  items: OrderItem[],
  total: number
})

// Cuando cambia el estado
emit('order.status_changed', {
  orderId: string,
  oldStatus: OrderStatus,
  newStatus: OrderStatus,
  timestamp: Date
})

// Cuando se modifica
emit('order.updated', {
  orderId: string,
  changes: object
})

// Cuando se cancela
emit('order.cancelled', {
  orderId: string,
  reason: string,
  cancelledBy: string
})
```

### Reglas de Negocio

#### 1. Validaciones al Crear
- ✅ Cliente debe existir y estar activo
- ✅ Productos deben estar disponibles
- ✅ Stock suficiente (si se gestiona stock)
- ✅ Dirección de entrega válida (para delivery)
- ✅ Zona de delivery activa (para delivery)
- ✅ Monto mínimo cumplido (para delivery)
- ✅ Horario del restaurante (abierto/cerrado)

#### 2. Validaciones al Modificar
- ✅ Pedido no debe estar completado o cancelado
- ✅ Autorización requerida para ciertas modificaciones
- ✅ Ítems en preparación no pueden eliminarse

#### 3. Cancelación
- ✅ Solo pedidos en estado "pending" o "confirmed" pueden cancelarse libremente
- ✅ Pedidos en "preparing" requieren autorización de supervisor
- ✅ Pedidos "ready" o "delivering" requieren autorización de gerente
- ✅ Si hay pago procesado, se debe iniciar reembolso

### Integración con Otros Módulos

```
┌─────────────┐
│   Pedidos   │
└──────┬──────┘
       │
       ├──────────> Inventario (deducir stock)
       │
       ├──────────> Facturación (generar factura)
       │
       ├──────────> Pagos (registrar pago)
       │
       ├──────────> Delivery (crear entrega)
       │
       ├──────────> Notificaciones (avisar a cliente)
       │
       ├──────────> KDS (mostrar en pantalla de cocina)
       │
       └──────────> Lealtad (acumular puntos)
```

## 📊 Métricas y Analytics

### KPIs del Módulo
- Tiempo promedio de preparación
- Tiempo promedio total (desde pedido hasta entrega)
- Tasa de cancelación
- Ticket promedio
- Items más pedidos
- Horarios pico
- Tasa de modificación de pedidos

### Reportes Disponibles
- Ventas por periodo
- Pedidos por tipo
- Productos más vendidos
- Comparativa de periodos
- Análisis de horas pico

## 🎨 UI/UX Considerations

### Vista de Cliente
- Catálogo de productos
- Carrito de compras
- Tracking en tiempo real
- Historial de pedidos
- Repetir pedido anterior

### Vista de Mesero/Cajero
- Crear pedido rápido
- Asignar a mesa
- Modificar pedido
- División de cuenta
- Aplicar descuentos

### Vista de Admin
- Vista general de todos los pedidos
- Filtros avanzados
- Acciones masivas
- Estadísticas en tiempo real
- Exportar datos

## 🔐 Permisos y Roles

| Acción | Cliente | Mesero | Cajero | Gerente | Admin |
|--------|---------|--------|--------|---------|-------|
| Ver propios pedidos | ✅ | - | - | - | - |
| Crear pedido | ✅ | ✅ | ✅ | ✅ | ✅ |
| Ver todos los pedidos | - | ✅ | ✅ | ✅ | ✅ |
| Modificar pedido pending | ✅ | ✅ | ✅ | ✅ | ✅ |
| Modificar pedido confirmed | - | ✅ | ✅ | ✅ | ✅ |
| Cancelar pedido pending | ✅ | ✅ | ✅ | ✅ | ✅ |
| Cancelar pedido preparing | - | - | - | ✅ | ✅ |
| Aplicar descuentos | - | - | ✅ | ✅ | ✅ |
| Ver analytics | - | - | - | ✅ | ✅ |

## 🧪 Casos de Prueba

### Escenario 1: Crear Pedido Dine-in
```
GIVEN un mesero autenticado
AND una mesa disponible
WHEN crea un pedido con 2 productos válidos
THEN el pedido se crea con estado "pending"
AND se envía notificación a cocina
AND la mesa cambia a estado "occupied"
```

### Escenario 2: Cancelar Pedido con Pago
```
GIVEN un pedido en estado "confirmed"
AND con pago procesado
WHEN se solicita cancelación
THEN se verifica autorización
AND se inicia proceso de reembolso
AND se libera inventario
AND se notifica al cliente
```

### Escenario 3: Pedido con Stock Insuficiente
```
GIVEN un producto con stock_qty = 2
WHEN se intenta crear pedido con quantity = 5
THEN se rechaza el pedido
AND se retorna error "INSUFFICIENT_STOCK"
AND se sugieren productos alternativos
```

## 🚀 Optimizaciones

### Performance
- Cache de productos frecuentes en Redis
- Índices en customer_id, status, created_at
- Paginación con cursor-based (más eficiente que offset)
- Eager loading de relaciones (items, products, addons)

### Escalabilidad
- Queue para procesamiento asíncrono (envío de notificaciones)
- Event sourcing para historial completo
- Sharding por restaurant_id (multi-tenant)

## 📝 Ejemplos de Código

### Crear Pedido (Backend)
```typescript
@Post()
@UseGuards(JwtAuthGuard)
async createOrder(
  @Body() createOrderDto: CreateOrderDto,
  @User() user: UserEntity,
) {
  // 1. Validar datos
  await this.ordersService.validateOrder(createOrderDto);

  // 2. Calcular totales
  const totals = await this.ordersService.calculateTotals(
    createOrderDto.items,
    createOrderDto.deliveryZoneId,
  );

  // 3. Crear pedido
  const order = await this.ordersService.create({
    ...createOrderDto,
    customerId: user.id,
    ...totals,
  });

  // 4. Deducir inventario
  await this.inventoryService.deductStock(order.items);

  // 5. Emitir eventos
  this.eventEmitter.emit('order.created', order);

  // 6. Enviar a queue de notificaciones
  await this.notificationsQueue.add('send-order-confirmation', {
    orderId: order.id,
  });

  return order;
}
```

### Actualizar Estado (Backend)
```typescript
@Patch(':id/status')
@UseGuards(JwtAuthGuard)
async updateStatus(
  @Param('id') id: string,
  @Body() updateStatusDto: UpdateOrderStatusDto,
) {
  const order = await this.ordersService.findOne(id);

  // Validar transición de estado
  this.ordersService.validateStatusTransition(
    order.status,
    updateStatusDto.status,
  );

  // Actualizar
  const updated = await this.ordersService.updateStatus(
    id,
    updateStatusDto.status,
  );

  // Registrar en timeline
  await this.orderTimelineService.create({
    orderId: id,
    status: updateStatusDto.status,
    notes: updateStatusDto.notes,
  });

  // Emitir evento WebSocket
  this.websocketGateway.emit('order:updated', updated);

  // Lógica específica por estado
  if (updateStatusDto.status === 'ready') {
    await this.notificationsQueue.add('send-order-ready', {
      orderId: id,
    });
  }

  return updated;
}
```

---

**Ver también:**
- [KDS (Kitchen Display System)](./KDS.md)
- [Facturación](./FACTURACION.md)
- [Delivery](./DELIVERY.md)
