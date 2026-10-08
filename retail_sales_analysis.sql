-- STEP 1: VERIFY DATA

SELECT *
FROM retail_sales_dataset
LIMIT 10;


-- STEP 2: TOTAL RECORDS

SELECT
    COUNT(*) AS total_records
FROM retail_sales_dataset;


-- STEP 3: TOTAL SALES PER PRODUCT

SELECT
    product_id,
    product_name,
    SUM(sales_amount) AS total_sales
FROM retail_sales_dataset
GROUP BY product_id, product_name
ORDER BY total_sales DESC;


-- STEP 4: TOTAL SALES PER CATEGORY

SELECT
    category,
    SUM(sales_amount) AS total_sales
FROM retail_sales_dataset
GROUP BY category
ORDER BY total_sales DESC;


-- STEP 5: TOP 5 CUSTOMERS BY TOTAL PURCHASE

SELECT
    customer_id,
    SUM(sales_amount) AS total_purchase
FROM retail_sales_dataset
GROUP BY customer_id
ORDER BY total_purchase DESC
LIMIT 5;


-- STEP 6: MONTHLY SALES TREND

SELECT
    YEAR(transaction_date) AS sales_year,
    MONTH(transaction_date) AS sales_month,
    SUM(sales_amount) AS total_sales
FROM retail_sales_dataset
GROUP BY YEAR(transaction_date), MONTH(transaction_date)
ORDER BY sales_year, sales_month;


-- STEP 7: AVERAGE TRANSACTION VALUE USING SUBQUERY

SELECT
    ROUND(AVG(transaction_total), 2) AS average_transaction_value
FROM
(
    SELECT
        transaction_id,
        SUM(sales_amount) AS transaction_total
    FROM retail_sales_dataset
    GROUP BY transaction_id
) AS transaction_summary;


-- STEP 8: HAVING CLAUSE
-- Products with total sales greater than 500000

SELECT
    product_id,
    product_name,
    SUM(sales_amount) AS total_sales
FROM retail_sales_dataset
GROUP BY product_id, product_name
HAVING SUM(sales_amount) > 500000
ORDER BY total_sales DESC;


-- STEP 9: CREATE CUSTOMER TABLE FOR JOIN

DROP TABLE IF EXISTS customers;

CREATE TABLE customers AS
SELECT DISTINCT
    customer_id
FROM retail_sales_dataset;


-- STEP 10: INNER JOIN
-- Display customers with their sales

SELECT
    c.customer_id,
    r.product_name,
    r.sales_amount
FROM customers c
INNER JOIN retail_sales_dataset r
    ON c.customer_id = r.customer_id
LIMIT 10;


-- STEP 11: CUSTOMER-WISE TOTAL SALES 

SELECT
    customer_id,
    SUM(sales_amount) AS total_sales
FROM retail_sales_dataset
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 10;


-- STEP 12: LEFT JOIN
-- Display all customers with their transactions

SELECT
    c.customer_id,
    r.transaction_id,
    r.product_name,
    r.sales_amount
FROM customers c
LEFT JOIN retail_sales_dataset r
    ON c.customer_id = r.customer_id
LIMIT 10;


-- STEP 13: CUSTOMERS WITHOUT TRANSACTIONS

SELECT
    c.customer_id
FROM
    (SELECT DISTINCT customer_id FROM retail_sales_dataset LIMIT 1000) c
LEFT JOIN retail_sales_dataset r
    ON c.customer_id = r.customer_id
WHERE r.transaction_id IS NULL;


-- STEP 14: TOTAL NUMBER OF TRANSACTIONS PER CUSTOMER

SELECT
    customer_id,
    COUNT(transaction_id) AS total_transactions
FROM retail_sales_dataset
GROUP BY customer_id
ORDER BY total_transactions DESC
LIMIT 10;


-- STEP 15: REGION-WISE SALES

SELECT
    region,
    SUM(sales_amount) AS total_sales
FROM retail_sales_dataset
GROUP BY region
ORDER BY total_sales DESC;


-- STEP 16: OVERALL SALES SUMMARY

SELECT
    COUNT(DISTINCT transaction_id) AS total_transactions,
    SUM(quantity) AS total_items_sold,
    SUM(sales_amount) AS total_revenue,
    ROUND(AVG(sales_amount), 2) AS average_transaction_sales
FROM retail_sales_dataset;

