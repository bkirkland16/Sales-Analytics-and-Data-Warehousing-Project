-- Product Dashboard Top Gross Profit Product Verification
-- Years: 2012–2013
-- Expectation: Match Tableau dashboard source metrics

With product_yearly_gp As (
    Select
        Year(fs.order_date) As sales_year,
        dp.product_key,
        dp.product_name,
        Sum(fs.sales_amount - (dp.cost * fs.quantity)) As gross_profit
    From gold.fact_sales As fs
    Left Join gold.dim_products As dp
        On fs.product_key = dp.product_key
    Where Year(fs.order_date) Between 2011 And 2013
    Group By Year(fs.order_date), dp.product_key, dp.product_name),
prior_year As (
    Select
        *,
        Lag(gross_profit) Over (Partition By product_key Order By sales_year) As prior_gross_profit,
        Lag(sales_year) Over (Partition By product_key Order By sales_year) As prior_sales_year
    From product_yearly_gp)
Select
    sales_year,
    product_key,
    product_name,
    Round(gross_profit - prior_gross_profit,2) As gross_profit_change
From prior_year
Where sales_year In (2012, 2013)
    And prior_sales_year = sales_year - 1
Order By sales_year, gross_profit_change Desc;

-- Product Dashboard Product Mix Shift Verification
-- Years: 2011–2013
-- Expectation: Match Tableau dashboard source metrics

With product_line_revenue As (
    Select
        Year(fs.order_date) As sales_year,
        dp.product_line,
        Sum(fs.sales_amount) As revenue
    From gold.fact_sales As fs
    Inner Join gold.dim_products As dp
        On fs.product_key = dp.product_key
    Where Year(fs.order_date) Between 2011 And 2013
    Group By Year(fs.order_date), dp.product_line),
revenue_share As (
    Select
        sales_year,
        product_line,
        revenue,
        Round(revenue * 100.0 / NullIf(SUM(revenue) Over (Partition By sales_year),0),2) As revenue_share_pct
    From product_line_revenue)
Select
    sales_year,
    product_line,
    revenue,
    revenue_share_pct,
    Round(revenue_share_pct -Lag(revenue_share_pct) Over (Partition By product_line Order By sales_year),2) As yoy_share_change_pp
From revenue_share
Order By sales_year, product_line;

-- Product Dashboard Unit Growth Verification
-- Years: 2011–2013
-- Expectation: Match Tableau dashboard source metrics

With annual_units As (
    Select
        Year(fs.order_date) As sales_year,
        Sum(fs.quantity) As units_sold
    From gold.fact_sales As fs
    Where Year(fs.order_date) Between 2011 And 2013
    Group By Year(fs.order_date)),
prior_year As (
    Select
        *,
        Lag(units_sold) Over (Order By sales_year) As prior_units_sold
    From annual_units)
Select
    sales_year,
    units_sold,
    prior_units_sold,
    Round((units_sold - prior_units_sold) * 100.0 / NullIf(prior_units_sold,0),2) As unit_growth_yoy_pct
From prior_year
Where sales_year In (2012, 2013)
Order By sales_year;

-- Product Dashboard Revenue Change by Product Status Verification
-- Years: 2011–2013
-- Expectation: Match Tableau dashboard source metrics

With product_yearly As (
    Select
        Year(fs.order_date) As sales_year,
        fs.product_key,
        Sum(fs.sales_amount) As revenue
    From gold.fact_sales As fs
    Where Year(fs.order_date) Between 2011 And 2013
    Group By Year(fs.order_date), fs.product_key),
comparison_years As (
    Select 2012 As sales_year
    Union All
    Select 2013),
products As (
    Select Distinct product_key
    From product_yearly),
product_comparison As (
    Select
        cy.sales_year,
        p.product_key,
        Case
            When prev.product_key Is Null Then 'New-to-sales'
            When curr.product_key Is Null Then 'No-current-sales'
            Else 'Continuing'
        End As product_status,
        Coalesce(prev.revenue,0) As prior_revenue,
        Coalesce(curr.revenue,0) As current_revenue
    From products As p
    Cross Join comparison_years As cy
    Left Join product_yearly As prev
        On p.product_key = prev.product_key
        And prev.sales_year = cy.sales_year - 1
    Left Join product_yearly As curr
        On p.product_key = curr.product_key
        And curr.sales_year = cy.sales_year
    Where prev.product_key Is Not Null
        Or curr.product_key Is Not Null)
Select
    sales_year,
    product_status,
    Count(Distinct product_key) As product_count,
    Sum(prior_revenue) As prior_revenue,
    Sum(current_revenue) As current_revenue,
    Sum(current_revenue - prior_revenue) As revenue_change
From product_comparison
Group By sales_year, product_status
Order By sales_year, product_status;
