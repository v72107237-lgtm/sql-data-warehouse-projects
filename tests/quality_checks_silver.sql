/*
====================================================================================================
QUALITY CHECKS
====================================================================================================
Script Purpose:
    This script performs various quality checks for the data consistency, accuracy, and
    standardization across the 'Silver' schema. It includes checks for
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency for related fiels.

Usage Note:
    -Run this checks after loading silver layer data.
    - Investigate and resolve any discrepancies found during checks.
=====================================================================================================
*/

--===================================================================================================
--Checking 'silver.crm_cust_info'
--===================================================================================================
   SELECT cst_id,COUNT(*) 
FROM silver.crm_cust_info 
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--Check for unwanted spaces
--Expectation:No result
SELECT cst_firstname 
FROM silver.crm_cust_info 
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname 
FROM silver.crm_cust_info 
WHERE cst_lastname != TRIM(cst_lastname);

--Data standardization & consistency
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info ;
 

SELECT * FROM silver.crm_cust_info;

--==================================================================================================
--Checking 'silver.crm_prd_info'
--===================================================================================================
--checking for no duplicates or null
--Expectation : No results

SELECT prd_id,COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id 
HAVING COUNT(*) > 1 OR prd_id IS NULL;

--Check for unwanted spaces
--Expectation:No result
SELECT prd_nm 
FROM silver.crm_prd_info 
WHERE prd_nm != TRIM(prd_nm);

--Check for Negative OR NULL
--Expectation:No result
SELECT prd_cost
FROM silver.crm_prd_info 
WHERE prd_cost <0 OR prd_cost IS NULL;

--Data standardization & consistency
SELECT DISTINCT prd_line FROM silver.crm_prd_info ;

--Check for Invalid Date Orders
SELECT * FROM silver.crm_prd_info 
WHERE prd_end_dt<prd_start_dt;

SELECT * FROM silver.crm_prd_info;

--=====================================================================================
--Checking 'silver.crm_sales_details'
--=====================================================================================

--Check for invalid date orders 

SELECT * FROM silver.crm_sales_details 
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

--Check Data Consistency : Between Sales, Quantity ,Price
-->> Sales = Quantity * Price
-->> Values must not be NULL,Zero,Negative

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_sales IS NULL OR sls_sales IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0 
ORDER BY sls_sales,sls_quantity,sls_price;

SELECT * FROM silver.crm_sales_details;

--==========================================================================================
--Checking 'silver.erp_cust_az12'
--==========================================================================================

--Quality check

SELECT 
cid
FROM silver.erp_cust_az12 
WHERE bdate > GETDATE();

SELECT DISTINCT gen FROM silver.erp_cust_az12;

--============================================================================================
--Checking 'silver.erp_loc_a101'
--============================================================================================

SELECT * FROM silver.erp_loc_a101;

SELECT DISTINCT cntry FROM silver.erp_loc_a101 order BY cntry;

--===========================================================================================
--Checking 'silver.erp_px_cat_g1v2'
--============================================================================================

SELECT * FROM silver.erp_px_cat_g1v2;

 --Check for unwanted spaces

 SELECT * FROM silver.erp_px_cat_g1v2 
 WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

 -- Data Standardization and normalization

 SELECT DISTINCT cat FROM silver.erp_px_cat_g1v2;
 SELECT DISTINCT subcat FROM silver.erp_px_cat_g1v2;
 SELECT DISTINCT maintenance FROM silver.erp_px_cat_g1v2;
