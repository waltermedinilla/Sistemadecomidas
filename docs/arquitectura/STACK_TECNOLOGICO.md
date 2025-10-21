# 🛠️ Stack Tecnológico Detallado

## 📋 Índice

- [Backend](#backend)
- [Frontend](#frontend)
- [Mobile](#mobile)
- [Base de Datos](#base-de-datos)
- [DevOps e Infraestructura](#devops-e-infraestructura)
- [Integraciones](#integraciones)
- [Herramientas de Desarrollo](#herramientas-de-desarrollo)
- [Justificación de Elecciones](#justificación-de-elecciones)

## 🔧 Backend

### Runtime y Framework Principal

#### Node.js 20+
**¿Por qué?**
- Excelente para aplicaciones en tiempo real (WebSockets)
- Gran ecosistema de paquetes (npm)
- JavaScript/TypeScript en todo el stack
- Alto rendimiento con event loop no bloqueante

#### NestJS
**¿Por qué?**
- Framework opinado con arquitectura clara
- TypeScript nativo
- Soporte para microservicios out-of-the-box
- Dependency Injection integrado
- Fácil testing
- Documentación automática con Swagger

**Alternativa**: Express.js (más simple pero menos estructurado)

```json
// package.json - Dependencias principales backend
{
  "dependencies": {
    "@nestjs/core": "^10.0.0",
    "@nestjs/common": "^10.0.0",
    "@nestjs/platform-express": "^10.0.0",
    "@nestjs/microservices": "^10.0.0",
    "@nestjs/websockets": "^10.0.0",
    "@nestjs/platform-socket.io": "^10.0.0",
    "@nestjs/swagger": "^7.0.0",
    "@nestjs/typeorm": "^10.0.0",
    "@nestjs/graphql": "^12.0.0",
    "@nestjs/apollo": "^12.0.0",
    "typeorm": "^0.3.17",
    "pg": "^8.11.0",
    "redis": "^4.6.0",
    "socket.io": "^4.6.0",
    "class-validator": "^0.14.0",
    "class-transformer": "^0.5.1",
    "bcrypt": "^5.1.1",
    "jsonwebtoken": "^9.0.2",
    "passport": "^0.6.0",
    "passport-jwt": "^4.0.1"
  }
}
```

### API

#### REST API
**Framework**: NestJS Controllers
**Versionado**: `/api/v1/`
**Documentación**: Swagger/OpenAPI

**Estructura de endpoints**:
```
GET    /api/v1/orders
POST   /api/v1/orders
GET    /api/v1/orders/:id
PATCH  /api/v1/orders/:id
DELETE /api/v1/orders/:id
```

#### GraphQL
**Library**: Apollo Server
**Endpoint**: `/graphql`
**¿Por qué?**
- Queries flexibles desde el frontend
- Reduce overfetching/underfetching
- Schema fuertemente tipado

```typescript
// Ejemplo de query
query GetOrder($id: ID!) {
  order(id: $id) {
    id
    status
    items {
      product {
        name
        price
      }
      quantity
    }
    total
  }
}
```

#### WebSockets
**Library**: Socket.io
**¿Por qué?**
- Actualizaciones en tiempo real para KDS
- Notificaciones push al dashboard
- Tracking de delivery en tiempo real

```typescript
// Eventos Socket.io
socket.emit('order:created', orderData);
socket.on('order:updated', handleOrderUpdate);
socket.emit('delivery:location', { lat, lng });
```

### ORM (Object-Relational Mapping)

#### TypeORM
**¿Por qué?**
- Integración nativa con NestJS
- Soporte para migraciones
- TypeScript decorators
- Relaciones complejas

**Alternativa**: Prisma (más moderno, mejor DX)

```typescript
// Ejemplo de entity
@Entity('orders')
export class Order {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar' })
  status: OrderStatus;

  @ManyToOne(() => User)
  customer: User;

  @OneToMany(() => OrderItem, item => item.order)
  items: OrderItem[];

  @CreateDateColumn()
  createdAt: Date;
}
```

### Validación

#### Class-validator
```typescript
export class CreateOrderDto {
  @IsArray()
  @ValidateNested({ each: true })
  items: OrderItemDto[];

  @IsOptional()
  @IsString()
  notes?: string;
}
```

### Autenticación y Seguridad

#### Passport.js + JWT
```typescript
// JWT Strategy
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: process.env.JWT_SECRET,
    });
  }
}
```

#### Bcrypt
Para hash de contraseñas

```typescript
const hashedPassword = await bcrypt.hash(password, 10);
const isMatch = await bcrypt.compare(password, hashedPassword);
```

### Message Queue

#### Bull Queue (basado en Redis)
**¿Por qué?**
- Procesamiento asíncrono
- Jobs con reintentos
- Delayed jobs
- Prioridades

```typescript
// Ejemplo de queue
@Processor('notifications')
export class NotificationsProcessor {
  @Process('send-email')
  async sendEmail(job: Job<EmailData>) {
    // Enviar email
  }
}
```

## 🎨 Frontend

### Framework Web

#### React 18+
**¿Por qué?**
- Componentes reutilizables
- Gran ecosistema
- Virtual DOM para performance
- Hooks para state management

#### Next.js 14+
**¿Por qué?**
- SSR (Server-Side Rendering)
- SSG (Static Site Generation)
- API Routes
- Optimización de imágenes
- File-based routing

```json
// package.json - Frontend
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "next": "^14.0.0",
    "typescript": "^5.0.0",
    "@tanstack/react-query": "^5.0.0",
    "axios": "^1.6.0",
    "socket.io-client": "^4.6.0",
    "zustand": "^4.4.0",
    "react-hook-form": "^7.48.0",
    "zod": "^3.22.0"
  }
}
```

### UI/Styling

#### TailwindCSS
**¿Por qué?**
- Utility-first CSS
- Customizable
- Responsive por defecto
- Purge de CSS no utilizado

#### shadcn/ui
**¿Por qué?**
- Componentes accesibles
- Basado en Radix UI
- Customizable con TailwindCSS
- Copy-paste (no instalación de librería)

```tsx
// Ejemplo de componente
<Button variant="outline" size="lg">
  Crear Pedido
</Button>

<Table>
  <TableHeader>
    <TableRow>
      <TableHead>Pedido</TableHead>
      <TableHead>Estado</TableHead>
    </TableRow>
  </TableHeader>
</Table>
```

### Estado Global

#### Zustand
**¿Por qué?**
- Más simple que Redux
- Menos boilerplate
- TypeScript friendly
- Hooks-based

```typescript
// Store example
const useOrderStore = create<OrderStore>((set) => ({
  orders: [],
  addOrder: (order) => set((state) => ({
    orders: [...state.orders, order]
  })),
}));
```

**Alternativa**: Redux Toolkit (para apps muy grandes)

### Data Fetching

#### React Query (TanStack Query)
**¿Por qué?**
- Cache automático
- Refetch en background
- Optimistic updates
- Manejo de estados (loading, error)

```typescript
const { data, isLoading, error } = useQuery({
  queryKey: ['orders'],
  queryFn: fetchOrders,
  refetchInterval: 5000, // Refetch cada 5s
});
```

### Forms

#### React Hook Form + Zod
**¿Por qué?**
- Performance (menos re-renders)
- Validación con Zod
- TypeScript support

```typescript
const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
});

const { register, handleSubmit } = useForm({
  resolver: zodResolver(schema),
});
```

### Tiempo Real

#### Socket.io Client
```typescript
useEffect(() => {
  socket.on('order:created', (order) => {
    queryClient.invalidateQueries(['orders']);
  });
}, []);
```

## 📱 Mobile

### Framework

#### React Native
**¿Por qué?**
- Código compartido con web (React)
- Mismo lenguaje (TypeScript)
- Hot reload
- Gran comunidad

**Alternativa**: Flutter (si prefieres Dart)

```json
// package.json - Mobile
{
  "dependencies": {
    "react": "^18.2.0",
    "react-native": "^0.72.0",
    "@react-navigation/native": "^6.1.0",
    "@react-navigation/stack": "^6.3.0",
    "axios": "^1.6.0",
    "zustand": "^4.4.0",
    "@react-native-firebase/messaging": "^18.6.0",
    "react-native-maps": "^1.8.0"
  }
}
```

### Navegación

#### React Navigation
- Stack Navigator
- Tab Navigator
- Drawer Navigator

### Maps

#### React Native Maps
Para tracking de delivery

### Push Notifications

#### Firebase Cloud Messaging
```typescript
messaging().onMessage(async remoteMessage => {
  Alert.alert('Nuevo pedido!', remoteMessage.notification.body);
});
```

## 🗄️ Base de Datos

### Base de Datos Relacional

#### PostgreSQL 15+
**¿Por qué?**
- ACID compliant
- Relaciones complejas
- JSON support (para flexibilidad)
- Excelente para queries complejas
- Extensiones (PostGIS para geolocalización)

**Schemas principales**:
- Usuarios, Pedidos, Productos
- Facturas, Pagos
- Inventario, Recetas

### Cache y Message Broker

#### Redis 7+
**Uso**:
- Cache de sesiones
- Cache de queries frecuentes
- Bull Queue (jobs asíncronos)
- Pub/Sub para WebSockets

```typescript
// Cache example
await redis.set('user:123', JSON.stringify(user), 'EX', 3600);
const cachedUser = await redis.get('user:123');
```

### Base de Datos NoSQL

#### MongoDB
**Uso**:
- Logs de aplicación
- Eventos del sistema
- Datos de analytics (agregados)
- Historial de notificaciones

**¿Por qué?**
- Flexible schema
- Excelente para write-heavy workloads (logs)
- Agregaciones complejas

### Storage

#### AWS S3 (o alternativa Cloudinary)
**Uso**:
- Imágenes de productos
- Logos del restaurante
- Documentos (facturas PDF)

## 🚀 DevOps e Infraestructura

### Containerización

#### Docker
**Dockerfile example**:
```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
CMD ["npm", "run", "start:prod"]
```

#### Docker Compose
Para desarrollo local:
```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: restaurant_db
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secret
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  backend:
    build: ./backend
    ports:
      - "4000:4000"
    depends_on:
      - postgres
      - redis
```

### Orquestación (Producción)

#### Kubernetes
**¿Cuándo?**
- Múltiples microservicios
- Auto-scaling necesario
- Alta disponibilidad crítica

**Alternativa**: Docker Swarm (más simple)

### Proxy Reverso

#### Nginx
```nginx
upstream backend {
    server backend1:4000;
    server backend2:4000;
    server backend3:4000;
}

server {
    listen 80;

    location /api {
        proxy_pass http://backend;
    }

    location /socket.io {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

### CI/CD

#### GitHub Actions
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: npm test

  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - name: Build Docker image
        run: docker build -t myapp .

  deploy:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to production
        run: kubectl apply -f k8s/
```

### Cloud Provider

#### AWS (Recomendado)
**Servicios usados**:
- EC2: Servidores
- RDS: PostgreSQL managed
- ElastiCache: Redis managed
- S3: Storage
- CloudFront: CDN
- Route 53: DNS
- ELB: Load Balancer

**Alternativas**: Google Cloud, Azure, DigitalOcean

### Monitoreo

#### Prometheus + Grafana
**Métricas monitoreadas**:
- CPU, RAM, Disco
- Request latency
- Error rates
- Database connections

#### ELK Stack (Elasticsearch, Logstash, Kibana)
Para centralización de logs

### Alertas

#### PagerDuty / Opsgenie
Para alertas críticas (downtime, errores)

## 🔌 Integraciones

### Pagos

#### Stripe
```typescript
const paymentIntent = await stripe.paymentIntents.create({
  amount: 5000,
  currency: 'usd',
  payment_method_types: ['card'],
});
```

#### MercadoPago (Latinoamérica)
```typescript
const preference = await mercadopago.preferences.create({
  items: [{
    title: 'Pedido #123',
    quantity: 1,
    unit_price: 50.00,
  }],
});
```

### Mensajería

#### Twilio (SMS)
```typescript
await twilio.messages.create({
  body: 'Tu pedido está en camino!',
  from: '+1234567890',
  to: customerPhone,
});
```

#### WhatsApp Business API
```typescript
await axios.post(whatsappApiUrl, {
  messaging_product: 'whatsapp',
  to: customerPhone,
  type: 'template',
  template: { name: 'order_confirmation' },
});
```

#### SendGrid (Email)
```typescript
await sgMail.send({
  to: customerEmail,
  from: 'noreply@restaurant.com',
  subject: 'Confirmación de Pedido',
  html: emailTemplate,
});
```

### Notificaciones Push

#### Firebase Cloud Messaging
```typescript
await admin.messaging().send({
  token: deviceToken,
  notification: {
    title: 'Nuevo pedido',
    body: 'Tu pedido #123 está listo',
  },
});
```

### Mapas

#### Google Maps API
- Geocoding
- Directions
- Distance Matrix

```typescript
const response = await googleMaps.directions({
  origin: restaurantAddress,
  destination: customerAddress,
  mode: 'driving',
});
```

### Facturación Electrónica

#### Integración según país
- **Argentina**: AFIP (Web Services)
- **México**: SAT (CFDI)
- **Perú**: SUNAT
- **Chile**: SII

## 🛠️ Herramientas de Desarrollo

### IDE
- VS Code
- WebStorm

### Control de Versiones
- Git
- GitHub / GitLab

### Testing

#### Backend
```json
{
  "devDependencies": {
    "@nestjs/testing": "^10.0.0",
    "jest": "^29.0.0",
    "supertest": "^6.3.0"
  }
}
```

#### Frontend
```json
{
  "devDependencies": {
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^6.0.0",
    "vitest": "^1.0.0"
  }
}
```

#### E2E
- Playwright
- Cypress

### Linting y Formatting

```json
{
  "devDependencies": {
    "eslint": "^8.50.0",
    "prettier": "^3.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0"
  }
}
```

### API Testing
- Postman
- Insomnia
- Thunder Client (VS Code)

## ✅ Justificación de Elecciones

### ¿Por qué Node.js + NestJS?
1. **JavaScript/TypeScript en todo el stack** - Mismo lenguaje frontend y backend
2. **Excelente para tiempo real** - WebSockets nativos
3. **Microservicios** - NestJS tiene soporte nativo
4. **Gran comunidad** - Solución de problemas rápida

### ¿Por qué React/Next.js?
1. **Componentes reutilizables** - DRY principle
2. **SSR para SEO** - Next.js mejora SEO
3. **Ecosistema maduro** - Muchas librerías disponibles
4. **React Native** - Código compartido con mobile

### ¿Por qué PostgreSQL?
1. **Relaciones complejas** - Pedidos, facturas, inventario
2. **ACID** - Crítico para pagos y facturación
3. **JSON support** - Flexibilidad cuando se necesita
4. **Open source** - Sin costos de licencia

### ¿Por qué Redis?
1. **Velocidad** - In-memory database
2. **Versatilidad** - Cache, sessions, queues, pub/sub
3. **Fácil integración** - Con NestJS y Bull

### ¿Por qué Microservicios?
1. **Escalabilidad** - Escalar solo lo necesario
2. **Desarrollo paralelo** - Equipos independientes
3. **Tolerancia a fallos** - Un servicio no afecta a otros
4. **Tecnología flexible** - Cada servicio puede usar lo mejor para su caso

---

**Nota**: Estas son recomendaciones basadas en las mejores prácticas actuales. Pueden ajustarse según necesidades específicas del proyecto.
