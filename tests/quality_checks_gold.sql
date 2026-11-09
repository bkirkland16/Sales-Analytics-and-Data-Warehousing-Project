/*
-- gold.dim_customers Data Quality Tests
*/

-- Check for Duplicates in Customer Key
-- Expectation: No Results

Select
    customer_key,
    Count(*) AS duplicate_count
From gold.dim_customers
Group By customer_key
Having Count(*) > 1;

-- Check for Null customer business identifiers
-- Know Exceptions: 1 Null customer_id from Source Data
-- Expectation: Return 1 record with null_count = 1

Select
    customer_id,
    Count(*) as null_count
From gold.dim_customers
Where customer_id Is Null
Group By customer_id
Having Count(*) >=1

-- Known Source Data Exception:
-- One customer record has a Null customer_id
-- The record is retained to preserve source data fidelity
-- It has no associated sales and is excluded from Tableau reporting

-- Check for duplicate non-NULL customer IDs
-- Expectation: No results

Select
    customer_id,
    Count(*) AS duplicate_count
From gold.dim_customers
Where customer_id Is Not Null
Group By customer_id
Having Count(*) > 1;

/*
-- gold.dim_products Data Quality Tests
*/

-- Check for Duplicates in Product Key
-- Expectation: No Results

Select
    product_key,
    Count(*) AS duplicate_count
From gold.dim_products
Group By product_key
Having Count(*) > 1;

-- Check duplicate product business identifiers
-- Expectation: No results

Select
    product_number,
    Count(*) As duplicate_count
From gold.dim_products
Group By product_number
Having Count(*) > 1 Or product_number Is Null;

/*
-- gold.fact_sales Connectivity Check
*/

-- Check Connectivity Between Dimension Views and Fact View
-- Expectation: No Results

Select * 
From gold.fact_sales As fs
Left Join gold.dim_customers As dc
On dc.customer_key = fs.customer_key
Left Join gold.dim_products As dp
On dp.product_key = fs.product_key
WHERE dp.product_key Is Null Or dc.customer_key Is Null

-- Compare Silver and Gold sales row counts
-- Expectation: Both counts should match

Select
    (Select Count(*) From silver.crm_sales_details)
        As silver_sales_rows,
    (Select Count(*) From gold.fact_sales)
        As gold_sales_rows;
