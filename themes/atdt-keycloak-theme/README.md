# ATDT Keycloak Theme - Documentation

## Versión 2.0.0

### Basado en
- **UI KIT (ATDT)** - Febrero 2025
- **Keycloak** 25.0.6
- **Sistema de diseño** del Gobierno Federal

---

## 📋 Tabla de Contenidos

1. [Introducción](#introducción)
2. [Estructura del Tema](#estructura-del-tema)
3. [Sistema de Diseño](#sistema-de-diseño)
4. [Componentes](#componentes)
5. [Plantillas FTL](#plantillas-ftl)
6. [Instalación](#instalación)
7. [Personalización](#personalización)
8. [Reutilización en React/Vite](#reutilización-en-reactvite)
9. [Accesibilidad](#accesibilidad)

---

## Introducción

Este tema implementa de manera **pixel-perfect** las guías de diseño del UI KIT de la Agencia de Transformación Digital y Telecomunicaciones (ATDT) para las páginas de autenticación de Keycloak.

### Características Principales

- ✅ **8pt Grid System** - Sistema de espaciado consistente
- ✅ **Tipografía Noto Sans** - Familia tipográfica completa
- ✅ **Paleta Guinda/Dorado** - Colores de marca oficiales
- ✅ **Responsive Design** - Breakpoints para mobile, tablet y desktop
- ✅ **WCAG 2.1 AA** - Cumplimiento de accesibilidad
- ✅ **Componentes Reutilizables** - CSS modular y escalable
- ✅ **Llave MX Branding** - Integración oficial de marca

---

## Estructura del Tema

```
atdt-keycloak-theme/
├── login/
│   ├── login.ftl                  # Página de inicio de sesión
│   ├── login-reset-password.ftl   # Recuperación de contraseña
│   ├── register.ftl               # Registro de usuario
│   ├── info.ftl                   # Mensajes informativos
│   ├── error.ftl                  # Página de error
│   └── *.ftl.backup               # Respaldos de versiones anteriores
├── resources/
│   ├── css/
│   │   ├── atdt-design-system.css # Sistema de diseño completo (REUTILIZABLE)
│   │   ├── login.css              # Estilos específicos de Keycloak
│   │   └── *.css.backup           # Respaldos
│   └── img/
│       ├── logo.svg               # Logo de Llave MX
│       └── favicon.ico
├── theme.properties               # Configuración del tema
└── README.md                      # Este archivo
```

---

## Sistema de Diseño

### CSS Custom Properties (Design Tokens)

El sistema de diseño utiliza variables CSS para mantener consistencia:

#### Colores Primarios (Guinda)
```css
--atdt-color-guinda-170: #3A0B1E;  /* Más oscuro */
--atdt-color-guinda-160: #611232;  /* Principal */
--atdt-color-guinda-150: #9b2247;  /* Más claro */
--atdt-color-guinda-110: #F0ECED;  /* Muy claro */
```

#### Colores Secundarios (Dorado)
```css
--atdt-color-dorado-110: #a57f2c;  /* Principal */
--atdt-color-dorado-210: #e6d194;  /* Claro */
```

#### Colores Neutrales
```css
--atdt-color-neutral-800: #161a1d;  /* Negro */
--atdt-color-neutral-700: #575b5e;  /* Gris oscuro */
--atdt-color-neutral-600: #7a7c7e;
--atdt-color-neutral-500: #9b9d9e;
--atdt-color-neutral-400: #bcbebe;
--atdt-color-neutral-300: #f3f3f3;  /* Gris claro */
--atdt-color-neutral-200: #dededf;
--atdt-color-neutral-100: #ffffff;  /* Blanco */
```

#### Colores de Validación
```css
--atdt-color-mistake: #c62026;        /* Error */
--atdt-color-mistake-light: #fae5e5;
--atdt-color-success: #0a7e3e;        /* Éxito */
--atdt-color-success-light: #e5f5ed;
--atdt-color-information: #0066cc;    /* Información */
--atdt-color-information-light: #e5f0ff;
--atdt-color-warning: #f59e0b;        /* Advertencia */
```

### Tipografía

#### Jerarquía de Tamaños
```css
--atdt-font-size-h1: 40px;        /* Título principal */
--atdt-font-size-h2: 32px;        /* Subtítulo */
--atdt-font-size-h3: 24px;        /* Encabezado secundario */
--atdt-font-size-subtitle: 20px;  /* Subtítulo */
--atdt-font-size-body: 16px;      /* Cuerpo de texto */
--atdt-font-size-button: 16px;    /* Texto de botón */
--atdt-font-size-caption: 14px;   /* Caption/notas */
```

#### Pesos de Fuente
```css
--atdt-font-weight-regular: 400;
--atdt-font-weight-medium: 500;
--atdt-font-weight-semibold: 600;
--atdt-font-weight-bold: 700;
```

### Sistema de Espaciado (8pt Grid)

```css
--atdt-spacing-0: 0;
--atdt-spacing-1: 8px;
--atdt-spacing-2: 16px;
--atdt-spacing-3: 24px;
--atdt-spacing-4: 32px;
--atdt-spacing-5: 40px;
--atdt-spacing-6: 48px;
--atdt-spacing-7: 56px;
--atdt-spacing-8: 64px;
```

### Breakpoints Responsivos

| Dispositivo | Tamaño | Columnas | Margen | Gutter |
|-------------|--------|----------|--------|--------|
| Mobile XS | 320-374px | 4 | 16px | 16px |
| Mobile SM | 375-767px | 4 | 16px | 16px |
| Tablet MD | 768-1023px | 8 | 24px | 24px |
| Desktop LG | 1024-1439px | 12 | 56px | 24px |
| Desktop XL | 1440px+ | 12 | 56px | 24px |

---

## Componentes

### Botones

#### Primary Button
```html
<button class="atdt-btn atdt-btn-primary">Iniciar sesión</button>
```

#### Outlined Button
```html
<button class="atdt-btn atdt-btn-outlined">Cancelar</button>
```

#### Text Button
```html
<button class="atdt-btn atdt-btn-text">Ver más</button>
```

#### Modificadores
```html
<button class="atdt-btn atdt-btn-primary atdt-btn-sm">Pequeño</button>
<button class="atdt-btn atdt-btn-primary atdt-btn-lg">Grande</button>
<button class="atdt-btn atdt-btn-primary atdt-btn-block">Ancho completo</button>
```

### Inputs de Texto

```html
<div class="atdt-form-group">
  <label for="username" class="atdt-label">Usuario</label>
  <input type="text" id="username" class="atdt-input" />
  <span class="atdt-help-text">Ingresa tu nombre de usuario</span>
</div>
```

#### Estados
```html
<!-- Error -->
<input class="atdt-input atdt-input-error" />
<span class="atdt-error-text">Campo requerido</span>

<!-- Éxito -->
<input class="atdt-input atdt-input-success" />
<span class="atdt-success-text">Correcto</span>
```

### Alertas

```html
<div class="atdt-alert atdt-alert-error">Mensaje de error</div>
<div class="atdt-alert atdt-alert-success">Mensaje de éxito</div>
<div class="atdt-alert atdt-alert-info">Mensaje informativo</div>
<div class="atdt-alert atdt-alert-warning">Mensaje de advertencia</div>
```

### Cards

```html
<div class="atdt-card">
  <div class="atdt-card-header">
    <h2>Título</h2>
  </div>
  <div class="atdt-card-body">
    Contenido
  </div>
  <div class="atdt-card-footer">
    <button class="atdt-btn atdt-btn-primary">Acción</button>
  </div>
</div>
```

### Tabs

```html
<div class="atdt-tabs">
  <button class="atdt-tab atdt-tab-active">Tab 1</button>
  <button class="atdt-tab">Tab 2</button>
  <button class="atdt-tab">Tab 3</button>
</div>
```

---

## Plantillas FTL

### login.ftl
Página principal de inicio de sesión con soporte para:
- Login con usuario/email y contraseña
- Proveedores de identidad externos (OIDC, SAML)
- Remember me
- Links a recuperación de contraseña y registro

### login-reset-password.ftl
Página para solicitar recuperación de contraseña por email.

### register.ftl
Formulario de registro con validación de:
- Nombre y apellidos
- Email
- Usuario (opcional)
- Contraseña y confirmación
- reCAPTCHA (opcional)

### error.ftl
Página de error con información detallada y opciones de navegación.

### info.ftl
Página para mensajes informativos (verificación de email, confirmaciones, etc.).

---

## Instalación

### 1. Copiar el Tema

```bash
# Copiar tema a Keycloak
cp -r atdt-keycloak-theme /opt/keycloak/themes/
```

### 2. Configurar Realm

En la consola de administración de Keycloak:

1. Ir a **Realm Settings**
2. Seleccionar pestaña **Themes**
3. En **Login Theme**, seleccionar `atdt-keycloak-theme`
4. Guardar cambios

### 3. Configurar Links Legales

Editar `theme.properties`:

```properties
termsLink=https://ejemplo.gob.mx/terminos
privacyLink=https://ejemplo.gob.mx/privacidad
```

### 4. Reiniciar Keycloak (si es necesario)

```bash
# Solo si los cambios no se reflejan
systemctl restart keycloak
```

---

## Personalización

### Cambiar Colores de Marca

Editar `resources/css/atdt-design-system.css`:

```css
:root {
  --atdt-color-primary: #TU_COLOR;
  --atdt-color-secondary: #TU_COLOR;
}
```

### Agregar Logo Personalizado

Reemplazar `resources/img/logo.svg` con tu logo, manteniendo el nombre del archivo.

### Modificar Espaciado

El sistema de 8pt puede ajustarse modificando las variables:

```css
:root {
  --atdt-spacing-1: 8px;   /* Base */
  --atdt-spacing-2: 16px;  /* 2x */
  --atdt-spacing-3: 24px;  /* 3x */
  /* etc. */
}
```

---

## Reutilización en React/Vite

El archivo `atdt-design-system.css` está diseñado para ser **completamente reutilizable** en proyectos React/Vite.

### Instalación en React

```bash
# Copiar el archivo CSS
cp atdt-design-system.css src/styles/
```

### Importar en tu App

```javascript
// App.jsx o main.jsx
import './styles/atdt-design-system.css';

function App() {
  return (
    <div className="atdt-container">
      <button className="atdt-btn atdt-btn-primary">
        Mi Botón
      </button>
    </div>
  );
}
```

### Crear Componentes React

```javascript
// Button.jsx
export const Button = ({ children, variant = 'primary', ...props }) => {
  return (
    <button 
      className={`atdt-btn atdt-btn-${variant}`}
      {...props}
    >
      {children}
    </button>
  );
};

// Input.jsx
export const Input = ({ label, error, helperText, ...props }) => {
  return (
    <div className="atdt-form-group">
      <label className="atdt-label">{label}</label>
      <input 
        className={`atdt-input ${error ? 'atdt-input-error' : ''}`}
        {...props}
      />
      {error && <span className="atdt-error-text">{error}</span>}
      {helperText && <span className="atdt-help-text">{helperText}</span>}
    </div>
  );
};
```

---

## Accesibilidad

Este tema cumple con **WCAG 2.1 nivel AA**:

### ✅ Características de Accesibilidad

- **Contraste de Color**: Todos los textos cumplen ratio 4.5:1
- **Navegación por Teclado**: Todos los elementos interactivos son accesibles
- **Focus Visible**: Indicadores claros de foco
- **ARIA Labels**: Roles y etiquetas para lectores de pantalla
- **Skip Links**: "Saltar al contenido principal"
- **Responsive**: Funciona en todos los dispositivos
- **Reducción de Movimiento**: Respeta `prefers-reduced-motion`
- **Alto Contraste**: Mejoras para `prefers-contrast: high`

### Pruebas Recomendadas

```bash
# Lighthouse (en Chrome DevTools)
# Verificar Score de Accesibilidad > 95

# axe DevTools
# Instalar extensión y ejecutar análisis

# NVDA / JAWS
# Probar navegación con lector de pantalla
```

---

## Soporte

Para preguntas o problemas:

1. Revisar documentación del UI KIT (ATDT)
2. Consultar guías de Keycloak 25.0.6
3. Contactar al equipo de desarrollo

---

## Changelog

### v2.0.0 (2025-11-01)
- ✨ Implementación completa del UI KIT (ATDT)
- ✨ Sistema de diseño modular y reutilizable
- ✨ Nuevas plantillas: register, reset-password, info
- ✨ Mejoras de accesibilidad (WCAG 2.1 AA)
- ✨ Responsive design con breakpoints oficiales
- 🐛 Correcciones de espaciado y tipografía
- 📚 Documentación completa

### v1.0.0
- Versión inicial básica

---

## Licencia

Este tema es propiedad del Gobierno Federal de México.
Uso exclusivo para proyectos gubernamentales.
