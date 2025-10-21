# 🗄️ Diagrama Entidad-Relación (ER)

## 📋 Índice

- [Diagrama General](#diagrama-general)
- [Entidades Principales](#entidades-principales)
- [Relaciones](#relaciones)
- [Índices y Optimizaciones](#índices-y-optimizaciones)

## 🔷 Diagrama General

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          MÓDULO DE USUARIOS Y AUTH                           │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│    users     │────────>│    roles     │<────────│  permissions │
│              │   M:M   │              │   M:M   │              │
│ - id (PK)    │         │ - id (PK)    │         │ - id (PK)    │
│ - email      │         │ - name       │         │ - name       │
│ - password   │         │ - desc       │         │ - resource   │
│ - full_name  │         └──────────────┘         │ - action     │
│ - phone      │                                   └──────────────┘
│ - role_id(FK)│
│ - status     │         ┌──────────────────┐
│ - created_at │────────>│  user_addresses  │
└──────────────┘    1:N  │                  │
                         │ - id (PK)        │
                         │ - user_id (FK)   │
                         │ - street         │
                         │ - city           │
                         │ - lat/lng        │
                         └──────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                          MÓDULO DE PRODUCTOS Y MENÚ                          │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│ categories   │<────────│  products    │────────>│recipe_items  │
│              │   1:N   │              │   1:N   │              │
│ - id (PK)    │         │ - id (PK)    │         │ - id (PK)    │
│ - name       │         │ - name       │         │ - product_id │
│ - desc       │         │ - desc       │         │ - ingredient │
│ - parent_id  │         │ - price      │         │ - quantity   │
│ - image_url  │         │ - category_id│         │ - unit       │
│ - active     │         │ - image_url  │         └──────────────┘
└──────────────┘         │ - prep_time  │                ↓
                         │ - available  │                ↓
                         │ - stock_qty  │         ┌──────────────┐
                         └──────────────┘         │ ingredients  │
                                 ↓                │              │
                                 ↓                │ - id (PK)    │
                         ┌──────────────┐         │ - name       │
                         │product_addons│         │ - stock_qty  │
                         │              │         │ - unit       │
                         │ - id (PK)    │         │ - min_stock  │
                         │ - product_id │         │ - cost       │
                         │ - name       │         └──────────────┘
                         │ - price      │
                         └──────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           MÓDULO DE PEDIDOS                                  │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   orders     │────────>│ order_items  │────────>│  products    │
│              │   1:N   │              │   N:1   │              │
│ - id (PK)    │         │ - id (PK)    │         │ (ver arriba) │
│ - order_num  │         │ - order_id   │         └──────────────┘
│ - customer_id│         │ - product_id │
│ - table_id   │         │ - quantity   │
│ - status     │         │ - unit_price │         ┌──────────────┐
│ - type       │         │ - subtotal   │────────>│order_item_   │
│ - subtotal   │         │ - notes      │   1:N   │   addons     │
│ - tax        │         └──────────────┘         │              │
│ - total      │                                  │ - id (PK)    │
│ - notes      │         ┌──────────────┐         │ - item_id    │
│ - created_at │────────>│order_timeline│         │ - addon_id   │
│ - updated_at │   1:N   │              │         │ - price      │
└──────────────┘         │ - id (PK)    │         └──────────────┘
       ↓                 │ - order_id   │
       ↓                 │ - status     │
┌──────────────┐         │ - timestamp  │
│   tables     │         │ - user_id    │
│              │         └──────────────┘
│ - id (PK)    │
│ - table_num  │
│ - seats      │
│ - zone       │
│ - status     │
└──────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         MÓDULO DE FACTURACIÓN                                │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐
│   invoices   │────────>│invoice_items │
│              │   1:N   │              │
│ - id (PK)    │         │ - id (PK)    │
│ - invoice_num│         │ - invoice_id │
│ - order_id   │         │ - desc       │
│ - customer_id│         │ - quantity   │
│ - subtotal   │         │ - unit_price │
│ - tax_amount │         │ - total      │
│ - discount   │         └──────────────┘
│ - total      │
│ - status     │         ┌──────────────┐
│ - issued_at  │────────>│tax_details   │
│ - paid_at    │   1:N   │              │
│ - void_reason│         │ - id (PK)    │
└──────────────┘         │ - invoice_id │
       ↓                 │ - tax_name   │
       ↓                 │ - tax_rate   │
┌──────────────┐         │ - tax_amount │
│credit_notes  │         └──────────────┘
│              │
│ - id (PK)    │
│ - invoice_id │
│ - reason     │
│ - amount     │
│ - created_at │
└──────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           MÓDULO DE PAGOS                                    │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│   payments   │────────>│payment_methods   │────────>│   refunds    │
│              │   N:1   │                  │   1:N   │              │
│ - id (PK)    │         │ - id (PK)        │         │ - id (PK)    │
│ - order_id   │         │ - name           │         │ - payment_id │
│ - invoice_id │         │ - type           │         │ - amount     │
│ - amount     │         │ - provider       │         │ - reason     │
│ - method_id  │         │ - config         │         │ - status     │
│ - status     │         └──────────────────┘         │ - created_at │
│ - gateway_id │                                      └──────────────┘
│ - gateway    │         ┌──────────────────┐
│ - metadata   │────────>│payment_splits    │
│ - created_at │   1:N   │                  │
└──────────────┘         │ - id (PK)        │
                         │ - payment_id     │
                         │ - method_id      │
                         │ - amount         │
                         └──────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                          MÓDULO DE DELIVERY                                  │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────────┐
│ deliveries   │────────>│   drivers    │────────>│driver_locations  │
│              │   N:1   │              │   1:N   │                  │
│ - id (PK)    │         │ - id (PK)    │         │ - id (PK)        │
│ - order_id   │         │ - user_id    │         │ - driver_id      │
│ - driver_id  │         │ - vehicle_id │         │ - lat            │
│ - zone_id    │         │ - status     │         │ - lng            │
│ - status     │         │ - rating     │         │ - timestamp      │
│ - pickup_time│         └──────────────┘         └──────────────────┘
│ - delivered  │                ↓
│ - distance   │                ↓
│ - fee        │         ┌──────────────┐
│ - created_at │         │   vehicles   │
└──────────────┘         │              │
       ↓                 │ - id (PK)    │
       ↓                 │ - plate      │
┌──────────────┐         │ - type       │
│delivery_zones│         │ - model      │
│              │         └──────────────┘
│ - id (PK)    │
│ - name       │         ┌──────────────────┐
│ - polygon    │────────>│delivery_timeline │
│ - base_fee   │   1:N   │                  │
│ - per_km_fee │         │ - id (PK)        │
│ - active     │         │ - delivery_id    │
└──────────────┘         │ - status         │
                         │ - lat/lng        │
                         │ - timestamp      │
                         └──────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                       MÓDULO DE NOTIFICACIONES                               │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐         ┌──────────────────────┐
│  notifications   │────────>│notification_templates│
│                  │   N:1   │                      │
│ - id (PK)        │         │ - id (PK)            │
│ - user_id        │         │ - name               │
│ - template_id    │         │ - channel            │
│ - channel        │         │ - subject            │
│ - recipient      │         │ - body_template      │
│ - subject        │         │ - variables          │
│ - body           │         └──────────────────────┘
│ - status         │
│ - sent_at        │         ┌──────────────────────┐
│ - error          │────────>│notification_prefs    │
│ - created_at     │   N:1   │                      │
└──────────────────┘         │ - id (PK)            │
                             │ - user_id            │
                             │ - channel            │
                             │ - enabled            │
                             └──────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                        MÓDULO DE INVENTARIO                                  │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│ ingredients  │────────>│inventory_movement│────────>│  suppliers   │
│              │   1:N   │                  │   N:1   │              │
│ (ver arriba) │         │ - id (PK)        │         │ - id (PK)    │
│              │         │ - ingredient_id  │         │ - name       │
│              │         │ - type           │         │ - contact    │
│              │         │ - quantity       │         │ - email      │
│              │         │ - unit_cost      │         │ - phone      │
│              │         │ - supplier_id    │         │ - rating     │
│              │         │ - reference      │         └──────────────┘
│              │         │ - notes          │
│              │         │ - created_at     │
│              │         └──────────────────┘
│              │
│              │         ┌──────────────────┐
│              │────────>│purchase_orders   │
│              │   N:1   │                  │
│              │         │ - id (PK)        │
│              │         │ - supplier_id    │
│              │         │ - status         │
│              │         │ - total          │
│              │         │ - expected_date  │
│              │         │ - received_date  │
│              │         └──────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         MÓDULO DE LEALTAD                                    │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐         ┌──────────────────┐         ┌──────────────┐
│loyalty_accounts  │────────>│loyalty_trans     │────────>│loyalty_tiers │
│                  │   1:N   │                  │   N:1   │              │
│ - id (PK)        │         │ - id (PK)        │         │ - id (PK)    │
│ - user_id        │         │ - account_id     │         │ - name       │
│ - tier_id        │         │ - type           │         │ - min_points │
│ - points         │         │ - points         │         │ - multiplier │
│ - lifetime_pts   │         │ - order_id       │         │ - benefits   │
└──────────────────┘         │ - description    │         └──────────────┘
       ↓                     │ - created_at     │
       ↓                     └──────────────────┘
┌──────────────────┐
│loyalty_rewards   │         ┌──────────────────┐
│                  │────────>│reward_redemptions│
│ - id (PK)        │   1:N   │                  │
│ - name           │         │ - id (PK)        │
│ - points_cost    │         │ - reward_id      │
│ - type           │         │ - account_id     │
│ - value          │         │ - order_id       │
│ - valid_from     │         │ - redeemed_at    │
│ - valid_until    │         └──────────────────┘
└──────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                       MÓDULO DE RESERVACIONES                                │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐         ┌──────────────┐
│  reservations    │────────>│   tables     │
│                  │   N:1   │              │
│ - id (PK)        │         │ (ver arriba) │
│ - customer_id    │         └──────────────┘
│ - table_id       │
│ - party_size     │         ┌──────────────────┐
│ - date           │────────>│reservation_slots │
│ - time_slot      │   N:1   │                  │
│ - status         │         │ - id (PK)        │
│ - notes          │         │ - day_of_week    │
│ - reminded       │         │ - time_start     │
│ - created_at     │         │ - time_end       │
└──────────────────┘         │ - max_capacity   │
                             └──────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         MÓDULO DE PERSONAL                                   │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────────┐
│  employees   │────────>│   shifts     │────────>│shift_assignments │
│              │   1:N   │              │   1:N   │                  │
│ - id (PK)    │         │ - id (PK)    │         │ - id (PK)        │
│ - user_id    │         │ - name       │         │ - shift_id       │
│ - position   │         │ - start_time │         │ - employee_id    │
│ - hire_date  │         │ - end_time   │         │ - date           │
│ - salary     │         │ - day_of_week│         │ - checked_in     │
│ - status     │         └──────────────┘         │ - checked_out    │
└──────────────┘                                  │ - hours_worked   │
       ↓                                          └──────────────────┘
       ↓
┌──────────────┐         ┌──────────────────┐
│commissions   │         │employee_reviews  │
│              │         │                  │
│ - id (PK)    │         │ - id (PK)        │
│ - employee_id│         │ - employee_id    │
│ - order_id   │         │ - reviewer_id    │
│ - amount     │         │ - rating         │
│ - period     │         │ - comments       │
│ - paid       │         │ - review_date    │
└──────────────┘         └──────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         MÓDULO DE ANALYTICS                                  │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐         ┌──────────────────┐
│  sales_reports   │         │ product_metrics  │
│                  │         │                  │
│ - id (PK)        │         │ - id (PK)        │
│ - date           │         │ - product_id     │
│ - total_sales    │         │ - date           │
│ - order_count    │         │ - units_sold     │
│ - avg_ticket     │         │ - revenue        │
│ - period_type    │         │ - cost           │
└──────────────────┘         │ - profit         │
                             └──────────────────┘

```

## 🔗 Relaciones Clave

### 1. Users → Orders (1:N)
Un usuario puede tener múltiples pedidos

### 2. Orders → Order_Items (1:N)
Un pedido contiene múltiples ítems

### 3. Products → Order_Items (1:N)
Un producto puede estar en múltiples pedidos

### 4. Orders → Invoices (1:1)
Cada pedido genera una factura

### 5. Orders → Deliveries (1:1)
Cada pedido de delivery tiene un registro de entrega

### 6. Deliveries → Drivers (N:1)
Un repartidor puede tener múltiples entregas

### 7. Products → Recipe_Items → Ingredients (N:M)
Relación muchos a muchos entre productos e ingredientes a través de recetas

### 8. Users → Loyalty_Accounts (1:1)
Cada usuario tiene una cuenta de lealtad

## 📊 Índices y Optimizaciones

### Índices Críticos

```sql
-- Orders
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);

-- Order Items
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Deliveries
CREATE INDEX idx_deliveries_driver_id ON deliveries(driver_id);
CREATE INDEX idx_deliveries_status ON deliveries(status);

-- Payments
CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_payments_status ON payments(status);

-- Notifications
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_status ON notifications(status);
```

### Índices Compuestos

```sql
-- Para búsquedas frecuentes
CREATE INDEX idx_orders_customer_status ON orders(customer_id, status);
CREATE INDEX idx_deliveries_driver_status ON deliveries(driver_id, status);
```

### Índices de Texto Completo

```sql
-- Para búsqueda de productos
CREATE INDEX idx_products_search ON products USING gin(to_tsvector('spanish', name || ' ' || description));
```

---

Ver [Esquemas Detallados](./ESQUEMAS.md) para definiciones SQL completas.
