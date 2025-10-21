# 🤝 Guía de Contribución

¡Gracias por tu interés en contribuir al Sistema de Comandas para Restaurantes! Este documento te guiará a través del proceso.

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [¿Cómo puedo contribuir?](#cómo-puedo-contribuir)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Estándares de Código](#estándares-de-código)
- [Commits y Pull Requests](#commits-y-pull-requests)
- [Reportar Bugs](#reportar-bugs)
- [Sugerir Nuevas Características](#sugerir-nuevas-características)

## 📜 Código de Conducta

Este proyecto y todos los participantes están regidos por nuestro [Código de Conducta](CODE_OF_CONDUCT.md). Al participar, se espera que respetes este código.

## 🎯 ¿Cómo puedo contribuir?

Hay muchas formas de contribuir:

### 1. Reportar Bugs
- Usa el [issue tracker](https://github.com/tu-usuario/programadecomidas-claude/issues)
- Verifica que el bug no haya sido reportado antes
- Incluye detalles de reproducción
- Adjunta screenshots si aplica

### 2. Sugerir Mejoras
- Abre un issue con la etiqueta `enhancement`
- Describe claramente la funcionalidad
- Explica por qué sería útil

### 3. Mejorar Documentación
- Corrige typos
- Mejora explicaciones
- Agrega ejemplos
- Traduce a otros idiomas

### 4. Contribuir Código
- Correcciones de bugs
- Nuevas características
- Optimizaciones de performance
- Tests

## 🔧 Proceso de Desarrollo

### 1. Fork y Clone

```bash
# Fork el repositorio en GitHub, luego:
git clone https://github.com/TU-USUARIO/programadecomidas-claude.git
cd programadecomidas-claude

# Agrega el upstream
git remote add upstream https://github.com/USUARIO-ORIGINAL/programadecomidas-claude.git
```

### 2. Crear una Rama

```bash
# Actualiza tu main
git checkout main
git pull upstream main

# Crea tu rama de feature/fix
git checkout -b feature/nombre-descriptivo
# o
git checkout -b fix/descripcion-del-bug
```

**Convención de nombres de ramas:**
- `feature/` - Nuevas características
- `fix/` - Corrección de bugs
- `docs/` - Cambios en documentación
- `refactor/` - Refactorización de código
- `test/` - Agregar o mejorar tests
- `chore/` - Tareas de mantenimiento

### 3. Configurar el Entorno

```bash
# Instalar dependencias
npm install

# Copiar variables de entorno
cp .env.example .env

# Levantar servicios con Docker
docker-compose up -d

# Ejecutar migraciones
npm run migration:run
```

### 4. Hacer Cambios

- Escribe código limpio y mantenible
- Sigue los [estándares de código](#estándares-de-código)
- Agrega tests para nuevas funcionalidades
- Actualiza la documentación si es necesario

### 5. Tests

```bash
# Ejecutar todos los tests
npm test

# Tests unitarios
npm run test:unit

# Tests de integración
npm run test:integration

# Tests e2e
npm run test:e2e

# Coverage
npm run test:coverage
```

**Asegúrate que todos los tests pasen antes de hacer commit.**

### 6. Commit

```bash
git add .
git commit -m "feat: descripción clara del cambio"
```

Ver [Convención de Commits](#convención-de-commits) abajo.

### 7. Push

```bash
git push origin feature/nombre-descriptivo
```

### 8. Pull Request

1. Ve a tu fork en GitHub
2. Click en "Compare & pull request"
3. Llena el template de PR
4. Espera el review

## 📝 Estándares de Código

### TypeScript / JavaScript

#### ESLint y Prettier

```bash
# Lint
npm run lint

# Fix automático
npm run lint:fix

# Format
npm run format
```

#### Convenciones

```typescript
// ✅ Bueno
interface User {
  id: string;
  email: string;
  fullName: string;
}

function createUser(data: CreateUserDto): Promise<User> {
  // ...
}

// ❌ Malo
interface user {
  ID: string;
  Email: string;
  full_name: string;
}

function CreateUser(data: any): any {
  // ...
}
```

#### Naming Conventions

| Tipo | Convención | Ejemplo |
|------|------------|---------|
| Variables | camelCase | `const userName` |
| Constantes | UPPER_SNAKE_CASE | `const MAX_RETRIES` |
| Funciones | camelCase | `function calculateTotal()` |
| Clases | PascalCase | `class OrderService` |
| Interfaces | PascalCase | `interface CreateOrderDto` |
| Types | PascalCase | `type OrderStatus` |
| Enums | PascalCase | `enum OrderType` |
| Archivos | kebab-case | `order-service.ts` |

### Estructura de Archivos

```typescript
// orden-service.ts

// 1. Imports
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Order } from './entities/order.entity';

// 2. Types/Interfaces
interface CreateOrderOptions {
  customerId: string;
  items: OrderItem[];
}

// 3. Class
@Injectable()
export class OrderService {
  // 3.1 Properties
  constructor(
    @InjectRepository(Order)
    private orderRepository: Repository<Order>,
  ) {}

  // 3.2 Public methods
  async create(options: CreateOrderOptions): Promise<Order> {
    // ...
  }

  // 3.3 Private methods
  private calculateTotal(items: OrderItem[]): number {
    // ...
  }
}
```

### Comentarios

```typescript
// ✅ Bueno - Explica el "por qué"
// Usamos exponential backoff para evitar saturar el servidor
async function retryWithBackoff() {
  // ...
}

// ✅ Bueno - JSDoc para funciones públicas
/**
 * Crea una nueva orden
 * @param data - Datos de la orden
 * @returns La orden creada
 * @throws {ValidationError} Si los datos son inválidos
 */
async function createOrder(data: CreateOrderDto): Promise<Order> {
  // ...
}

// ❌ Malo - Comenta lo obvio
// Suma a y b
function add(a: number, b: number): number {
  return a + b;
}
```

### Testing

```typescript
// order.service.spec.ts

describe('OrderService', () => {
  let service: OrderService;
  let repository: MockRepository<Order>;

  beforeEach(() => {
    // Setup
  });

  describe('create', () => {
    it('should create an order successfully', async () => {
      // Arrange
      const createOrderDto = { ... };

      // Act
      const result = await service.create(createOrderDto);

      // Assert
      expect(result).toBeDefined();
      expect(result.id).toBeTruthy();
    });

    it('should throw error if customer not found', async () => {
      // Arrange
      const createOrderDto = { customerId: 'invalid' };

      // Act & Assert
      await expect(service.create(createOrderDto))
        .rejects
        .toThrow('Customer not found');
    });
  });
});
```

## 💬 Commits y Pull Requests

### Convención de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/)

**Formato:**
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: Nueva característica
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Cambios de formato (no afectan el código)
- `refactor`: Refactorización
- `test`: Agregar o modificar tests
- `chore`: Tareas de mantenimiento
- `perf`: Mejoras de performance

**Ejemplos:**

```bash
# Nueva característica
git commit -m "feat(orders): add order cancellation functionality"

# Corrección de bug
git commit -m "fix(kds): resolve order display timing issue"

# Documentación
git commit -m "docs(api): update authentication endpoints"

# Con cuerpo
git commit -m "feat(payments): integrate MercadoPago

- Add MercadoPago service
- Add payment processing endpoint
- Add webhook handler

Closes #123"
```

### Pull Request

#### Template de PR

```markdown
## Descripción
Breve descripción de los cambios.

## Tipo de cambio
- [ ] Bug fix (cambio que corrige un issue)
- [ ] Nueva característica (cambio que agrega funcionalidad)
- [ ] Breaking change (fix o feature que causa que funcionalidad existente no funcione como antes)
- [ ] Actualización de documentación

## ¿Cómo se ha probado?
Describe los tests que ejecutaste.

## Checklist
- [ ] Mi código sigue los estándares del proyecto
- [ ] He realizado un self-review de mi código
- [ ] He comentado mi código, especialmente en áreas difíciles
- [ ] He actualizado la documentación
- [ ] Mis cambios no generan nuevos warnings
- [ ] He agregado tests que prueban que mi fix/feature funciona
- [ ] Todos los tests unitarios pasan localmente
- [ ] Todos los tests de integración pasan

## Screenshots (si aplica)
Agrega screenshots si hay cambios visuales.

## Issues relacionados
Closes #123
```

#### Review Process

1. **Automated Checks**: CI/CD debe pasar
2. **Code Review**: Al menos 1 aprobación requerida
3. **Testing**: Tests deben pasar
4. **Merge**: Squash and merge (preferido)

## 🐛 Reportar Bugs

### Template de Bug Report

```markdown
## Descripción del Bug
Descripción clara y concisa del bug.

## Para Reproducir
Pasos para reproducir:
1. Ve a '...'
2. Click en '...'
3. Scroll hasta '...'
4. Ver error

## Comportamiento Esperado
Descripción de lo que esperabas que pasara.

## Comportamiento Actual
Lo que realmente está pasando.

## Screenshots
Si aplica, agrega screenshots.

## Entorno
- OS: [e.g. Ubuntu 22.04]
- Browser: [e.g. Chrome 120]
- Node version: [e.g. 20.10.0]
- Version del proyecto: [e.g. 1.2.0]

## Contexto Adicional
Cualquier otro contexto sobre el problema.

## Logs
```
Pega logs relevantes aquí
```
```

## 💡 Sugerir Nuevas Características

### Template de Feature Request

```markdown
## ¿Tu feature request está relacionado con un problema?
Descripción clara del problema. Ej: "Siempre me frustra cuando [...]"

## Describe la solución que te gustaría
Descripción clara y concisa de lo que quieres que pase.

## Describe alternativas que has considerado
Descripción de soluciones o características alternativas.

## Contexto Adicional
Cualquier otro contexto o screenshots sobre el feature request.

## ¿Estarías dispuesto a implementarlo?
- [ ] Sí, puedo trabajar en esto
- [ ] Necesitaría ayuda
- [ ] Solo estoy sugiriendo
```

## 🏆 Reconocimiento

Los contribuidores serán reconocidos en:
- README.md (sección de Contribuidores)
- Release notes
- Página de créditos en la aplicación

## 📞 ¿Necesitas Ayuda?

- 💬 [Discord Server](#)
- 📧 Email: dev@turestaurante.com
- 📖 [Documentation](./docs/README.md)

## 📚 Recursos

- [Documentación Completa](./docs/README.md)
- [Arquitectura del Sistema](./docs/arquitectura/ARQUITECTURA.md)
- [Guía de Instalación](./docs/guias/INSTALACION.md)
- [API Documentation](./docs/apis/README.md)

---

¡Gracias por contribuir! 🎉
