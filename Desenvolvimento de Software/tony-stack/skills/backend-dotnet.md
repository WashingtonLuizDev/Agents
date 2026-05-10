# Skill: Back-end .NET Core / C#

## Controller Pattern

```csharp
[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly IMediator _mediator;

    public OrdersController(IMediator mediator) => _mediator = mediator;

    [HttpPost]
    [ProducesResponseType(typeof(Guid), StatusCodes.Status201Created)]
    public async Task<IActionResult> Create([FromBody] CreateOrderCommand command)
    {
        var id = await _mediator.Send(command);
        return CreatedAtAction(nameof(GetById), new { id }, id);
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var result = await _mediator.Send(new GetOrderByIdQuery(id));
        return result is null ? NotFound() : Ok(result);
    }
}
```

## Entidade de Domínio

```csharp
public abstract class Entity
{
    public Guid Id { get; protected set; } = Guid.NewGuid();
    public DateTime CreatedAt { get; protected set; } = DateTime.UtcNow;
}

public class Order : Entity
{
    private readonly List<OrderItem> _items = new();

    public Guid CustomerId { get; private set; }
    public OrderStatus Status { get; private set; }
    public IReadOnlyList<OrderItem> Items => _items.AsReadOnly();

    private Order() { }

    public static Order Create(Guid customerId)
    {
        if (customerId == Guid.Empty) throw new DomainException("CustomerId inválido.");
        return new Order { CustomerId = customerId, Status = OrderStatus.Pending };
    }

    public void AddItem(Guid productId, int quantity, decimal unitPrice)
    {
        if (quantity <= 0) throw new DomainException("Quantidade deve ser positiva.");
        _items.Add(new OrderItem(productId, quantity, unitPrice));
    }
}
```

## EF Core — DbContext

```csharp
public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Order> Orders => Set<Order>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);
    }
}

public class OrderConfiguration : IEntityTypeConfiguration<Order>
{
    public void Configure(EntityTypeBuilder<Order> builder)
    {
        builder.ToTable("Orders");
        builder.HasKey(o => o.Id);
        builder.Property(o => o.Status).HasConversion<string>();
        builder.OwnsMany(o => o.Items, items =>
        {
            items.ToTable("OrderItems");
            items.WithOwner().HasForeignKey("OrderId");
        });
    }
}
```

## Teste Unitário (xUnit)

```csharp
public class OrderTests
{
    [Fact]
    public void AddItem_ValidData_ShouldAddItemToOrder()
    {
        var order = Order.Create(Guid.NewGuid());
        order.AddItem(Guid.NewGuid(), 2, 49.90m);
        Assert.Single(order.Items);
    }

    [Fact]
    public void AddItem_ZeroQuantity_ShouldThrowDomainException()
    {
        var order = Order.Create(Guid.NewGuid());
        Assert.Throws<DomainException>(() => order.AddItem(Guid.NewGuid(), 0, 49.90m));
    }
}
```

## Diretrizes

- Nunca colocar lógica de negócio no Controller
- DTOs somente na camada Application
- Validações de entrada: FluentValidation no Command/Query
- Erros de domínio: exceções customizadas + middleware global de tratamento
- Async/await em toda a cadeia de I/O
