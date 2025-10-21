# 📺 Kitchen Display System (KDS)

## 📋 Descripción General

El Kitchen Display System es una aplicación web que se muestra en pantallas táctiles en la cocina, reemplazando los tickets de papel tradicionales. Muestra los pedidos en tiempo real y permite al personal de cocina gestionar la preparación de manera eficiente.

## 🎯 Objetivos del KDS

1. **Eliminar papel** - Sistema 100% digital
2. **Tiempo real** - Actualización instantánea vía WebSockets
3. **Priorización inteligente** - Ordenar pedidos por urgencia
4. **Multi-estación** - Diferentes displays para diferentes áreas de cocina
5. **Trazabilidad** - Registro completo de tiempos de preparación

## 🖥️ Características Principales

### 1. Vista de Pedidos en Tiempo Real

```
┌─────────────────────────────────────────────────────────────┐
│  KITCHEN DISPLAY SYSTEM          🔔 3 nuevos    🕐 14:35   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │
│  │ #ORD-0012   │  │ #ORD-0013   │  │ #ORD-0014   │       │
│  │ Mesa 5      │  │ Delivery    │  │ Llevar      │       │
│  │ 00:05:23    │  │ 00:03:45    │  │ 00:01:12    │       │
│  ├─────────────┤  ├─────────────┤  ├─────────────┤       │
│  │ • Pizza x2  │  │ • Burger x1 │  │ • Pasta x1  │       │
│  │   - Sin     │  │ • Fries x1  │  │ • Salad x1  │       │
│  │     cebolla │  │ URGENTE ⚠️  │  │             │       │
│  │ • Pasta x1  │  │             │  │             │       │
│  │             │  │             │  │             │       │
│  │   [BUMP]    │  │   [BUMP]    │  │   [BUMP]    │       │
│  └─────────────┘  └─────────────┘  └─────────────┘       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2. Códigos de Color por Prioridad

| Color | Tiempo | Significado |
|-------|--------|-------------|
| 🟢 Verde | 0-10 min | Normal |
| 🟡 Amarillo | 10-15 min | Atención |
| 🟠 Naranja | 15-20 min | Urgente |
| 🔴 Rojo | +20 min | Muy urgente |

### 3. Ruteo de Ítems por Estación

Los ítems se rutean automáticamente a diferentes estaciones:

```typescript
const STATION_ROUTING = {
  parrilla: ['burger', 'steak', 'chicken'],
  freidora: ['fries', 'nuggets', 'wings'],
  horno: ['pizza', 'lasagna'],
  frio: ['salads', 'desserts'],
  bebidas: ['drinks', 'smoothies']
};
```

**Ejemplo:**
- Pedido con Pizza + Burger + Fries
  - KDS Horno: muestra solo la Pizza
  - KDS Parrilla: muestra solo el Burger
  - KDS Freidora: muestra solo las Fries

### 4. Información Detallada de Cada Pedido

```typescript
interface KDSOrderItem {
  // Identificación
  orderNumber: string;
  orderType: 'dine_in' | 'takeout' | 'delivery';
  tableNumber?: string;

  // Timing
  createdAt: Date;
  elapsedTime: string; // "00:15:23"
  estimatedTime: number; // minutos

  // Items
  items: {
    productName: string;
    quantity: number;
    notes?: string; // "Sin cebolla", "Bien cocido"
    addons?: string[];
    allergens?: string[]; // Destacado
  }[];

  // Estado
  status: 'pending' | 'preparing' | 'ready';
  priority: 'normal' | 'urgent' | 'very_urgent';

  // Metadatos
  customerName?: string;
  deliveryETA?: string;
}
```

### 5. Funcionalidad "Bump"

**Bump** = Marcar un pedido como completado

```typescript
function handleBump(orderId: string) {
  // 1. Verificar que todos los ítems estén ready
  const allItemsReady = checkAllItemsReady(orderId);

  if (!allItemsReady) {
    showAlert('Algunos ítems aún no están listos');
    return;
  }

  // 2. Actualizar estado del pedido
  updateOrderStatus(orderId, 'ready');

  // 3. Quitar de pantalla con animación
  animateRemove(orderId);

  // 4. Emitir evento
  socket.emit('order:bumped', { orderId });

  // 5. Notificar (mesero o cliente)
  sendNotification(orderId, 'order_ready');

  // 6. Reproducir sonido de confirmación
  playSound('bump_success');
}
```

### 6. Alertas y Notificaciones

#### Alertas Visuales
- 🔔 **Badge de nuevos pedidos** en la esquina
- ⚠️ **Destacar alérgenos** (rojo brillante)
- 🔥 **Pedidos urgentes** parpadeantes
- ⏰ **Timer visual** con cambio de color progresivo

#### Alertas Sonoras
- 🎵 Sonido al recibir nuevo pedido
- ⚠️ Sonido diferente para pedidos urgentes
- ✅ Sonido de confirmación al hacer bump

### 7. Gestión de Ítems Individuales

Cada ítem puede tener estado independiente:

```
Pedido #ORD-0012
├─ Pizza Margarita x2 [PREPARING] ⏳
├─ Pasta Alfredo x1 [READY] ✅
└─ Ensalada x1 [PENDING] ⏸️
```

Acciones:
- **Mark as Preparing**: Iniciar preparación de ítem
- **Mark as Ready**: Marcar ítem como listo
- **Hold**: Pausar ítem (esperar otros ítems del pedido)

### 8. Vista de Multi-Estación

Configuración por pantalla:

```typescript
// KDS Principal (todas las órdenes)
{
  station: 'all',
  showAllItems: true
}

