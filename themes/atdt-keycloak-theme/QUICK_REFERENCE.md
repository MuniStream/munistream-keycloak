# ATDT Design System - Quick Reference

## Clases Reutilizables

### Layout & Container
```css
.atdt-container         /* Contenedor responsivo con márgenes */
```

### Typography
```css
.atdt-h1, .atdt-heading-1      /* 40px, Bold, 54px line-height */
.atdt-h2, .atdt-heading-2      /* 32px, Bold, 44px line-height */
.atdt-h3, .atdt-heading-3      /* 24px, SemiBold, 33px line-height */
.atdt-subtitle                 /* 20px, Bold, 27px line-height */
.atdt-body, .atdt-text         /* 16px, Regular, 22px line-height */
.atdt-body-semibold            /* 16px, SemiBold, 22px line-height */
.atdt-caption                  /* 14px, Regular, 19px line-height */
```

### Buttons
```css
.atdt-btn                      /* Base button */
.atdt-btn-primary              /* Primary action (Guinda) */
.atdt-btn-outlined             /* Outlined/Secondary */
.atdt-btn-text                 /* Text-only button */
.atdt-btn-sm                   /* Small size */
.atdt-btn-lg                   /* Large size */
.atdt-btn-block                /* Full width */
```

### Forms
```css
.atdt-form                     /* Form container */
.atdt-form-group               /* Field group */
.atdt-label, .atdt-form-label  /* Input label */
.atdt-input, .atdt-text-input  /* Text input */
.atdt-input-error              /* Error state */
.atdt-input-success            /* Success state */
.atdt-select                   /* Dropdown select */
.atdt-checkbox                 /* Checkbox wrapper */
.atdt-radio                    /* Radio wrapper */
.atdt-help-text                /* Helper text */
.atdt-error-text               /* Error message */
.atdt-success-text             /* Success message */
```

### Alerts
```css
.atdt-alert                    /* Base alert */
.atdt-alert-error              /* Error alert (red) */
.atdt-alert-success            /* Success alert (green) */
.atdt-alert-info               /* Info alert (blue) */
.atdt-alert-warning            /* Warning alert (yellow) */
```

### Cards
```css
.atdt-card                     /* Card container */
.atdt-card-header              /* Card header */
.atdt-card-body                /* Card body */
.atdt-card-footer              /* Card footer */
```

### Header
```css
.atdt-header                   /* Header bar */
.atdt-header-inner             /* Header content wrapper */
.atdt-header-brand             /* Logo + title container */
.atdt-header-logo              /* Logo image */
.atdt-header-title             /* Site title */
```

### Modal
```css
.atdt-modal-overlay            /* Modal backdrop */
.atdt-modal                    /* Modal container */
.atdt-modal-header             /* Modal header */
.atdt-modal-title              /* Modal title */
.atdt-modal-body               /* Modal content */
.atdt-modal-footer             /* Modal actions */
```

### Tabs
```css
.atdt-tabs                     /* Tabs container */
.atdt-tab                      /* Individual tab */
.atdt-tab-active               /* Active tab state */
```

### Breadcrumbs
```css
.atdt-breadcrumbs              /* Breadcrumb container */
.atdt-breadcrumb-item          /* Breadcrumb item */
.atdt-breadcrumb-separator     /* Separator (/) */
```

### Links
```css
.atdt-link                     /* Styled link (primary color) */
.atdt-back-link                /* Back navigation link */
```

### Utility Classes

#### Spacing (Margin)
```css
.atdt-m-0 to .atdt-m-4         /* All sides */
.atdt-mt-0 to .atdt-mt-4       /* Top */
.atdt-mb-0 to .atdt-mb-4       /* Bottom */
/* Values: 0, 8px, 16px, 24px, 32px */
```

#### Spacing (Padding)
```css
.atdt-p-0 to .atdt-p-4         /* All sides */
```

#### Text Alignment
```css
.atdt-text-left
.atdt-text-center
.atdt-text-right
```

