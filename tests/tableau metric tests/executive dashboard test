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