// KDS Parrilla
{
  station: 'grill',
  filterItems: ['burger', 'steak', 'chicken']
}

// KDS Horno
{
  station: 'oven',
  filterItems: ['pizza', 'lasagna']
}
```

## 🔧 Funcionalidades Técnicas

### WebSocket Connection

```typescript
// Frontend KDS
const socket = io(API_URL, {
  auth: { token: authToken }
});

// Escuchar nuevos pedidos
socket.on('order:created', (order) => {
  addOrderToQueue(order);
  playNewOrderSound();
  showNotificationBadge();
});

// Escuchar actualizaciones
socket.on('order:updated', (order) => {
  updateOrderInQueue(order);
});

// Escuchar cancelaciones
socket.on('order:cancelled', (orderId) => {
  removeOrderFromQueue(orderId);
  playWarningSound();
});

// Reconexión automática
socket.on('disconnect', () => {
  showOfflineIndicator();
  attemptReconnect();
});
```

### Auto-refresh y Sincronización

```typescript
// Sincronización cada 30 segundos (backup)
useEffect(() => {
  const interval = setInterval(() => {
    fetchActiveOrders();
  }, 30000);

  return () => clearInterval(interval);
}, []);

// Actualización de timers cada segundo
useEffect(() => {
  const interval = setInterval(() => {
    updateAllTimers();
  }, 1000);

  return () => clearInterval(interval);
}, []);
```

### Ordenamiento Inteligente

```typescript
function sortOrders(orders: Order[]): Order[] {
  return orders.sort((a, b) => {
    // 1. Primero por prioridad
    const priorityScore = {
      very_urgent: 3,
      urgent: 2,
      normal: 1
    };
    if (priorityScore[a.priority] !== priorityScore[b.priority]) {
      return priorityScore[b.priority] - priorityScore[a.priority];
    }

    // 2. Luego por tipo (delivery primero)
    const typeScore = {
      delivery: 3,
      takeout: 2,
      dine_in: 1
    };
    if (typeScore[a.type] !== typeScore[b.type]) {
      return typeScore[b.type] - typeScore[a.type];
    }

    // 3. Finalmente por tiempo de creación (más viejo primero)
    return a.createdAt.getTime() - b.createdAt.getTime();
  });
}
```

### Cálculo de Prioridad

```typescript
function calculatePriority(order: Order): Priority {
  const elapsedMinutes = getElapsedMinutes(order.createdAt);

  // Ajuste por tipo de pedido
  let threshold = {
    normal: 10,
    urgent: 15,
    very_urgent: 20
  };

  if (order.type === 'delivery') {
    // Delivery tiene thresholds más estrictos
    threshold = {
      normal: 8,
      urgent: 12,
      very_urgent: 15
    };
  }

  if (elapsedMinutes >= threshold.very_urgent) return 'very_urgent';
  if (elapsedMinutes >= threshold.urgent) return 'urgent';
  return 'normal';
}
```

## 📊 Métricas del KDS

### KPIs Rastreados
- **Average Prep Time**: Tiempo promedio de preparación
- **Order Throughput**: Pedidos completados por hora
- **Station Efficiency**: Eficiencia por estación
- **Peak Hours**: Identificación de horas pico
- **Bottlenecks**: Estaciones con más retrasos

### Dashboard de Métricas (Admin)

```typescript
interface KDSMetrics {
  today: {
    totalOrders: number;
    avgPrepTime: number; // minutos
    ordersOnTime: number; // dentro del tiempo estimado
    ordersDelayed: number;
    peakHour: string;
  };
  byStation: {
    stationName: string;
    ordersProcessed: number;
    avgTime: number;
    efficiency: number; // %
  }[];
  currentQueue: {
    pending: number;
    preparing: number;
    ready: number;
  };
}
```

## 🎨 UI/UX Consideraciones

### Diseño Responsivo

```
┌─────────────────────────────────┐
│  Tablet (iPad) - Vista 2x2      │
│  ┌──────┐ ┌──────┐             │
│  │ Ord1 │ │ Ord2 │             │
│  └──────┘ └──────┘             │
│  ┌──────┐ ┌──────┐             │
│  │ Ord3 │ │ Ord4 │             │
│  └──────┘ └──────┘             │
└─────────────────────────────────┘

