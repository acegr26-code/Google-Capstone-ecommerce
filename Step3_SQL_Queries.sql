-- ============================================================
-- Google Data Analytics Capstone — Case Study 
-- Step 3: PROCESS + Step 4: ANALYZE — SQL Queries
-- Tool: BigQuery (Free Tier)
-- Dataset: Online Retail II (UCI Machine Learning Repository)
-- Analyst: George Robles
-- Date: May 2026
-- ============================================================


-- ============================================================
-- SECTION 1: DATA EXPLORATION
-- ============================================================

-- 1.1 Total number of rows
SELECT COUNT(*) AS total_rows
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`;


-- 1.2 Date range of the data
SELECT
  MIN(InvoiceDate) AS earliest_date,
  MAX(InvoiceDate) AS latest_date
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`;


-- 1.3 Count of unique customers, products, countries
SELECT
  COUNT(DISTINCT CustomerID) AS unique_customers,
  COUNT(DISTINCT StockCode)  AS unique_products,
  COUNT(DISTINCT Country)    AS unique_countries,
  COUNT(DISTINCT InvoiceNo)  AS unique_invoices
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`;


-- 1.4 Check for missing CustomerIDs
SELECT
  COUNTIF(CustomerID IS NULL) AS missing_customer_ids,
  COUNTIF(CustomerID IS NOT NULL) AS present_customer_ids,
  ROUND(COUNTIF(CustomerID IS NULL) / COUNT(*) * 100, 2) AS pct_missing
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`;


-- 1.5 Summary statistics on Quantity and UnitPrice
SELECT
  ROUND(AVG(Quantity), 2)    AS avg_quantity,
  MIN(Quantity)               AS min_quantity,
  MAX(Quantity)               AS max_quantity,
  ROUND(AVG(UnitPrice), 2)   AS avg_unit_price,
  MIN(UnitPrice)              AS min_unit_price,
  MAX(UnitPrice)              AS max_unit_price
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0 AND UnitPrice > 0;


-- ============================================================
-- SECTION 2: REVENUE ANALYSIS
-- ============================================================

-- 2.1 Total overall revenue
SELECT
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0 AND UnitPrice > 0;


-- 2.2 Monthly revenue trend
SELECT
  FORMAT_DATE('%Y-%m', DATE(InvoiceDate)) AS month,
  ROUND(SUM(Quantity * UnitPrice), 2)     AS monthly_revenue,
  COUNT(DISTINCT InvoiceNo)               AS total_orders
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0 AND UnitPrice > 0
GROUP BY month
ORDER BY month ASC;


-- 2.3 Revenue by country (Top 10)
SELECT
  Country,
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue,
  COUNT(DISTINCT CustomerID)           AS unique_customers,
  COUNT(DISTINCT InvoiceNo)            AS total_orders
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0 AND UnitPrice > 0
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 10;


-- 2.4 Average order value
SELECT
  ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
  SELECT
    InvoiceNo,
    SUM(Quantity * UnitPrice) AS order_total
  FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
  WHERE Quantity > 0 AND UnitPrice > 0
  GROUP BY InvoiceNo
);


-- ============================================================
-- SECTION 3: PRODUCT ANALYSIS
-- ============================================================

-- 3.1 Top 10 best-selling products by units sold
SELECT
  StockCode,
  Description,
  SUM(Quantity)                         AS units_sold,
  ROUND(SUM(Quantity * UnitPrice), 2)   AS total_revenue
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0 AND UnitPrice > 0
  AND Description NOT IN ('Manual','DOTCOM POSTAGE','POSTAGE','Adjust bad debt','AMAZONFEE')
GROUP BY StockCode, Description
ORDER BY units_sold DESC
LIMIT 10;


-- 3.2 Top 10 products by revenue generated
SELECT
  StockCode,
  Description,
  ROUND(SUM(Quantity * UnitPrice), 2)  AS total_revenue,
  SUM(Quantity)                         AS units_sold
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0 AND UnitPrice > 0
  AND Description NOT IN ('Manual','DOTCOM POSTAGE','POSTAGE','Adjust bad debt','AMAZONFEE')
GROUP BY StockCode, Description
ORDER BY total_revenue DESC
LIMIT 10;


