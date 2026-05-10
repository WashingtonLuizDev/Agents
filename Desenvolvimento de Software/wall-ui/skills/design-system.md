# Skill: Design System (Material + Tailwind)

## Estratégia de Integração

| Use Angular Material para | Use Tailwind para |
|--------------------------|-------------------|
| mat-table, mat-form-field | Grid responsivo, flexbox |
| mat-dialog, mat-snackbar | Espaçamento, padding, margin |
| mat-sidenav, mat-toolbar | Dark mode customizado |
| mat-menu, mat-tabs | Ajustes finos de estilo |
| mat-button, mat-icon | Tipografia e cores utilitárias |

## Tema Angular Material (theme.scss)

```scss
@use '@angular/material' as mat;

$primary-palette: mat.define-palette(mat.$indigo-palette, 700, 400, 900);
$accent-palette:  mat.define-palette(mat.$amber-palette, A200);
$warn-palette:    mat.define-palette(mat.$red-palette);

$light-theme: mat.define-light-theme((
  color: (
    primary: $primary-palette,
    accent:  $accent-palette,
    warn:    $warn-palette,
  ),
  typography: mat.define-typography-config(
    $font-family: 'Inter, sans-serif',
    $headline-1: mat.define-typography-level(96px, 112px, 300),
    $body-1: mat.define-typography-level(16px, 24px, 400),
  ),
  density: 0
));

$dark-theme: mat.define-dark-theme((
  color: (
    primary: $primary-palette,
    accent:  $accent-palette,
    warn:    $warn-palette,
  )
));

@include mat.all-component-themes($light-theme);

.dark-mode {
  @include mat.all-component-colors($dark-theme);
}
```

## Design Tokens (design-tokens.scss)

```scss
// Sistema 8pt
:root {
  // Spacing
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-6: 24px;
  --space-8: 32px;
  --space-12: 48px;
  --space-16: 64px;

  // Colors (alinhados ao tema Material)
  --color-primary: #3f51b5;
  --color-primary-light: #7986cb;
  --color-primary-dark: #283593;
  --color-accent: #ffd740;
  --color-warn: #f44336;
  --color-surface: #ffffff;
  --color-background: #f5f5f5;
  --color-on-surface: #212121;
  --color-border: #e0e0e0;

  // Typography
  --font-family: 'Inter', sans-serif;
  --font-size-xs: 12px;
  --font-size-sm: 14px;
  --font-size-base: 16px;
  --font-size-lg: 18px;
  --font-size-xl: 20px;
  --font-size-2xl: 24px;

  // Border radius
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-full: 9999px;

  // Shadows
  --shadow-sm: 0 1px 3px rgba(0,0,0,0.12);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.10);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.10);
}
```

## Tailwind Config (tailwind.config.js)

```js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./src/**/*.{html,ts}'],
  // Importante: não conflitar com Material
  corePlugins: {
    preflight: false, // desabilitar reset do Tailwind
  },
  important: '#app-root', // aumentar especificidade
  darkMode: ['class', '.dark-mode'],
  theme: {
    extend: {
      colors: {
        primary: 'var(--color-primary)',
        accent: 'var(--color-accent)',
        warn: 'var(--color-warn)',
        surface: 'var(--color-surface)',
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
      },
      spacing: {
        // estender com tokens customizados
      }
    }
  }
};
```

## Evitar Conflitos Material + Tailwind

1. **Desabilitar `preflight`** no Tailwind (não resetar estilos base)
2. **Usar `important: '#app-root'`** para aumentar especificidade do Tailwind
3. **Não usar classes Tailwind em componentes Material** — usar apenas em layout containers
4. **Usar `@layer components`** para classes customizadas de componentes
