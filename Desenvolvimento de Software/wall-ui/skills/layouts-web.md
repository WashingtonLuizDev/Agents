# Skill: Layouts Web (3 Variações Obrigatórias)

## Breakpoints Web

```
md: 768px   → tablet/web estreito
lg: 1024px  → web padrão
xl: 1280px  → web largo
2xl: 1536px → fullHD
```

---

## Variação 1 — Sidebar Fixa

**Ideal para:** Sistemas administrativos, painéis internos

```typescript
@Component({
  selector: 'app-sidebar-fixed-layout',
  standalone: true,
  imports: [MatSidenavModule, MatToolbarModule, MatListModule, RouterModule],
  template: `
    <mat-sidenav-container class="h-screen">
      <mat-sidenav mode="side" opened class="w-64 border-r border-border">
        <!-- Logo -->
        <div class="flex items-center gap-3 p-4 border-b border-border">
          <img src="assets/logo.svg" class="h-8 w-8" alt="logo">
          <span class="font-semibold text-lg">Sistema</span>
        </div>

        <!-- Nav -->
        <mat-nav-list>
          @for (item of navItems; track item.route) {
            <a mat-list-item [routerLink]="item.route" routerLinkActive="bg-primary/10 text-primary">
              <mat-icon matListItemIcon>{{ item.icon }}</mat-icon>
              <span matListItemTitle>{{ item.label }}</span>
            </a>
          }
        </mat-nav-list>
      </mat-sidenav>

      <mat-sidenav-content>
        <mat-toolbar class="border-b border-border bg-surface">
          <span class="flex-1">{{ pageTitle() }}</span>
          <button mat-icon-button><mat-icon>notifications</mat-icon></button>
          <button mat-icon-button><mat-icon>account_circle</mat-icon></button>
        </mat-toolbar>
        <main class="p-6">
          <router-outlet></router-outlet>
        </main>
      </mat-sidenav-content>
    </mat-sidenav-container>
  `
})
export class SidebarFixedLayoutComponent {
  pageTitle = signal('Dashboard');
  navItems = [
    { route: '/dashboard', icon: 'dashboard', label: 'Dashboard' },
    { route: '/orders', icon: 'shopping_cart', label: 'Pedidos' },
    { route: '/users', icon: 'group', label: 'Usuários' },
    { route: '/reports', icon: 'bar_chart', label: 'Relatórios' }
  ];
}
```

**Prós:** Navegação sempre visível, familiar para sistemas internos
**Contras:** Ocupa espaço horizontal — menos eficiente em telas pequenas

---

## Variação 2 — Topbar + Conteúdo Centralizado

**Ideal para:** Portais, produtos SaaS voltados a usuário final

```typescript
@Component({
  selector: 'app-topbar-layout',
  standalone: true,
  template: `
    <div class="flex flex-col min-h-screen bg-background">
      <!-- Topbar -->
      <header class="sticky top-0 z-50 bg-surface border-b border-border shadow-sm">
        <div class="max-w-7xl mx-auto px-6 h-16 flex items-center gap-6">
          <img src="assets/logo.svg" class="h-8" alt="logo">
          <nav class="flex gap-1">
            @for (item of navItems; track item.route) {
              <a [routerLink]="item.route" routerLinkActive="text-primary font-medium"
                 class="px-3 py-2 rounded-md text-sm hover:bg-gray-100 transition-colors">
                {{ item.label }}
              </a>
            }
          </nav>
          <div class="ml-auto flex items-center gap-2">
            <button mat-stroked-button>Entrar</button>
            <button mat-flat-button color="primary">Começar</button>
          </div>
        </div>
      </header>

      <!-- Conteúdo centralizado -->
      <main class="flex-1 max-w-7xl mx-auto w-full px-6 py-8">
        <router-outlet></router-outlet>
      </main>

      <footer class="bg-surface border-t border-border py-6 text-center text-sm text-gray-500">
        © 2025 Sistema. Todos os direitos reservados.
      </footer>
    </div>
  `
})
export class TopbarLayoutComponent {
  navItems = [
    { route: '/features', label: 'Funcionalidades' },
    { route: '/pricing', label: 'Preços' },
    { route: '/docs', label: 'Docs' }
  ];
}
```

**Prós:** Clean, moderno, sem distrações; ótimo para onboarding
**Contras:** Menos eficiente para sistemas com muitos itens de menu

---

## Variação 3 — Layout Híbrido Corporativo

**Ideal para:** ERPs, sistemas com muitas funcionalidades + dashboards complexos

```typescript
@Component({
  selector: 'app-hybrid-layout',
  standalone: true,
  template: `
    <div class="flex flex-col h-screen">
      <!-- Topbar primária -->
      <mat-toolbar color="primary" class="flex-none z-50">
        <button mat-icon-button (click)="toggleSidebar()">
          <mat-icon>{{ sidebarOpen() ? 'menu_open' : 'menu' }}</mat-icon>
        </button>
        <span class="ml-2">ERP Sistema</span>
        <div class="flex-1"></div>
        <!-- Módulos principais na topbar -->
        @for (mod of modules; track mod.label) {
          <button mat-button [routerLink]="mod.route" class="text-white">
            {{ mod.label }}
          </button>
        }
        <button mat-icon-button><mat-icon>search</mat-icon></button>
        <button mat-icon-button><mat-icon>notifications</mat-icon></button>
      </mat-toolbar>

      <div class="flex flex-1 overflow-hidden">
        <!-- Sidebar contextual (recolhível) -->
        <aside [class.w-56]="sidebarOpen()" [class.w-0]="!sidebarOpen()"
               class="transition-all duration-200 overflow-hidden bg-surface border-r border-border">
          <mat-nav-list dense>
            @for (item of contextualNav(); track item.route) {
              <a mat-list-item [routerLink]="item.route" routerLinkActive="active-nav">
                <mat-icon matListItemIcon class="text-sm">{{ item.icon }}</mat-icon>
                <span matListItemTitle class="text-sm">{{ item.label }}</span>
              </a>
            }
          </mat-nav-list>
        </aside>

        <!-- Conteúdo -->
        <main class="flex-1 overflow-auto p-6">
          <router-outlet></router-outlet>
        </main>
      </div>
    </div>
  `
})
export class HybridLayoutComponent {
  sidebarOpen = signal(true);
  contextualNav = signal<NavItem[]>([]);
  modules = [
    { route: '/financial', label: 'Financeiro' },
    { route: '/inventory', label: 'Estoque' },
    { route: '/hr', label: 'RH' }
  ];
  toggleSidebar() { this.sidebarOpen.update(v => !v); }
}
```

**Prós:** Máxima densidade de informação, familiar para usuários de ERP
**Contras:** Curva de aprendizado; requer boa hierarquia de informação
