-- ============================================
-- PRODUCT ANALYSIS
-- ============================================

-- 1. Product Performance

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.price,
    SUM(o.quantity) AS units_sold,
    SUM(o.quantity * p.price) AS revenue
FROM `wired-rhino-505915-v9.ecommerce.products` AS p
JOIN `wired-rhino-505915-v9.ecommerce.orders` AS o
    ON p.product_id = o.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.price
ORDER BY revenue DESC;
