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