#### Text Colors
```css
.atdt-text-primary             /* Guinda */
.atdt-text-secondary           /* Dorado */
.atdt-text-success             /* Verde */
.atdt-text-error               /* Rojo */
.atdt-text-muted               /* Gris */
```

#### Background Colors
```css
.atdt-bg-primary               /* Guinda */
.atdt-bg-white                 /* Blanco */
.atdt-bg-light                 /* Gris claro */
```

#### Display
```css
.atdt-d-none
.atdt-d-block
.atdt-d-flex
.atdt-d-inline
.atdt-d-inline-block
```

#### Flexbox
```css
.atdt-flex-row
.atdt-flex-column
.atdt-flex-wrap
.atdt-justify-start
.atdt-justify-center
.atdt-justify-end
.atdt-justify-between
.atdt-align-start
.atdt-align-center
.atdt-align-end
```

#### Gap
```css
.atdt-gap-1 to .atdt-gap-4     /* 8px, 16px, 24px, 32px */
```

#### Width
```css
.atdt-w-100                    /* 100% width */
.atdt-w-auto                   /* auto width */
```

#### Responsive Utilities
```css
.atdt-hide-mobile              /* Hide on mobile (<768px) */
.atdt-hide-tablet              /* Hide on tablet (768-1023px) */
.atdt-hide-desktop             /* Hide on desktop (>1024px) */
```

---

## Color Variables

```css
/* Primary (Guinda) */
--atdt-color-primary: #611232
--atdt-color-primary-dark: #3A0B1E
--atdt-color-primary-light: #9b2247
--atdt-color-primary-lighter: #F0ECED

/* Secondary (Dorado) */
--atdt-color-secondary: #a57f2c
--atdt-color-secondary-light: #e6d194

/* Neutral */
--atdt-color-neutral-800: #161a1d
--atdt-color-neutral-700: #575b5e
--atdt-color-neutral-600: #7a7c7e
--atdt-color-neutral-500: #9b9d9e
--atdt-color-neutral-400: #bcbebe
--atdt-color-neutral-300: #f3f3f3
--atdt-color-neutral-200: #dededf
--atdt-color-neutral-100: #ffffff

/* Validation */
--atdt-color-error: #c62026
--atdt-color-error-light: #fae5e5
--atdt-color-success: #0a7e3e
--atdt-color-success-light: #e5f5ed
--atdt-color-information: #0066cc
--atdt-color-information-light: #e5f0ff
--atdt-color-warning: #f59e0b
```

---

## Spacing Scale (8pt Grid)

```css
--atdt-spacing-0: 0
--atdt-spacing-1: 8px
--atdt-spacing-2: 16px
--atdt-spacing-3: 24px
--atdt-spacing-4: 32px
--atdt-spacing-5: 40px
--atdt-spacing-6: 48px
--atdt-spacing-7: 56px
--atdt-spacing-8: 64px
```

---

## Examples

### Complete Form
```html
<form class="atdt-form">
  <div class="atdt-form-group">
    <label class="atdt-label">Email</label>
    <input type="email" class="atdt-input" required>
    <span class="atdt-help-text">Ingresa tu correo electrónico</span>
  </div>
  
  <div class="atdt-form-group">
    <label class="atdt-label">Contraseña</label>
    <input type="password" class="atdt-input" required>
  </div>
  
  <button class="atdt-btn atdt-btn-primary atdt-btn-block">
    Iniciar sesión
  </button>
</form>
```

### Card with Actions
```html
<div class="atdt-card">
  <div class="atdt-card-header">
    <h3 class="atdt-h3">Título</h3>
  </div>
  <div class="atdt-card-body">
    <p class="atdt-body">Contenido del card</p>
  </div>
  <div class="atdt-card-footer">
    <button class="atdt-btn atdt-btn-outlined">Cancelar</button>
    <button class="atdt-btn atdt-btn-primary">Aceptar</button>
  </div>
</div>
```

### Alert with Message
```html
<div class="atdt-alert atdt-alert-success" role="alert">
  ✓ Tu cuenta ha sido creada exitosamente
</div>
```
