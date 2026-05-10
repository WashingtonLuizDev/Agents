# Skill: Estrutura de Projeto

## Scaffold Completo

```
src/
├── app/
│   ├── core/
│   │   ├── guards/
│   │   ├── interceptors/
│   │   ├── services/
│   │   └── tokens/
│   ├── shared/
│   │   ├── components/
│   │   ├── directives/
│   │   ├── pipes/
│   │   └── ui/
│   ├── layout/
│   │   ├── components/
│   │   │   ├── header/
│   │   │   ├── sidebar/
│   │   │   └── footer/
│   │   └── containers/
│   │       ├── main-layout/
│   │       └── auth-layout/
│   ├── features/
│   │   ├── dashboard/
│   │   └── [feature]/
│   ├── domain/
│   │   ├── interfaces/
│   │   ├── models/
│   │   └── mappers/
│   ├── app.config.ts
│   ├── app.routes.ts
│   └── app.component.ts
├── assets/
│   ├── icons/
│   └── images/
└── styles/
    ├── _variables.scss
    ├── _mixins.scss
    ├── theme.scss
    ├── tailwind.css
    └── design-tokens.scss
```

## Comandos CLI para Scaffold

```bash
# Novo projeto standalone
ng new my-app --standalone --routing --style=scss

# Instalar dependências
ng add @angular/material
npm install tailwindcss @tailwindcss/typography

# Gerar feature completa
ng generate component features/orders/pages/order-list --standalone
ng generate service features/orders/services/order
ng generate interface features/orders/models/order

# Gerar componente shared
ng generate component shared/components/data-table --standalone
```

## Lazy Loading — app.routes.ts

```typescript
export const routes: Routes = [
  {
    path: '',
    component: MainLayoutComponent,
    children: [
      {
        path: 'dashboard',
        loadComponent: () =>
          import('./features/dashboard/pages/dashboard/dashboard.component')
            .then(m => m.DashboardComponent)
      },
      {
        path: 'orders',
        loadChildren: () =>
          import('./features/orders/orders.routes')
            .then(m => m.ordersRoutes)
      }
    ]
  },
  {
    path: 'auth',
    component: AuthLayoutComponent,
    loadChildren: () =>
      import('./features/auth/auth.routes').then(m => m.authRoutes)
  }
];
```

## Naming Conventions

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Componente | `kebab-case.component.ts` | `order-list.component.ts` |
| Service | `kebab-case.service.ts` | `order.service.ts` |
| Model/Interface | `kebab-case.model.ts` | `order.model.ts` |
| Store/State | `kebab-case.store.ts` | `order.store.ts` |
| Facade | `kebab-case.facade.ts` | `order.facade.ts` |
| Routes | `kebab-case.routes.ts` | `orders.routes.ts` |
| Selector CSS | `.feature-component-element` | `.order-list-table` |

## Componente Inteligente vs Apresentacional

| Smart (Container) | Presentational |
|-------------------|----------------|
| Injeta services | Recebe dados por `@Input()` |
| Orquestra estado | Emite eventos por `@Output()` |
| Está em `pages/` | Está em `components/` |
| Raramente reutilizado | Altamente reutilizável |
