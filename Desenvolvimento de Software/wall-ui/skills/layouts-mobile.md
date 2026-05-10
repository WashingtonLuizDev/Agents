# Skill: Layouts Mobile (3 Variações Obrigatórias)

## Breakpoints Mobile

```scss
// Tailwind / SCSS
$mobile-sm: 320px;
$mobile-md: 375px;
$mobile-lg: 428px;
// Tablet começa em 768px
```

---

## Variação 1 — Bottom Navigation

**Ideal para:** Apps com 3-5 seções principais, navegação frequente

```typescript
@Component({
  selector: 'app-bottom-nav-layout',
  standalone: true,
  imports: [MatBottomSheetModule, MatIconModule, RouterModule],
  template: `
    <div class="flex flex-col h-screen">
      <main class="flex-1 overflow-auto pb-16">
        <router-outlet></router-outlet>
      </main>
      <nav class="fixed bottom-0 left-0 right-0 bg-surface shadow-lg border-t border-border">
        <div class="flex justify-around items-center h-16">
          @for (item of navItems; track item.route) {
            <a [routerLink]="item.route" routerLinkActive="text-primary"
               class="flex flex-col items-center gap-1 px-4 py-2">
              <mat-icon>{{ item.icon }}</mat-icon>
              <span class="text-xs">{{ item.label }}</span>
            </a>
          }
        </div>
      </nav>
    </div>
  `
})
export class BottomNavLayoutComponent {
  navItems = [
    { route: '/dashboard', icon: 'dashboard', label: 'Início' },
    { route: '/orders', icon: 'shopping_cart', label: 'Pedidos' },
    { route: '/profile', icon: 'person', label: 'Perfil' }
  ];
}
```

**Prós:** Acessível (polegar), navegação rápida
**Contras:** Espaço limitado para mais de 5 itens

---

## Variação 2 — Drawer Responsivo

**Ideal para:** Apps com muitas seções, menu hierárquico

```typescript
@Component({
  selector: 'app-drawer-layout',
  standalone: true,
  imports: [MatSidenavModule, MatToolbarModule, MatIconModule, RouterModule],
  template: `
    <mat-sidenav-container class="h-screen">
      <mat-sidenav #drawer mode="over" class="w-72">
        <mat-nav-list>
          @for (item of menuItems; track item.route) {
            <a mat-list-item [routerLink]="item.route" (click)="drawer.close()">
              <mat-icon matListItemIcon>{{ item.icon }}</mat-icon>
              <span matListItemTitle>{{ item.label }}</span>
            </a>
          }
        </mat-nav-list>
      </mat-sidenav>

      <mat-sidenav-content>
        <mat-toolbar color="primary" class="sticky top-0 z-10">
          <button mat-icon-button (click)="drawer.toggle()">
            <mat-icon>menu</mat-icon>
          </button>
          <span>{{ title() }}</span>
        </mat-toolbar>
        <main class="p-4">
          <router-outlet></router-outlet>
        </main>
      </mat-sidenav-content>
    </mat-sidenav-container>
  `
})
export class DrawerLayoutComponent {
  title = signal('App');
}
```

**Prós:** Espaço ilimitado no menu, familiar para usuários mobile
**Contras:** Menu está escondido — descoberta mais difícil

---

## Variação 3 — Tabs + FAB

**Ideal para:** Apps focadas em conteúdo, ação primária proeminente

```typescript
@Component({
  selector: 'app-tabs-fab-layout',
  standalone: true,
  imports: [MatTabsModule, MatButtonModule, MatIconModule, RouterModule],
  template: `
    <div class="flex flex-col h-screen">
      <mat-toolbar color="primary" class="flex-none">
        <span>{{ title }}</span>
      </mat-toolbar>

      <mat-tab-group class="flex-1 overflow-hidden" animationDuration="200ms">
        @for (tab of tabs; track tab.label) {
          <mat-tab [label]="tab.label">
            <div class="p-4 overflow-auto" style="height: calc(100vh - 160px)">
              <router-outlet *ngIf="tab.active"></router-outlet>
            </div>
          </mat-tab>
        }
      </mat-tab-group>

      <!-- FAB fixo para ação primária -->
      <button mat-fab color="accent"
              class="fixed bottom-6 right-6 z-20"
              (click)="onPrimaryAction()">
        <mat-icon>add</mat-icon>
      </button>
    </div>
  `
})
export class TabsFabLayoutComponent {
  title = 'App';
  tabs = [{ label: 'Recentes', active: true }, { label: 'Todos' }];
  onPrimaryAction() { /* abrir dialog ou navegar */ }
}
```

**Prós:** Ação principal sempre visível (FAB), tabs intuitivas
**Contras:** FAB pode sobrepor conteúdo — cuidado com scroll
