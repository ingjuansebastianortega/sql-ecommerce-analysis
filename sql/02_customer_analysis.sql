-- ============================================
-- CUSTOMER ANALYSIS
-- ============================================

-- 1. Customer Revenue

SELECT
    c.customer_id,
    c.name,
    c.country,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.quantity) AS units_purchased,
    SUM(o.quantity * p.price) AS total_spent
FROM `wired-rhino-505915-v9.ecommerce.customers` AS c
JOIN `wired-rhino-505915-v9.ecommerce.orders` AS o
    ON c.customer_id = o.customer_id
JOIN `wired-rhino-505915-v9.ecommerce.products` AS p
    ON o.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.name,
    c.country
ORDER BY total_spent DESC;

-- 2. Revenue by Country

SELECT
    c.country,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.quantity * p.price) AS revenue
FROM `wired-rhino-505915-v9.ecommerce.customers` AS c
JOIN `wired-rhino-505915-v9.ecommerce.orders` AS o
    ON c.customer_id = o.customer_id
JOIN `wired-rhino-505915-v9.ecommerce.products` AS p
    ON o.product_id = p.product_id
GROUP BY c.country
ORDER BY revenue DESC;

-- 3. Repeat Customers

SELECT
    c.customer_id,
    c.name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM `wired-rhino-505915-v9.ecommerce.customers` AS c
JOIN `wired-rhino-505915-v9.ecommerce.orders` AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.name
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;

-- 4. Customer Revenue Ranking

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.name,
        c.country,
        SUM(o.quantity * p.price) AS total_spent
    FROM `wired-rhino-505915-v9.ecommerce.customers` AS c
    JOIN `wired-rhino-505915-v9.ecommerce.orders` AS o
        ON c.customer_id = o.customer_id
    JOIN `wired-rhino-505915-v9.ecommerce.products` AS p
        ON o.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.name,
        c.country
)

SELECT
    customer_id,
    name,
    country,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS customer_rank
FROM customer_revenue
ORDER BY customer_rank;
