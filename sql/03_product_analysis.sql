
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

-- 2. Category Performance

SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS products,
    SUM(o.quantity) AS units_sold,
    SUM(o.quantity * p.price) AS revenue
FROM `wired-rhino-505915-v9.ecommerce.products` AS p
JOIN `wired-rhino-505915-v9.ecommerce.orders` AS o
    ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- 3. Product Ranking by Category

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(o.quantity * p.price) AS revenue
    FROM `wired-rhino-505915-v9.ecommerce.products` AS p
    JOIN `wired-rhino-505915-v9.ecommerce.orders` AS o
        ON p.product_id = o.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category
)

SELECT
    product_id,
    product_name,
    category,
    revenue,
    RANK() OVER (
        PARTITION BY category
        ORDER BY revenue DESC
    ) AS category_rank
FROM product_sales
ORDER BY
    category,
    category_rank;

-- 4. Top 3 Products per Category

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(o.quantity * p.price) AS revenue
    FROM `wired-rhino-505915-v9.ecommerce.products` AS p
    JOIN `wired-rhino-505915-v9.ecommerce.orders` AS o
        ON p.product_id = o.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category
),

ranked_products AS (
    SELECT
        product_id,
        product_name,
        category,
        revenue,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY revenue DESC
        ) AS product_rank
    FROM product_sales
)

SELECT
    product_id,
    product_name,
    category,
    revenue,
    product_rank
FROM ranked_products
WHERE product_rank <= 3
ORDER BY
    category,
    product_rank;
