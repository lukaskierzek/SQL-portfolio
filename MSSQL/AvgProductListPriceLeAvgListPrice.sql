-- ===================================================================================================================
-- List of products whose average list_price is less than or equal to the average list_price.
-- ===================================================================================================================

SELECT p.*
FROM (
    SELECT product_name
         , list_price
    FROM production.products
    ) as p
WHERE list_price <= (
    SELECT AVG(list_price)
    FROM production.products
    );