-- 3.3 Most returned/cancelled products
SELECT
  Description,
  ABS(SUM(Quantity)) AS total_returned,
  COUNT(*)           AS return_transactions
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity < 0
GROUP BY Description
ORDER BY total_returned DESC
LIMIT 10;


-- ============================================================
-- SECTION 4: CUSTOMER BEHAVIOR ANALYSIS
-- ============================================================

-- 4.1 Top 10 customers by total spend
SELECT
  CustomerID,
  Country,
  COUNT(DISTINCT InvoiceNo)             AS total_orders,
  SUM(Quantity)                          AS total_items,
  ROUND(SUM(Quantity * UnitPrice), 2)   AS total_spent
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0
  AND UnitPrice > 0
  AND CustomerID IS NOT NULL
GROUP BY CustomerID, Country
ORDER BY total_spent DESC
LIMIT 10;


-- 4.2 One-time vs repeat customers
SELECT
  CASE
    WHEN total_orders = 1 THEN 'One-time buyer'
    WHEN total_orders BETWEEN 2 AND 5 THEN 'Occasional buyer (2-5 orders)'
    WHEN total_orders > 5 THEN 'Loyal customer (5+ orders)'
  END AS customer_segment,
  COUNT(*) AS number_of_customers,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM (
  SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders
  FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
  WHERE CustomerID IS NOT NULL
  GROUP BY CustomerID
)
GROUP BY customer_segment
ORDER BY number_of_customers DESC;


-- ============================================================
-- SECTION 5: TIME-BASED PATTERNS
-- ============================================================

-- 5.1 Sales by day of the week
SELECT
  FORMAT_DATE('%A', DATE(InvoiceDate)) AS day_of_week,
  COUNT(DISTINCT InvoiceNo)             AS total_orders,
  ROUND(SUM(Quantity * UnitPrice), 2)  AS total_revenue
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0 AND UnitPrice > 0
GROUP BY day_of_week
ORDER BY total_revenue DESC;


-- 5.2 Sales by hour of day
SELECT
  EXTRACT(HOUR FROM InvoiceDate) AS hour_of_day,
  COUNT(DISTINCT InvoiceNo)      AS total_orders,
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0 AND UnitPrice > 0
GROUP BY hour_of_day
ORDER BY hour_of_day ASC;


-- 5.3 Best performing months
SELECT
  FORMAT_DATE('%B', DATE(InvoiceDate)) AS month_name,
  EXTRACT(MONTH FROM InvoiceDate)       AS month_number,
  ROUND(SUM(Quantity * UnitPrice), 2)  AS total_revenue,
  COUNT(DISTINCT InvoiceNo)             AS total_orders
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0 AND UnitPrice > 0
GROUP BY month_name, month_number
ORDER BY total_revenue DESC;


-- ============================================================
-- SECTION 6: SAVE KEY RESULTS AS TABLES
-- ============================================================

-- Save monthly revenue trend
CREATE OR REPLACE TABLE `capstone-retail-analysis.retail.online_retail`.retail.monthly_revenue` AS
SELECT
  FORMAT_DATE('%Y-%m', DATE(InvoiceDate)) AS month,
  ROUND(SUM(Quantity * UnitPrice), 2)     AS monthly_revenue,
  COUNT(DISTINCT InvoiceNo)               AS total_orders
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0 AND UnitPrice > 0
GROUP BY month
ORDER BY month ASC;


-- Save customer segments
CREATE OR REPLACE TABLE `capstone-retail-analysis.retail.online_retail`.retail.customer_segments` AS
SELECT
  CustomerID,
  Country,
  COUNT(DISTINCT InvoiceNo)            AS total_orders,
  ROUND(SUM(Quantity * UnitPrice), 2)  AS total_spent,
  CASE
    WHEN COUNT(DISTINCT InvoiceNo) = 1 THEN 'One-time buyer'
    WHEN COUNT(DISTINCT InvoiceNo) BETWEEN 2 AND 5 THEN 'Occasional buyer'
    ELSE 'Loyal customer'
  END AS customer_segment
FROM `capstone-retail-analysis.retail.online_retail`.retail.online_retail`
WHERE Quantity > 0
  AND UnitPrice > 0
  AND CustomerID IS NOT NULL
GROUP BY CustomerID, Country;
