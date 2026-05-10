# Skill: Clean Architecture Frontend

## Camadas e Responsabilidades

```
src/app/
├── core/           # Singleton — carregado uma vez, global
├── shared/         # Reutilizável — sem estado de negócio
├── layout/         # Shell da aplicação
├── features/       # Domínios isolados (lazy loaded)
└── domain/         # Contratos, interfaces, models puros
```

## Core (Singleton Global)

**Responsabilidade:** Serviços de infraestrutura da aplicação

```
core/
├── guards/          # AuthGuard, RoleGuard
├── interceptors/    # AuthInterceptor, ErrorInterceptor, LoadingInterceptor
├── services/        # AuthService, ThemeService, NotificationService
├── tokens/          # API_URL, AUTH_CONFIG
└── config/          # environment abstraction, feature flags
```

```typescript
// Registrar no app.config.ts (standalone)
export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideHttpClient(withInterceptors([authInterceptor, errorInterceptor])),
    { provide: API_URL, useValue: environment.apiUrl }
  ]
};
```

## Shared (Reutilizável sem negócio)

**Responsabilidade:** UI primitives e utilitários transversais

```
shared/
├── components/      # ButtonComponent, InputComponent, ModalComponent
├── directives/      # AutoFocusDirective, PermissionDirective
├── pipes/           # DateBrPipe, CurrencyBrPipe, TruncatePipe
├── ui/              # design tokens, theme utilities
└── utils/           # formatters, validators, helpers puros
```

## Layout (Shell)

**Responsabilidade:** Estrutura visual base da aplicação

```
layout/
├── components/
│   ├── header/
│   ├── sidebar/
│   └── footer/
└── containers/
    ├── main-layout/    # com sidebar
    └── auth-layout/    # sem sidebar (login, etc.)
```

## Features (Domínios Isolados)

**Responsabilidade:** Toda lógica de uma funcionalidade de negócio

```
features/
└── orders/
    ├── orders.routes.ts          # lazy routes
    ├── pages/
    │   ├── order-list/
    │   └── order-detail/
    ├── components/               # smart + presentational
    ├── services/                 # order.service.ts
    ├── state/                    # store ou facade
    ├── models/                   # order.model.ts
    └── facades/                  # order.facade.ts
```

## Domain Layer (conceitual)

```
domain/
├── interfaces/      # IRepository<T>, IUseCase<T>
├── models/          # Order, Customer (interfaces puras)
├── contracts/       # ApiResponse<T>, PagedResult<T>
└── mappers/         # OrderMapper, CustomerMapper
```

## Regra de Dependência

```
Features → Domain ← Core
              ↑
           Shared
```

- Features **não importam** outras features diretamente
- Core **não importa** features
- Shared **não importa** Core nem Features
- Comunicação entre features: via Core service ou evento
