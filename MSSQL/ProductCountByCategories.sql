-- ===================================================================================================================
-- Return a category name with the number of products
-- ===================================================================================================================

CREATE OR ALTER PROCEDURE CategoriesWithProductCount
AS
BEGIN
    SET NOCOUNT ON;
    WITH cte_categories_with_cout (CategoryName, ProductCount) AS (
        SELECT c.category_name, count(*) ProductCount
        FROM BikeStores.production.products p
        INNER JOIN BikeStores.production.categories c ON c.category_id = p.category_id
        GROUP BY c.category_name
    )
    SELECT *
    FROM cte_categories_with_cout
    ORDER BY ProductCount DESC;
END
GO

EXEC CategoriesWithProductCount
GO;

-- Result:
-- +-------------------+------------+
-- |CategoryName       |ProductCount|
-- +-------------------+------------+
-- |Cruisers Bicycles  |78          |
-- |Mountain Bikes     |60          |
-- |Road Bikes         |60          |
-- |Children Bicycles  |59          |
-- |Comfort Bicycles   |30          |
-- |Electric Bikes     |24          |
-- |Cyclocross Bicycles|10          |
-- +-------------------+------------+