┌──────────────────────────────────────────┐
│  TV/Monitor Grande - Vista 3x3           │
│  ┌──────┐ ┌──────┐ ┌──────┐            │
│  │ Ord1 │ │ Ord2 │ │ Ord3 │            │
│  └──────┘ └──────┘ └──────┘            │
│  ┌──────┐ ┌──────┐ ┌──────┐            │
│  │ Ord4 │ │ Ord5 │ │ Ord6 │            │
│  └──────┘ └──────┘ └──────┘            │
│  ┌──────┐ ┌──────┐ ┌──────┐            │
│  │ Ord7 │ │ Ord8 │ │ Ord9 │            │
│  └──────┘ └──────┘ └──────┘            │
└──────────────────────────────────────────┘
```

### Accesibilidad
- **Alto contraste** para ambientes con luz variable
- **Texto grande** legible a distancia
- **Touch targets grandes** (mínimo 48x48px)
- **Retroalimentación táctil** (vibración en tablets)
- **Soporte de teclado** para navegación rápida

### Modo Oscuro
```css
/* Modo oscuro para cocina (reduce fatiga visual) */
.kds-dark-mode {
  background: #1a1a1a;
  color: #ffffff;
}

.order-card-dark {
  background: #2d2d2d;
  border: 2px solid #404040;
}

.order-card-urgent-dark {
  border-color: #ff6b6b;
  box-shadow: 0 0 20px rgba(255, 107, 107, 0.5);
}
```

## 🔐 Seguridad

### Autenticación
- Login con credenciales de cocina (no acceso de clientes)
- Token de sesión renovable
- Auto-logout después de inactividad (opcional)

### Permisos
- **Chef/Cocinero**: Ver y gestionar pedidos
- **Supervisor**: Ver métricas, reordenar cola
- **Admin**: Configuración de estaciones

## 🚀 Optimizaciones

### Performance
```typescript
// Virtualización de lista (solo renderizar visible)
import { FixedSizeGrid } from 'react-window';

// Memoización de componentes
const OrderCard = React.memo(({ order }) => {
  // ...
});

// Debounce de actualizaciones
const debouncedUpdate = useMemo(
  () => debounce(updateOrder, 300),
  []
);
```

### Offline Support
```typescript
// Service Worker para caché
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js');
}

// Mostrar pedidos cacheados si no hay conexión
const orders = isOnline
  ? await fetchOrders()
  : await getCachedOrders();
```

## 📝 Configuración

### Configuración por Restaurante

```typescript
interface KDSConfig {
  // Visual
  theme: 'light' | 'dark';
  gridColumns: 2 | 3 | 4;
  showCustomerNames: boolean;
  showEstimatedTime: boolean;

  // Timing
  normalThreshold: number; // minutos
  urgentThreshold: number;
  veryUrgentThreshold: number;

  // Audio
  enableSounds: boolean;
  newOrderSound: string;
  urgentSound: string;
  bumpSound: string;
  volume: number; // 0-100

  // Estaciones
  station: 'all' | 'grill' | 'oven' | 'fryer' | 'cold' | 'drinks';
  filterByStation: boolean;

  // Auto-bump
  autoBump: boolean; // Auto-remover después de X minutos en "ready"
  autoBumpDelay: number;
}
```

## 🧪 Testing

### Test de Latencia
```typescript
// Medir delay entre nuevo pedido y aparición en KDS
describe('WebSocket Latency', () => {
  it('should display new order within 1 second', async () => {
    const start = Date.now();

    await createOrder(mockOrder);

    await waitFor(() => {
      expect(screen.getByText(mockOrder.orderNumber)).toBeInTheDocument();
    });

    const latency = Date.now() - start;
    expect(latency).toBeLessThan(1000); // < 1 segundo
  });
});
```

---

**Ver también:**
- [Pedidos](./PEDIDOS.md)
- [Notificaciones](./NOTIFICACIONES.md)
- [WebSockets](../apis/WEBSOCKETS.md)
