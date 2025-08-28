/*
=======================================================================================
Quality Checks
=======================================================================================
Scrpit Purpose :
         This Script performs quality checks to validate consistency, Integrity and
         The accuracy of Gold layer. This checks insure :
         - Uniquekeness of surrogate keys in dimension tables.
         - Referential Integrity between fact and dimension table.
         - Validation of relationships in the data model for analytical purpose.
Usage :
        -Run this checks after data loading silver layer.
        -Invrestigate and resolve any discrepancies found during checks.

==========================================================================================
*/


--========================================================================================
-- Checking 'gold.dim_customers'
--========================================================================================
-- Check for uniqueness of customer_key in the 'gold.dim_customers'
-- Expectation : No Results.

SELECT 
customer_key,
COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

--========================================================================================
-- Checking 'gold.dim_products'
--========================================================================================
-- Check for uniqueness of product_key in the 'gold.dim_products'
-- Expectation : No Results.

SELECT 
product_key,
COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

--========================================================================================
-- Checking 'gold.fact_sales'
--========================================================================================
-- Check the data model connectivity between fact  and dimension tables


SELECT
*
FROM gold.fact_sales f 
     LEFT JOIN gold.dim_customers c 
ON f.customer_key = c.customer_key
     LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
     WHERE p.product_key IS NULL OR c.customer_key IS NULL;
