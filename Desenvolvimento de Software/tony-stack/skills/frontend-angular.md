# Skill: Front-end Angular 2+

## Estrutura de Feature

```
features/
└── orders/
    ├── orders.module.ts
    ├── orders-routing.module.ts
    ├── pages/
    │   └── order-list/
    │       ├── order-list.component.ts
    │       ├── order-list.component.html
    │       └── order-list.component.scss
    ├── components/
    │   └── order-card/
    ├── services/
    │   └── order.service.ts
    ├── models/
    │   └── order.model.ts
    └── state/
        └── order.store.ts
```

## Componente Standalone (Angular 17+)

```typescript
@Component({
  selector: 'app-order-list',
  standalone: true,
  imports: [CommonModule, RouterModule, MatTableModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <mat-table [dataSource]="orders$ | async">
      <ng-container matColumnDef="id">
        <mat-header-cell *matHeaderCellDef>ID</mat-header-cell>
        <mat-cell *matCellDef="let row">{{ row.id }}</mat-cell>
      </ng-container>
      <mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
      <mat-row *matRowDef="let row; columns: displayedColumns"></mat-row>
    </mat-table>
  `
})
export class OrderListComponent {
  private orderService = inject(OrderService);
  orders$ = this.orderService.getAll();
  displayedColumns = ['id', 'status', 'total'];
}
```

## Service com HttpClient

```typescript
@Injectable({ providedIn: 'root' })
export class OrderService {
  private http = inject(HttpClient);
  private apiUrl = inject(API_URL);

  getAll(): Observable<Order[]> {
    return this.http.get<Order[]>(`${this.apiUrl}/orders`);
  }

  getById(id: string): Observable<Order> {
    return this.http.get<Order>(`${this.apiUrl}/orders/${id}`);
  }

  create(payload: CreateOrderDto): Observable<string> {
    return this.http.post<string>(`${this.apiUrl}/orders`, payload);
  }
}
```

## Reactive Forms

```typescript
export class OrderFormComponent {
  private fb = inject(FormBuilder);

  form = this.fb.group({
    customerId: ['', [Validators.required]],
    items: this.fb.array([])
  });

  get items(): FormArray {
    return this.form.get('items') as FormArray;
  }

  addItem() {
    this.items.push(this.fb.group({
      productId: ['', Validators.required],
      quantity: [1, [Validators.required, Validators.min(1)]],
      unitPrice: [0, [Validators.required, Validators.min(0.01)]]
    }));
  }

  submit() {
    if (this.form.invalid) return;
    // dispatch command
  }
}
```

## RxJS — Padrões Seguros

```typescript
// Cancelar subscrições com takeUntilDestroyed (Angular 16+)
orders$ = this.orderService.getAll().pipe(
  takeUntilDestroyed(),
  catchError(err => {
    console.error(err);
    return EMPTY;
  })
);

// Combinar streams
vm$ = combineLatest({
  orders: this.orderService.getAll(),
  loading: this.loading$
}).pipe(shareReplay(1));
```

## Diretrizes

- Sempre usar `ChangeDetectionStrategy.OnPush`
- Usar `trackBy` em `*ngFor` com listas dinâmicas
- Preferir Standalone Components (Angular 14+)
- Lazy loading obrigatório para features
- Nunca fazer subscribe em template — usar `async pipe`
- Signals (Angular 17+) para estado local simples
