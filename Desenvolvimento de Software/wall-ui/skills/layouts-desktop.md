# Skill: Layouts Desktop (3 Variações Obrigatórias)

## Breakpoints Desktop

```
xl:   1280px → desktop padrão
2xl:  1536px → fullHD
3xl:  1920px → widescreen (customizado no Tailwind)
```

---

## Variação 1 — Sistema Administrativo Tradicional

**Ideal para:** Back-office, painéis de gestão, sistemas internos

```typescript
@Component({
  selector: 'app-admin-layout',
  standalone: true,
  template: `
    <div class="flex h-screen bg-background">
      <!-- Sidebar larga com agrupamento -->
      <aside class="w-72 bg-gray-900 text-white flex flex-col flex-none">
        <div class="p-5 border-b border-gray-700">
          <h1 class="font-bold text-xl">Admin Panel</h1>
          <p class="text-gray-400 text-sm">{{ user().name }}</p>
        </div>

        <nav class="flex-1 overflow-y-auto py-4">
          @for (group of navGroups; track group.label) {
            <div class="mb-4">
              <p class="px-4 py-1 text-xs font-semibold text-gray-500 uppercase tracking-wider">
                {{ group.label }}
              </p>
              @for (item of group.items; track item.route) {
                <a [routerLink]="item.route" routerLinkActive="bg-gray-700 text-white"
                   class="flex items-center gap-3 px-4 py-2.5 text-gray-300 hover:bg-gray-800 transition-colors">
                  <mat-icon class="text-lg">{{ item.icon }}</mat-icon>
                  <span class="text-sm">{{ item.label }}</span>
                  @if (item.badge) {
                    <span class="ml-auto bg-primary text-white text-xs rounded-full px-2 py-0.5">
                      {{ item.badge }}
                    </span>
                  }
                </a>
              }
            </div>
          }
        </nav>
      </aside>

      <!-- Área principal -->
      <div class="flex flex-col flex-1 overflow-hidden">
        <header class="bg-surface border-b border-border h-14 flex items-center px-6 gap-4 flex-none">
          <div class="flex-1 max-w-md">
            <mat-form-field appearance="outline" class="w-full">
              <mat-icon matPrefix>search</mat-icon>
              <input matInput placeholder="Buscar...">
            </mat-form-field>
          </div>
          <div class="ml-auto flex items-center gap-2">
            <button mat-icon-button matTooltip="Notificações">
              <mat-icon matBadge="3" matBadgeColor="warn">notifications</mat-icon>
            </button>
            <button mat-icon-button [matMenuTriggerFor]="userMenu">
              <mat-icon>account_circle</mat-icon>
            </button>
            <mat-menu #userMenu>
              <button mat-menu-item><mat-icon>person</mat-icon> Perfil</button>
              <button mat-menu-item><mat-icon>logout</mat-icon> Sair</button>
            </mat-menu>
          </div>
        </header>
        <main class="flex-1 overflow-auto p-6">
          <router-outlet></router-outlet>
        </main>
      </div>
    </div>
  `
})
export class AdminLayoutComponent {
  user = signal({ name: 'Washington Silva' });
}
```

---

## Variação 2 — Workspace Modular

**Ideal para:** Ferramentas de produtividade, dashboards analíticos, editores

```typescript
@Component({
  selector: 'app-workspace-layout',
  standalone: true,
  imports: [CdkDropListModule, MatTabsModule],
  template: `
    <div class="flex flex-col h-screen">
      <!-- Barra de menus (estilo IDE/desktop app) -->
      <header class="bg-gray-800 text-white h-10 flex items-center px-4 gap-6 flex-none text-sm">
        @for (menu of appMenus; track menu.label) {
          <button [matMenuTriggerFor]="menu.ref" class="hover:text-gray-300">
            {{ menu.label }}
          </button>
        }
        <div class="flex-1"></div>
        <span class="text-gray-400 text-xs">v2.4.1</span>
      </header>

      <div class="flex flex-1 overflow-hidden">
        <!-- Painel esquerdo (explorer/navegação) -->
        <aside class="w-64 bg-gray-50 border-r border-border flex flex-col flex-none">
          <div class="p-3 border-b border-border text-xs font-semibold text-gray-500 uppercase">
            Explorer
          </div>
          <!-- Tree view ou lista -->
          <div class="flex-1 overflow-auto p-2">
            <!-- conteúdo do painel esquerdo -->
          </div>
        </aside>

        <!-- Área de trabalho central com tabs -->
        <div class="flex flex-col flex-1 overflow-hidden">
          <mat-tab-group class="flex-1" [disableRipple]="true">
            @for (tab of openTabs(); track tab.id) {
              <mat-tab>
                <ng-template mat-tab-label>
                  <span>{{ tab.title }}</span>
                  <button mat-icon-button class="ml-1 h-4 w-4"
                          (click)="closeTab(tab.id); $event.stopPropagation()">
                    <mat-icon class="text-sm">close</mat-icon>
                  </button>
                </ng-template>
                <div class="h-full overflow-auto p-4">
                  <!-- conteúdo da tab -->
                </div>
              </mat-tab>
            }
          </mat-tab-group>
          <!-- Status bar -->
          <footer class="bg-primary text-white text-xs px-4 h-6 flex items-center gap-4 flex-none">
            <span>Pronto</span>
            <span class="ml-auto">UTF-8 · LF</span>
          </footer>
        </div>

        <!-- Painel direito (propriedades/inspetor) -->
        <aside class="w-72 bg-gray-50 border-l border-border flex-none overflow-auto">
          <div class="p-3 border-b border-border text-xs font-semibold text-gray-500 uppercase">
            Propriedades
          </div>
        </aside>
      </div>
    </div>
  `
})
export class WorkspaceLayoutComponent {
  openTabs = signal([{ id: '1', title: 'Dashboard.ts' }]);
  closeTab(id: string) { this.openTabs.update(tabs => tabs.filter(t => t.id !== id)); }
}
```

---

## Variação 3 — Interface Estilo Ferramenta Profissional

**Ideal para:** Power users, ferramentas analíticas, configuradores avançados

Recursos obrigatórios:
- CDK DragDrop para painéis reposicionáveis
- Atalhos de teclado globais
- Multi-painéis redimensionáveis
- Shortcuts exibidos no tooltip

```typescript
// Atalhos de teclado globais
@Injectable({ providedIn: 'root' })
export class ShortcutService {
  @HostListener('document:keydown', ['$event'])
  onKeydown(event: KeyboardEvent) {
    const shortcuts: Record<string, () => void> = {
      'ctrl+k': () => this.openCommandPalette(),
      'ctrl+shift+p': () => this.openCommandPalette(),
      'ctrl+b': () => this.toggleSidebar(),
      'ctrl+/': () => this.toggleHelp(),
    };
    const key = [
      event.ctrlKey && 'ctrl',
      event.shiftKey && 'shift',
      event.key.toLowerCase()
    ].filter(Boolean).join('+');
    shortcuts[key]?.();
  }
}
```

**Prós:** Máxima produtividade para power users; altamente customizável
**Contras:** Alta complexidade de implementação; onboarding mais longo
