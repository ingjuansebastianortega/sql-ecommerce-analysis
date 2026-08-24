-- ============================================
-- E-COMMERCE SALES ANALYSIS
-- Sales KPIs
-- ============================================

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.quantity) AS units_sold,
    SUM(o.quantity * p.price) AS total_revenue,
    AVG(o.quantity * p.price) AS average_order_value
FROM `wired-rhino-505915-v9.ecommerce.orders` AS o
JOIN `wired-rhino-505915-v9.ecommerce.products` AS p
    ON o.product_id = p.product_id;

-- Monthly Revenue

SELECT
    DATE_TRUNC(o.order_date, MONTH) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.quantity) AS units_sold,
    SUM(o.quantity * p.price) AS revenue
FROM `wired-rhino-505915-v9.ecommerce.orders` AS o
JOIN `wired-rhino-505915-v9.ecommerce.products` AS p
    ON o.product_id = p.product_id
GROUP BY month
ORDER BY month;


-- Top Products by Revenue

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS units_sold,
    SUM(o.quantity * p.price) AS revenue
FROM `wired-rhino-505915-v9.ecommerce.orders` AS o
JOIN `wired-rhino-505915-v9.ecommerce.products` AS p
    ON o.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY revenue DESC;
