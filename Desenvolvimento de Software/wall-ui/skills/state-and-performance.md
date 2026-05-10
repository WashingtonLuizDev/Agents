# Skill: Estado e Performance

## Estratégia de Estado por Complexidade

| Complexidade | Solução | Quando usar |
|-------------|---------|-------------|
| Simples | Services + RxJS Signals | Estado local, 1-2 componentes |
| Intermediária | Facade Pattern | Feature com múltiplos componentes |
| Avançada | NgRx | Estado global complexo, time tracking, DevTools |

---

## Simples — Services + Signals (Angular 17+)

```typescript
@Injectable({ providedIn: 'root' })
export class OrderStateService {
  private _orders = signal<Order[]>([]);
  private _loading = signal(false);
  private _error = signal<string | null>(null);

  // Readonly para componentes
  readonly orders = this._orders.asReadonly();
  readonly loading = this._loading.asReadonly();
  readonly error = this._error.asReadonly();

  // Computados
  readonly pendingCount = computed(() =>
    this._orders().filter(o => o.status === 'Pending').length
  );

  constructor(private orderService: OrderService) {}

  load() {
    this._loading.set(true);
    this.orderService.getAll().pipe(
      takeUntilDestroyed(),
      finalize(() => this._loading.set(false))
    ).subscribe({
      next: orders => this._orders.set(orders),
      error: err => this._error.set(err.message)
    });
  }
}
```

---

## Intermediária — Facade Pattern

```typescript
// facade: isola a complexidade do componente
@Injectable({ providedIn: 'root' })
export class OrderFacade {
  private state = inject(OrderStateService);
  private service = inject(OrderService);
  private router = inject(Router);

  // Expõe apenas o necessário
  readonly vm$ = combineLatest({
    orders: this.state.orders$,
    loading: this.state.loading$,
    selected: this.state.selected$
  }).pipe(shareReplay(1));

  loadOrders() { this.state.dispatch(loadOrders()); }

  selectOrder(id: string) { this.state.dispatch(selectOrder({ id })); }

  createOrder(dto: CreateOrderDto) {
    return this.service.create(dto).pipe(
      tap(() => this.router.navigate(['/orders']))
    );
  }
}

// Componente limpo — só conhece a facade
@Component({...})
export class OrderListComponent {
  private facade = inject(OrderFacade);
  vm$ = this.facade.vm$;

  onSelect(id: string) { this.facade.selectOrder(id); }
}
```

---

## Performance Obrigatória

### ChangeDetectionStrategy.OnPush

```typescript
@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  // ...
})
```

**Regra:** Todo componente usa OnPush. Sem exceção.

---

### trackBy em Listas

```typescript
// Template
@for (order of orders; track order.id) { ... }

// Ou com *ngFor legado
<div *ngFor="let order of orders; trackBy: trackById">

trackById = (_: number, item: { id: string }) => item.id;
```

---

### Lazy Loading Obrigatório

```typescript
// Nunca importar feature modules no app root
// Sempre usar loadChildren ou loadComponent
{
  path: 'orders',
  loadChildren: () =>
    import('./features/orders/orders.routes').then(m => m.ordersRoutes)
}
```

---

### Evitar Memory Leaks

```typescript
// Angular 16+ — destroyRef (preferido)
private destroyRef = inject(DestroyRef);

this.service.data$.pipe(
  takeUntilDestroyed(this.destroyRef)
).subscribe(data => { ... });

// Alternativa com async pipe — zero subscribe manual
orders$ = this.facade.orders$; // usar | async no template
```

---

### Otimizações Adicionais

```typescript
// Virtual scroll para listas longas (CDK)
<cdk-virtual-scroll-viewport itemSize="72" class="h-96">
  <div *cdkVirtualFor="let item of items; trackBy: trackById">
    <app-order-card [order]="item" />
  </div>
</cdk-virtual-scroll-viewport>

// Imagens com lazy loading nativo
<img loading="lazy" [src]="product.imageUrl" [alt]="product.name">

// Defer blocks (Angular 17+)
@defer (on viewport) {
  <app-heavy-chart [data]="chartData" />
} @placeholder {
  <div class="h-64 bg-gray-100 animate-pulse rounded-lg"></div>
}
```

## Checklist de Performance

- [ ] OnPush em todos os componentes
- [ ] trackBy em todo `@for` / `*ngFor`
- [ ] Lazy loading em todas as features
- [ ] Zero subscribe em componente sem takeUntilDestroyed ou async pipe
- [ ] Virtual scroll para listas com 50+ itens
- [ ] `@defer` para componentes pesados fora do viewport
