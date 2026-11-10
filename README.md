# Sales Analytics & Data Warehousing Project
*End-to-End Business Intelligence Project | SQL Server • Data Warehousing • Tableau*

## Project Overview
This project demonstrates an end-to-end business intelligence workflow, transforming raw CRM and ERP sales data into validated, business-ready datasets and interactive Tableau dashboards.

Using Microsoft SQL Server, I developed a multi-layer data warehouse to integrate, cleanse, and organize transactional data. I then used SQL and Tableau to analyze financial performance, customer purchasing behavior, product profitability, and year-over-year sales trends.

The project delivers two complementary dashboards:

- **Executive Dashboard:** High-level sales, profitability, and operational performance.
- **Product Performance Dashboard:** Product level profitability, revenue mix, gross profit changes, and sales drivers.

**Tools:** SQL Server, SSMS, T-SQL, Tableau Public, CSV, GitHub

---
## Interactive Tableau Dashboards

**[Explore the dashboards on Tableau Public](https://public.tableau.com/app/profile/brendan.kirkland/viz/RetailSalesProductProfitability/ExecutiveDashboard)**

### Executive Dashboard
![Executive Dashboard](tableau/Executive%20Dashboard%20Retail%20Sales%20%26%20Product%20Profitability.png)

The Executive Dashboard provides a high-level view of business performance for rapid assessment of financial results, operational efficiency, and sales trends.

**Key features:**

- Revenue, gross profit, and gross profit margin with year-over-year comparisons
- Average order value, total orders, and on time shipping rate
- Monthly revenue and gross profit trends
- Top products by revenue and geographic sales performance
- Filters for sales year, country, product line, and customer age group
- Company-wide executive insights and recommended actions

### Product Performance Dashboard
![Product Performance Dashboard](tableau/Product%20Dashboard%20Retail%20Sales%20%26%20Product%20Profitability.png)

The Product Performance Dashboard investigates product profitability and year-over-year performance to identify revenue drivers and opportunities for improvement.

Key features:

- Product with the largest year-over-year gross profit increase
- Product line revenue mix shifts and unit growth
- Revenue and gross profit comparisons by product line
- Largest product level gross profit gains and declines
- Revenue changes from continuing, new to sales, and no current sales products
- Dynamic insights and recommendations for the selected sales year

[View or download the Tableau packaged workbook (.twbx)](tableau/Retail%20Sales%20%26%20Product%20Profitability.twbx)

---
## Key Business Insights
Analysis focuses on complete sales years from 2011 through 2013, comparing 2012 against 2011 and 2013 against 2012.

### 2012 — Product Performance Challenges

- Products with no current year sales accounted for approximately **$6.85M** in lost revenue, outweighing gains from continuing and new to sales products.
- Mountain products gained approximately **19.92** percentage points in revenue share, highlighting a shift in product mix.
- Lost Road-150 sales raised questions about product replacements, inventory strategy, and profitability.

**Recommended action:** Investigate lost Road-150 sales and prioritize higher margin products to offset declining Road revenue.

### 2013 — Revenue and Profitability Recovery

- Revenue increased approximately **179.77%** year over year, reaching **$16.34M**.
- Gross profit increased approximately **228.83%**, reaching **$6.76M**.
- Average order value declined approximately **57.04%**, making purchasing behavior and product mix important areas to monitor.
- Mountain and Touring performance highlighted opportunities for targeted inventory and sales support.

**Recommended action:** Prioritize high performing Mountain and Touring products while monitoring gross margins and revenue per order.


*These recommendations summarize company-wide results. The interactive dashboards also support filtered exploration by customer, product, and geography.*

---
## Data Warehouse Architecture
The SQL Server data warehouse uses a Bronze – Silver – Gold layered architecture.

![Data Warehouse Architecture](docs/data_architecture.png)

### Bronze — Raw Data Ingestion

- Import CRM and ERP CSV source files into SQL Server.
- Preserve raw source structure for downstream processing.
- Use stored procedures for repeatable data loads.

### Silver — Cleansing and Transformation

- Standardize categorical values and formats.
- Validate dates, identifiers, and numerical fields.
- Resolve inconsistent records and apply business rules.
- Prepare cleaned data for dimensional modeling.

### Gold — Business Ready Data

The Gold layer exposes a star schema through three core SQL views:

| View | Purpose |
|---|---|
| `gold.fact_sales`| Sales transactions, amounts, quantities, and dates |
| `gold.dim_customers` | Customer attributes and geography |
| `gold.dim_products` | Product attributes, categories, costs, and product lines |

Surrogate **product and customer keys** connect the fact view to the dimensions.

![Gold Layer Data Model](docs/data_model.png)

See the [Gold layer data catalog](docs/data_catalog.md) for field definitions and relationships.

---
## Data Pipeline
### CRM & ERP CSVs → Bronze → Silver → Gold → Tableau

1. **Extract:** Load CRM and ERP source datasets into SQL Server.
2. **Transform:** Clean and standardize records using T-SQL.
3. **Model:** Integrate transactional and descriptive data into a star schema.
4. **Validate:** Reconcile data quality and analytical measures with SQL checks.
5. **Visualize:** Export Gold layer data as CSVs for Tableau Public dashboards.
6. **Communicate:** Translate findings into executive insights and recommendations.

**Additional diagrams:** [Data Flow](docs/data_flow.png) | [Data Integration](docs/data_integration.png)

---
## Data Quality & Validation

Validation activities include:

- Checking for duplicate customer and product identifiers
- Identifying missing or invalid values
- Validating transformations between warehouse layers
- Checking relationships between fact and dimension views
- Reconciling Tableau measures against SQL results
- Verifying revenue, gross profit, order counts, and year-over-year product calculations

### Data Warehouse Quality Checks

- [Silver quality checks](tests/sql%20tests/quality_checks_silver.sql)
- [Gold quality checks](tests/sql%20tests/quality_checks_gold.sql)

### Tableau Metric Verfication

- [Executive Dashboard Tests](tests/tableau%20metric%20tests/executive_dashboard_tests.sql)
- [Product Dashboard Tests](tests/tableau%20metric%20tests/product_dashboard_tests.sql)

---
## Tableau & SQL Techniques

### Tableau

- KPI calculations and parameter driven year-over-year comparisons
- Level of Detail (LOD) calculations
- Dynamic product rankings using table calculations
- Interactive filters and conditional formatting
- Dynamic executive insights and recommendations

### SQL

- ETL stored procedures and error handling
- Joins, CTEs, and window functions
- Conditional transformations and aggregation
- Dimensional modeling and star schema development
- Data quality validation and reconciliation

---
## Repository Structure
```text
Sales-Analytics-and-Data-Warehousing-Project/
├── datasets/
│   ├── SQL datasets/
│   │   ├── CRM/
│   │   └── ERP/
│   └── Tableau datasets/
├── docs/
│   ├── data_architecture.png
│   ├── data_flow.png
│   ├── data_integration.png
│   ├── data_model.png
│   ├── data_catalog.md
│   └── naming_conventions.md
├── scripts/
│   ├── bronze/
│   │   ├── ddl_bronze.sql
│   │   └── proc_load_bronze.sql
│   ├── silver/
│   │   ├── ddl_silver.sql
│   │   ├── all_proc_load_silver.sql
│   │   └── [Individual transformation scripts]
│   ├── gold/
│   │   └── ddl_gold.sql
│   └── init_database.sql
├── tableau/
│   ├── Executive Dashboard Retail Sales & Product Profitability.png
│   ├── Product Dashboard Retail Sales & Product Profitability.png
│   └── Retail Sales & Product Profitability.twbx
├── tests/
│   ├── sql tests/
│   │   ├── quality_checks_gold.sql
│   │   └── quality_checks_silver.sql
│   └── tableau metric tests/
│       ├── executive_dashboard_tests.sql
│       └── product_dashboard_tests.sql
├── LICENSE
└── README.md
```

## Project Resources

| Resource | Description |
|---|---|
| [SQL Scripts](scripts/) | SQL Server initialization, Bronze and Silver ETL procedures, and Gold layer views |
| [CRM & ERP Source Datasets](datasets/SQL%20datasets/) | Original CSV datasets used to populate the data warehouse |
| [Tableau Datasets](datasets/Tableau%20datasets/) | Gold layer CSV exports used in Tableau |
| [Tableau Workbook & Screenshots](tableau/) | Packaged workbook and both dashboard screenshots |
| [Data Architecture](docs/data_architecture.png) | Bronze, Silver, and Gold architecture diagram |
| [Data Flow](docs/data_flow.png) | Data movement through the warehouse |
| [Data Integration](docs/data_integration.png) | Source integration diagram |
| [Data Model](docs/data_model.png) | Gold layer star schema |
| [Data Catalog](docs/data_catalog.md) | Field definitions and relationships |
| [Naming Conventions](docs/naming_conventions.md) | SQL naming standards |
| [Data Quality Tests](tests/) | Silver and Gold layer validation scripts |

---
## Skills Demonstrated

- **Data engineering:** ETL, integration, transformation, and data quality
- **Data modeling:** Star schemas, fact and dimension views, and surrogate keys
- **SQL analytics:** CTEs, window functions, aggregation, and validation
- **Business intelligence:** Tableau dashboards, KPIs, and interactive reporting
- **Business analysis:** Revenue drivers, profitability analysis, and recommendations
- **Documentation:** Data catalogs, architecture diagrams, and project organization

---
## License

This project is licensed under the [MIT License](LICENSE).
