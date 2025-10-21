# 📝 Esquemas de Base de Datos

## 📋 Índice

- [Módulo de Usuarios](#módulo-de-usuarios)
- [Módulo de Productos](#módulo-de-productos)
- [Módulo de Pedidos](#módulo-de-pedidos)
- [Módulo de Facturación](#módulo-de-facturación)
- [Módulo de Pagos](#módulo-de-pagos)
- [Módulo de Delivery](#módulo-de-delivery)
- [Módulo de Notificaciones](#módulo-de-notificaciones)
- [Módulo de Inventario](#módulo-de-inventario)
- [Módulo de Lealtad](#módulo-de-lealtad)
- [Módulo de Reservaciones](#módulo-de-reservaciones)
- [Módulo de Personal](#módulo-de-personal)

## 👥 Módulo de Usuarios

### users
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    avatar_url VARCHAR(500),
    role_id UUID REFERENCES roles(id),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role_id ON users(role_id);
CREATE INDEX idx_users_status ON users(status);
```

### roles
```sql
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed data
INSERT INTO roles (name, description) VALUES
('admin', 'Administrador con acceso completo'),
('manager', 'Gerente del restaurante'),
('cashier', 'Cajero/Punto de venta'),
('waiter', 'Mesero'),
('kitchen', 'Personal de cocina'),
('driver', 'Repartidor'),
('customer', 'Cliente');
```

### permissions
```sql
CREATE TABLE permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    resource VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL CHECK (action IN ('create', 'read', 'update', 'delete')),
    description TEXT
);
```

### role_permissions
```sql
CREATE TABLE role_permissions (
    role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
    permission_id UUID REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);
```

### user_addresses
```sql
CREATE TABLE user_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    label VARCHAR(50), -- 'home', 'work', etc.
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100) DEFAULT 'Argentina',
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_addresses_user_id ON user_addresses(user_id);
```

### refresh_tokens
```sql
CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(500) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);
```

## 🍔 Módulo de Productos

### categories
```sql
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_id UUID REFERENCES categories(id),
    image_url VARCHAR(500),
    sort_order INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_categories_parent_id ON categories(parent_id);
CREATE INDEX idx_categories_active ON categories(active);
```

### products
```sql
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    category_id UUID REFERENCES categories(id),
    image_url VARCHAR(500),
    images JSONB, -- Array de URLs de imágenes adicionales
    prep_time INTEGER, -- Tiempo de preparación en minutos
    calories INTEGER,
    allergens TEXT[], -- Array de alérgenos
    is_vegetarian BOOLEAN DEFAULT FALSE,
    is_vegan BOOLEAN DEFAULT FALSE,
    is_gluten_free BOOLEAN DEFAULT FALSE,
    available BOOLEAN DEFAULT TRUE,
    featured BOOLEAN DEFAULT FALSE,
    stock_managed BOOLEAN DEFAULT FALSE, -- Si se gestiona stock para este producto
    stock_qty INTEGER DEFAULT 0,
    sku VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP -- Soft delete
);

CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_available ON products(available);
CREATE INDEX idx_products_featured ON products(featured);
CREATE INDEX idx_products_sku ON products(sku);
```

### product_addons
```sql
CREATE TABLE product_addons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL DEFAULT 0,
    available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_product_addons_product_id ON product_addons(product_id);
```

### ingredients
```sql
CREATE TABLE ingredients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    unit VARCHAR(20) NOT NULL, -- 'kg', 'g', 'l', 'ml', 'unidades'
    stock_qty DECIMAL(10, 3) DEFAULT 0,
    min_stock DECIMAL(10, 3) DEFAULT 0, -- Stock mínimo antes de alertar
    cost_per_unit DECIMAL(10, 2),
    supplier_id UUID REFERENCES suppliers(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ingredients_stock_qty ON ingredients(stock_qty);
```

### recipe_items
```sql
CREATE TABLE recipe_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    ingredient_id UUID REFERENCES ingredients(id),
    quantity DECIMAL(10, 3) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_recipe_items_product_id ON recipe_items(product_id);
CREATE INDEX idx_recipe_items_ingredient_id ON recipe_items(ingredient_id);
```

## 🛒 Módulo de Pedidos

### orders
```sql
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(50) UNIQUE NOT NULL, -- Ejemplo: ORD-2024-00001
    customer_id UUID REFERENCES users(id),
    table_id UUID REFERENCES tables(id),
    type VARCHAR(20) NOT NULL CHECK (type IN ('dine_in', 'takeout', 'delivery')),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'confirmed', 'preparing', 'ready', 'delivering', 'completed', 'cancelled')),
    subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0,
    tax DECIMAL(10, 2) NOT NULL DEFAULT 0,
    delivery_fee DECIMAL(10, 2) DEFAULT 0,
    discount DECIMAL(10, 2) DEFAULT 0,
    total DECIMAL(10, 2) NOT NULL DEFAULT 0,
    notes TEXT,
    customer_notes TEXT,
    scheduled_for TIMESTAMP, -- Para pedidos programados
    created_by UUID REFERENCES users(id), -- Quien creó el pedido (mesero/admin)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    cancelled_at TIMESTAMP,
    cancellation_reason TEXT
);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_type ON orders(type);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX idx_orders_order_number ON orders(order_number);
```

### order_items
```sql
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    notes TEXT, -- Instrucciones especiales (sin sal, bien cocido, etc.)
    status VARCHAR(20) DEFAULT 'pending'
        CHECK (status IN ('pending', 'preparing', 'ready', 'served')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_order_items_status ON order_items(status);
```

### order_item_addons
```sql
CREATE TABLE order_item_addons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_item_id UUID REFERENCES order_items(id) ON DELETE CASCADE,
    addon_id UUID REFERENCES product_addons(id),
    name VARCHAR(100) NOT NULL, -- Guardamos el nombre por si el addon se borra
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_order_item_addons_order_item_id ON order_item_addons(order_item_id);
```

### order_timeline
```sql
CREATE TABLE order_timeline (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL,
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_order_timeline_order_id ON order_timeline(order_id);
CREATE INDEX idx_order_timeline_created_at ON order_timeline(created_at);
```

### tables
```sql
CREATE TABLE tables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_number VARCHAR(20) UNIQUE NOT NULL,
    seats INTEGER NOT NULL DEFAULT 4,
    zone VARCHAR(50), -- 'terraza', 'interior', 'vip', etc.
    qr_code VARCHAR(500), -- URL del código QR para pedidos desde mesa
    status VARCHAR(20) DEFAULT 'available'
        CHECK (status IN ('available', 'occupied', 'reserved', 'maintenance')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tables_status ON tables(status);
CREATE INDEX idx_tables_zone ON tables(zone);
```

## 🧾 Módulo de Facturación

### invoices
```sql
CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_number VARCHAR(50) UNIQUE NOT NULL, -- FC-A-00001-00000123
    order_id UUID REFERENCES orders(id),
    customer_id UUID REFERENCES users(id),
    customer_name VARCHAR(255) NOT NULL,
    customer_tax_id VARCHAR(50), -- CUIT/RUC/RFC
    customer_address TEXT,
    invoice_type VARCHAR(10) NOT NULL CHECK (invoice_type IN ('A', 'B', 'C', 'E')), -- Tipos de factura Argentina
    subtotal DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    total DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'issued'
        CHECK (status IN ('draft', 'issued', 'paid', 'void', 'cancelled')),
    payment_status VARCHAR(20) DEFAULT 'pending'
        CHECK (payment_status IN ('pending', 'partial', 'paid')),
    cae VARCHAR(50), -- CAE (Código de Autorización Electrónica) - Argentina
    cae_expiration DATE,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date DATE,
    paid_at TIMESTAMP,
    voided_at TIMESTAMP,
    void_reason TEXT,
    notes TEXT,
    pdf_url VARCHAR(500),
    xml_url VARCHAR(500), -- Para factura electrónica
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_invoices_invoice_number ON invoices(invoice_number);
CREATE INDEX idx_invoices_order_id ON invoices(order_id);
CREATE INDEX idx_invoices_customer_id ON invoices(customer_id);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoices_issued_at ON invoices(issued_at DESC);
```

### invoice_items
```sql
CREATE TABLE invoice_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID REFERENCES invoices(id) ON DELETE CASCADE,
    description VARCHAR(255) NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    tax_rate DECIMAL(5, 2) DEFAULT 0, -- 21%, 10.5%, etc.
    tax_amount DECIMAL(10, 2) DEFAULT 0,
    total DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_invoice_items_invoice_id ON invoice_items(invoice_id);
```

### tax_details
```sql
CREATE TABLE tax_details (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID REFERENCES invoices(id) ON DELETE CASCADE,
    tax_name VARCHAR(50) NOT NULL, -- 'IVA', 'IGV', etc.
    tax_rate DECIMAL(5, 2) NOT NULL,
    taxable_amount DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tax_details_invoice_id ON tax_details(invoice_id);
```

### credit_notes
```sql
CREATE TABLE credit_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    credit_note_number VARCHAR(50) UNIQUE NOT NULL,
    invoice_id UUID REFERENCES invoices(id),
    reason TEXT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'issued',
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_credit_notes_invoice_id ON credit_notes(invoice_id);
```

## 💳 Módulo de Pagos

### payment_methods
```sql
CREATE TABLE payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('cash', 'card', 'bank_transfer', 'digital_wallet', 'qr', 'crypto')),
    provider VARCHAR(50), -- 'stripe', 'mercadopago', 'paypal', etc.
    config JSONB, -- Configuración específica del proveedor
    active BOOLEAN DEFAULT TRUE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### payments
```sql
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_number VARCHAR(50) UNIQUE NOT NULL,
    order_id UUID REFERENCES orders(id),
    invoice_id UUID REFERENCES invoices(id),
    customer_id UUID REFERENCES users(id),
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    payment_method_id UUID REFERENCES payment_methods(id),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'refunded', 'cancelled')),
    gateway VARCHAR(50), -- 'stripe', 'mercadopago', etc.
    gateway_transaction_id VARCHAR(255),
    gateway_response JSONB,
    currency VARCHAR(3) DEFAULT 'ARS',
    metadata JSONB,
    processed_at TIMESTAMP,
    failed_at TIMESTAMP,
    failure_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_payments_invoice_id ON payments(invoice_id);
CREATE INDEX idx_payments_customer_id ON payments(customer_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_gateway_transaction_id ON payments(gateway_transaction_id);
```

### payment_splits
```sql
CREATE TABLE payment_splits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_id UUID REFERENCES payments(id) ON DELETE CASCADE,
    payment_method_id UUID REFERENCES payment_methods(id),
    amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_payment_splits_payment_id ON payment_splits(payment_id);
```

### refunds
```sql
CREATE TABLE refunds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    refund_number VARCHAR(50) UNIQUE NOT NULL,
    payment_id UUID REFERENCES payments(id),
    amount DECIMAL(10, 2) NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending'
        CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
    gateway_refund_id VARCHAR(255),
    processed_at TIMESTAMP,
    failed_at TIMESTAMP,
    failure_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_refunds_payment_id ON refunds(payment_id);
```

## 🚚 Módulo de Delivery

### drivers
```sql
CREATE TABLE drivers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    vehicle_id UUID REFERENCES vehicles(id),
    license_number VARCHAR(50),
    license_expiry DATE,
    status VARCHAR(20) DEFAULT 'inactive'
        CHECK (status IN ('active', 'inactive', 'busy', 'offline')),
    current_lat DECIMAL(10, 8),
    current_lng DECIMAL(11, 8),
    rating DECIMAL(3, 2) DEFAULT 0 CHECK (rating >= 0 AND rating <= 5),
    total_deliveries INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_drivers_user_id ON drivers(user_id);
CREATE INDEX idx_drivers_status ON drivers(status);
CREATE INDEX idx_drivers_rating ON drivers(rating DESC);
```

### vehicles
```sql
CREATE TABLE vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    plate VARCHAR(20) UNIQUE NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('bike', 'motorcycle', 'car', 'van')),
    brand VARCHAR(50),
    model VARCHAR(50),
    year INTEGER,
    color VARCHAR(30),
    insurance_expiry DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### delivery_zones
```sql
CREATE TABLE delivery_zones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    polygon JSONB, -- GeoJSON polygon
    base_fee DECIMAL(10, 2) NOT NULL DEFAULT 0,
    per_km_fee DECIMAL(10, 2) DEFAULT 0,
    min_order_amount DECIMAL(10, 2) DEFAULT 0,
    estimated_time INTEGER, -- Minutos estimados
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_delivery_zones_active ON delivery_zones(active);
```

### deliveries
```sql
CREATE TABLE deliveries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    delivery_number VARCHAR(50) UNIQUE NOT NULL,
    order_id UUID REFERENCES orders(id),
    driver_id UUID REFERENCES drivers(id),
    zone_id UUID REFERENCES delivery_zones(id),
    pickup_address TEXT NOT NULL,
    pickup_lat DECIMAL(10, 8),
    pickup_lng DECIMAL(11, 8),
    delivery_address TEXT NOT NULL,
    delivery_lat DECIMAL(10, 8),
    delivery_lng DECIMAL(11, 8),
    status VARCHAR(20) DEFAULT 'pending'
        CHECK (status IN ('pending', 'assigned', 'picked_up', 'in_transit', 'arrived', 'delivered', 'failed', 'cancelled')),
    distance_km DECIMAL(10, 2),
    estimated_time INTEGER, -- Minutos
    delivery_fee DECIMAL(10, 2) NOT NULL,
    tip_amount DECIMAL(10, 2) DEFAULT 0,
    driver_notes TEXT,
    customer_rating INTEGER CHECK (customer_rating >= 1 AND customer_rating <= 5),
    customer_review TEXT,
    assigned_at TIMESTAMP,
    picked_up_at TIMESTAMP,
    delivered_at TIMESTAMP,
    failed_at TIMESTAMP,
    failure_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_deliveries_order_id ON deliveries(order_id);
CREATE INDEX idx_deliveries_driver_id ON deliveries(driver_id);
CREATE INDEX idx_deliveries_status ON deliveries(status);
CREATE INDEX idx_deliveries_created_at ON deliveries(created_at DESC);
```

### delivery_timeline
```sql
CREATE TABLE delivery_timeline (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    delivery_id UUID REFERENCES deliveries(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_delivery_timeline_delivery_id ON delivery_timeline(delivery_id);
```

### driver_locations
```sql
CREATE TABLE driver_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id UUID REFERENCES drivers(id) ON DELETE CASCADE,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    accuracy DECIMAL(10, 2),
    speed DECIMAL(10, 2),
    heading DECIMAL(5, 2),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_driver_locations_driver_id ON driver_locations(driver_id);
CREATE INDEX idx_driver_locations_timestamp ON driver_locations(timestamp DESC);
```

---

**Continúa en la siguiente parte...**

Ver archivos adicionales en `/docs/base-de-datos/` para:
- Módulo de Notificaciones
- Módulo de Inventario
- Módulo de Lealtad
- Módulo de Reservaciones
- Módulo de Personal
- Triggers y Funciones
- Procedimientos Almacenados
