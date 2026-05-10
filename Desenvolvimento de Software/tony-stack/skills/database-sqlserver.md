# Skill: Banco de Dados — SQL Server

## Modelagem de Tabelas

```sql
CREATE TABLE Customers (
    Id          UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    Name        NVARCHAR(200)    NOT NULL,
    Email       NVARCHAR(150)    NOT NULL,
    CreatedAt   DATETIME2(7)     NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Customers PRIMARY KEY (Id),
    CONSTRAINT UQ_Customers_Email UNIQUE (Email)
);

CREATE TABLE Orders (
    Id          UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    CustomerId  UNIQUEIDENTIFIER NOT NULL,
    Status      NVARCHAR(50)     NOT NULL DEFAULT 'Pending',
    CreatedAt   DATETIME2(7)     NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Orders PRIMARY KEY (Id),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
);
```

## Índices Estratégicos

```sql
-- FK sempre indexada
CREATE INDEX IX_Orders_CustomerId ON Orders (CustomerId);

-- Índice coberto para query frequente
CREATE INDEX IX_Orders_Status_CreatedAt
    ON Orders (Status, CreatedAt DESC)
    INCLUDE (CustomerId);

-- Índice filtrado (ex: apenas ativos)
CREATE INDEX IX_Customers_Active
    ON Customers (Email)
    WHERE IsDeleted = 0;
```

## Query Performática

```sql
-- Evitar SELECT *
-- Usar EXISTS em vez de COUNT para verificar existência
-- CTEs para legibilidade, não para performance

WITH RecentOrders AS (
    SELECT
        o.Id,
        o.Status,
        o.CreatedAt,
        c.Name  AS CustomerName
    FROM Orders o
    INNER JOIN Customers c ON c.Id = o.CustomerId
    WHERE o.CreatedAt >= DATEADD(DAY, -30, SYSUTCDATETIME())
)
SELECT
    Id,
    CustomerName,
    Status,
    CreatedAt
FROM RecentOrders
WHERE Status = 'Pending'
ORDER BY CreatedAt DESC
OFFSET 0 ROWS FETCH NEXT 20 ROWS ONLY;
```

## Stored Procedure

```sql
CREATE OR ALTER PROCEDURE usp_GetOrderSummary
    @CustomerId UNIQUEIDENTIFIER,
    @StartDate  DATETIME2 = NULL,
    @EndDate    DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.Id,
        o.Status,
        o.CreatedAt,
        SUM(oi.Quantity * oi.UnitPrice) AS Total
    FROM Orders o
    INNER JOIN OrderItems oi ON oi.OrderId = o.Id
    WHERE o.CustomerId = @CustomerId
      AND (@StartDate IS NULL OR o.CreatedAt >= @StartDate)
      AND (@EndDate   IS NULL OR o.CreatedAt <= @EndDate)
    GROUP BY o.Id, o.Status, o.CreatedAt
    ORDER BY o.CreatedAt DESC;
END;
```

## Diretrizes de Performance

| Problema | Solução |
|----------|---------|
| N+1 queries | JOIN ou Include no EF Core |
| SELECT * | Selecionar apenas colunas necessárias |
| FK sem índice | Criar `IX_Tabela_ForeignKey` |
| LIKE '%texto%' | Full-Text Search ou índice invertido |
| Cursor | Substituir por set-based operations |
| Implicit conversion | Garantir tipos compatíveis em joins/filtros |

## Migrations (EF Core CLI)

```bash
dotnet ef migrations add NomeDaMigration --project Infrastructure --startup-project Api
dotnet ef database update --project Infrastructure --startup-project Api
```
