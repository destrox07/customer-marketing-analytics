-- ============================================================
-- PROJECT: Customer & Marketing Analytics
-- DATASET: UCI Online Retail
-- DATABASE: customer_marketing_analytics
-- TABLE: public.online_retail_sales
-- PURPOSE: Customer analytics, RFM segmentation and revenue insights
-- ============================================================

-- NOTE:
-- This script assumes lowercase PostgreSQL column names:
-- invoice_no, stock_code, description, quantity,
-- invoice_date, unit_price, customer_id, country.
-- Revenue is calculated as quantity * unit_price.
-- Cancelled invoices and invalid sales rows are excluded.

-- ============================================================
-- 1. DATA OVERVIEW
-- ============================================================

SELECT
    COUNT(*) AS total_sales_rows,
    COUNT(DISTINCT invoice_no) AS total_invoices,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT country) AS total_countries,
    MIN(invoice_date) AS first_invoice_date,
    MAX(invoice_date) AS last_invoice_date,
    ROUND(SUM(quantity * unit_price)::numeric, 2) AS total_revenue
FROM public.online_retail_sales
WHERE quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL
  AND invoice_no NOT ILIKE 'C%';


-- ============================================================
-- 2. CUSTOMER METRICS
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS frequency,
    SUM(quantity) AS total_items,
    ROUND(SUM(quantity * unit_price)::numeric, 2) AS monetary,
    MIN(invoice_date) AS first_purchase_date,
    MAX(invoice_date) AS last_purchase_date,
    COUNT(*) AS purchase_lines
FROM public.online_retail_sales
WHERE quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL
  AND invoice_no NOT ILIKE 'C%'
GROUP BY customer_id
ORDER BY monetary DESC;


-- ============================================================
-- 3. RFM CUSTOMER SEGMENTATION
-- R = Recency, F = Frequency, M = Monetary value
-- Higher recency score means a more recent purchase.
-- ============================================================

WITH customer_summary AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS frequency,
        ROUND(SUM(quantity * unit_price)::numeric, 2) AS monetary,
        MIN(invoice_date)::date AS first_purchase_date,
        MAX(invoice_date)::date AS last_purchase_date
    FROM public.online_retail_sales
    WHERE quantity > 0
      AND unit_price > 0
      AND customer_id IS NOT NULL
      AND invoice_no NOT ILIKE 'C%'
    GROUP BY customer_id
),
recency AS (
    SELECT
        *,
        (MAX(last_purchase_date) OVER () - last_purchase_date)
            AS recency_days
    FROM customer_summary
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS r_score,
        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS f_score,
        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS m_score
    FROM recency
),
segmented AS (
    SELECT
        *,
        r_score + f_score + m_score AS rfm_score,
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
                THEN 'Champions'
            WHEN r_score >= 3 AND f_score >= 3
                THEN 'Loyal Customers'
            WHEN r_score <= 2 AND f_score >= 3
                THEN 'At Risk'
            WHEN r_score >= 3 AND f_score <= 2
                THEN 'Recent Customers'
            WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2
                THEN 'Hibernating'
            ELSE 'Needs Attention'
        END AS customer_segment
    FROM rfm_scores
)
SELECT *
FROM segmented
ORDER BY rfm_score DESC, monetary DESC;


-- ============================================================
-- 4. CUSTOMER COUNTS BY SEGMENT
-- Uses the same illustrative RFM rules as Section 3.
-- ============================================================

WITH customer_summary AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS frequency,
        SUM(quantity * unit_price) AS monetary,
        MAX(invoice_date)::date AS last_purchase_date
    FROM public.online_retail_sales
    WHERE quantity > 0
      AND unit_price > 0
      AND customer_id IS NOT NULL
      AND invoice_no NOT ILIKE 'C%'
    GROUP BY customer_id
),
scored AS (
    SELECT
        *,
        MAX(last_purchase_date) OVER () - last_purchase_date
            AS recency_days,
        NTILE(5) OVER (
            ORDER BY MAX(last_purchase_date) OVER () - last_purchase_date DESC
        ) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM customer_summary
)
SELECT
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3
            THEN 'Loyal Customers'
        WHEN r_score <= 2 AND f_score >= 3
            THEN 'At Risk'
        WHEN r_score >= 3 AND f_score <= 2
            THEN 'Recent Customers'
        WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2
            THEN 'Hibernating'
        ELSE 'Needs Attention'
    END AS customer_segment,
    COUNT(*) AS customers,
    ROUND(SUM(monetary)::numeric, 2) AS revenue
FROM scored
GROUP BY 1
ORDER BY revenue DESC;


-- ============================================================
-- 5. MONTHLY REVENUE
-- ============================================================

SELECT
    DATE_TRUNC('month', invoice_date)::date AS revenue_month,
    ROUND(SUM(quantity * unit_price)::numeric, 2) AS monthly_revenue,
    COUNT(DISTINCT invoice_no) AS total_invoices,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM public.online_retail_sales
WHERE quantity > 0
  AND unit_price > 0
  AND invoice_no NOT ILIKE 'C%'
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY revenue_month;


-- ============================================================
-- 6. REVENUE BY COUNTRY
-- ============================================================

SELECT
    country,
    ROUND(SUM(quantity * unit_price)::numeric, 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS total_invoices,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM public.online_retail_sales
WHERE quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL
  AND invoice_no NOT ILIKE 'C%'
GROUP BY country
ORDER BY total_revenue DESC;


-- ============================================================
-- 7. TOP 10 CUSTOMERS BY REVENUE
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(quantity) AS total_items,
    ROUND(SUM(quantity * unit_price)::numeric, 2) AS total_revenue
FROM public.online_retail_sales
WHERE quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL
  AND invoice_no NOT ILIKE 'C%'
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;
