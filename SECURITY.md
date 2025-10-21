# Política de Seguridad

## 🔒 Versiones Soportadas

| Versión | Soportada          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## 🐛 Reportar una Vulnerabilidad

La seguridad de nuestro sistema es una prioridad. Si descubres una vulnerabilidad de seguridad, por favor repórtala responsablemente.

### ⚠️ NO crear un issue público

Por favor **NO** crees un issue público de GitHub para vulnerabilidades de seguridad. Esto puede exponer la vulnerabilidad antes de que podamos solucionarla.

### 📧 Cómo Reportar

**Opción 1: Email (Preferida)**
- Envía un email a: **security@turestaurante.com**
- Usa el asunto: `[SECURITY] Descripción breve`
- Incluye toda la información posible (ver abajo)

**Opción 2: GitHub Security Advisory**
- Ve a: https://github.com/tu-usuario/programadecomidas-claude/security/advisories
- Click en "New draft security advisory"
- Completa el formulario

### 📋 Información a Incluir

Por favor incluye la siguiente información en tu reporte:

1. **Descripción de la vulnerabilidad**
   - ¿Qué tipo de vulnerabilidad es?
   - ¿Cuál es el impacto potencial?

2. **Pasos para reproducir**
   - Instrucciones detalladas paso a paso
   - Versión afectada
   - Configuración necesaria

3. **Prueba de concepto (PoC)**
   - Código o comandos para demostrar el issue
   - Screenshots si aplica

4. **Impacto**
   - ¿Qué datos podrían verse comprometidos?
   - ¿Qué acceso podría obtener un atacante?

5. **Mitigación sugerida**
   - Si tienes ideas de cómo arreglarlo

6. **Tu información (opcional)**
   - Nombre
   - Afiliación
   - ¿Quieres ser mencionado en los créditos?

### 📅 ¿Qué esperar?

| Tiempo | Acción |
|--------|--------|
| **24 horas** | Confirmación de recepción |
| **72 horas** | Evaluación inicial y clasificación |
| **1 semana** | Plan de remediación |
| **30 días** | Fix implementado y desplegado |

### 🏆 Reconocimiento

- Mantenemos un archivo de SECURITY_CREDITS.md
- Agradecemos públicamente a los reporteros (si lo desean)
- Consideramos programas de recompensas para issues críticos

## 🛡️ Mejores Prácticas de Seguridad

### Para Usuarios del Sistema

1. **Credenciales**
   - Usa contraseñas fuertes (mín. 12 caracteres)
   - Habilita 2FA cuando sea posible
   - No compartas credenciales

2. **Actualizaciones**
   - Mantén el sistema actualizado
   - Aplica parches de seguridad inmediatamente

3. **Acceso**
   - Usa principio de menor privilegio
   - Revisa logs de acceso regularmente

### Para Desarrolladores

1. **Código**
   - Nunca commits credenciales o secrets
   - Usa variables de entorno
   - Valida todos los inputs
   - Sanitiza outputs

2. **Dependencias**
   - Ejecuta `npm audit` regularmente
   - Actualiza dependencias vulnerables
   - Usa Dependabot

3. **Testing**
   - Incluye tests de seguridad
   - Ejecuta SAST tools
   - Considera pentesting

## 🚨 Vulnerabilidades Conocidas

Actualmente no hay vulnerabilidades conocidas.

Las vulnerabilidades pasadas y sus fixes se documentan en:
- [Security Advisories](https://github.com/tu-usuario/programadecomidas-claude/security/advisories)
- [CHANGELOG.md](./CHANGELOG.md)

## 🔐 Características de Seguridad

### Autenticación
- ✅ JWT con expiración
- ✅ Refresh tokens
- ✅ Password hashing con bcrypt
- ✅ Rate limiting en login
- ✅ 2FA opcional

### Autorización
- ✅ RBAC (Role-Based Access Control)
- ✅ Permissions granulares
- ✅ API key management

### Protección de Datos
- ✅ Encryption en tránsito (HTTPS/TLS)
- ✅ Encryption en reposo (DB encryption)
- ✅ PII data protection
- ✅ GDPR compliance

### API Security
- ✅ Rate limiting
- ✅ CORS configurado
- ✅ Input validation
- ✅ SQL injection prevention
- ✅ XSS protection
- ✅ CSRF protection

### Logging y Monitoring
- ✅ Security event logging
- ✅ Failed login attempts tracking
- ✅ Anomaly detection
- ✅ Audit trails

## 📚 Recursos

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP API Security Top 10](https://owasp.org/www-project-api-security/)
- [CWE Top 25](https://cwe.mitre.org/top25/)

## 📞 Contacto

- **Email de Seguridad**: security@turestaurante.com
- **PGP Key**: [Link a clave pública PGP]

---

**Última actualización**: Octubre 2024
