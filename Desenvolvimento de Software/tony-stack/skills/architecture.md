# Skill: Arquitetura

## Camadas Obrigatórias

```
Solution/
├── src/
│   ├── Domain/          # Entidades, Value Objects, Interfaces, Eventos
│   ├── Application/     # Use Cases, Commands, Queries, DTOs, Handlers
│   ├── Infrastructure/  # Repositórios, EF Core, Serviços externos
│   └── Presentation/    # Controllers, Middlewares, Filters
└── tests/
    ├── Unit/
    └── Integration/
```

## Padrões Recomendados

### Repository + Unit of Work
```csharp
public interface IRepository<T> where T : Entity
{
    Task<T?> GetByIdAsync(Guid id);
    Task<IEnumerable<T>> GetAllAsync();
    void Add(T entity);
    void Update(T entity);
    void Remove(T entity);
}

public interface IUnitOfWork : IDisposable
{
    Task<int> CommitAsync();
}
```

### CQRS com MediatR
```csharp
// Command
public record CreateOrderCommand(Guid CustomerId, List<OrderItemDto> Items) : IRequest<Guid>;

// Handler
public class CreateOrderCommandHandler : IRequestHandler<CreateOrderCommand, Guid>
{
    public async Task<Guid> Handle(CreateOrderCommand request, CancellationToken ct)
    {
        // lógica de domínio aqui
    }
}
```

### Dependency Injection (Program.cs)
```csharp
builder.Services.AddScoped<IOrderRepository, OrderRepository>();
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(CreateOrderCommand).Assembly));
```

## Regras de Dependência

- Domain **não depende** de nenhuma outra camada
- Application depende **apenas** de Domain
- Infrastructure depende de Application e Domain
- Presentation depende de Application

## Checklist de Arquitetura

- [ ] Entidades com identidade e invariantes protegidas
- [ ] Use Cases isolados por responsabilidade (SRP)
- [ ] Interfaces definidas no Domain/Application
- [ ] Implementações na Infrastructure
- [ ] Zero lógica de negócio nos Controllers
