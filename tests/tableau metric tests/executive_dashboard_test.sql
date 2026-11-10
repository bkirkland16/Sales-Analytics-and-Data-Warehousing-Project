-- Executive Dashboard Metric Verification
-- Years: 2012–2013
-- Expectation: Match Tableau dashboard source metrics

With order_shipping As (
    Select
        order_number,
        Max(shipping_date) As max_shipping_date,
        Max(due_date) As due_date
    From gold.fact_sales
    Group By order_number)
Select
    Year(fs.order_date) As sales_year,
    Sum(fs.sales_amount) As revenue,
    Sum(fs.sales_amount - (dp.cost * fs.quantity)) As gross_profit,
    Round(Sum(fs.sales_amount - (dp.cost * fs.quantity)) * 100.0 / NullIf(Sum(fs.sales_amount),0),2) As gross_margin_pct,
    Round(Sum(fs.sales_amount) * 1.0 / NULLIF(COUNT(DISTINCT fs.order_number),0),2) AS average_order_value,
    Count(Distinct fs.order_number) As total_orders,
    Round(Count(Distinct
        Case
            When os.max_shipping_date Is Not Null
                And os.due_date Is Not Null
                And os.max_shipping_date <= os.due_date
            Then fs.order_number
        End) * 100.0 / NullIf(Count(Distinct
        Case
            When os.max_shipping_date Is Not Null
                And os.due_date Is Not Null
            Then fs.order_number
        End),0),2) As on_time_shipping_pct
From gold.fact_sales As fs
Left Join gold.dim_products As dp
    On fs.product_key = dp.product_key
Left Join order_shipping As os
    On fs.order_number = os.order_number
Where Year(fs.order_date) Between 2012 And 2013
Group By Year(fs.order_date)
Order By sales_year;

-- Executive Dashboard YoY % Verification
-- Years: 2012-2013
-- Expectation: Match Tableau dashboard source metrics

With annual_metrics As (
    Select
        Year(fs.order_date) As sales_year,
        Sum(fs.sales_amount) As revenue,
        Sum(fs.sales_amount - (dp.cost * fs.quantity)) As gross_profit,
        Sum(fs.sales_amount - (dp.cost * fs.quantity)) * 100.0 / NullIf(Sum(fs.sales_amount),0) As gross_margin_pct,
        Sum(fs.sales_amount) * 1.0 / NullIf(Count(Distinct fs.order_number),0) As average_order_value,
        Count(Distinct fs.order_number) As total_orders
    From gold.fact_sales As fs
    Left Join gold.dim_products As dp
        On fs.product_key = dp.product_key
    Where Year(fs.order_date) Between 2011 And 2013
    Group By Year(fs.order_date)),
prior_year As (
    Select
        *,
        Lag(revenue) Over (Order By sales_year) As prior_revenue,
        Lag(gross_profit) Over (Order By sales_year) As prior_gp,
        Lag(gross_margin_pct) Over (Order By sales_year) As prior_gross_margin_pct,
        Lag(average_order_value) Over (Order By sales_year) As prior_aov,
        Lag(total_orders) Over (Order By sales_year) As prior_total_orders
    From annual_metrics)
Select
    sales_year,
    Round((revenue - prior_revenue) * 100.0 / NullIf(prior_revenue,0),2) As revenue_yoy_pct,
    Round((gross_profit - prior_gp) * 100.0 / NullIf(prior_gp,0),2) As gross_profit_yoy_pct,
    Round((gross_margin_pct - prior_gross_margin_pct) * 100.0 / NullIf(prior_gross_margin_pct,0),2) As gross_margin_yoy_pct,
    Round((average_order_value - prior_aov) * 100.0 / NullIf(prior_aov,0),2) As average_order_value_yoy_pct,
    Round((total_orders - prior_total_orders) * 100.0 / NullIf(prior_total_orders,0),2) As total_orders_yoy_pct
From prior_year
Where sales_year In (2012, 2013)
Order By sales_year;
