-----------------------------------------------------------------------------------------------------------------------
-- Return the number of customers by the State ------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER FUNCTION get_customer_number_by_state(@state_name VARCHAR(2))
    RETURNS INT
AS
BEGIN
    DECLARE
        @customer_count INT;
    WITH cte_customers_with_state as (
        SELECT *
        FROM BikeStores.sales.customers
        WHERE STATE = @state_name
    )
    SELECT @customer_count = COUNT(*)
    FROM cte_customers_with_state;
    RETURN (@customer_count)
END
GO

DECLARE @ReturnCustomersNumberByState INT
EXEC @ReturnCustomersNumberByState = get_customer_number_by_state @state_name = 'TX'
SELECT @ReturnCustomersNumberByState AS ReturnCustomersNumberByState
GO
-- Result for OR: 0
-- Result for TX: 142

-----------------------------------------------------------------------------------------------------------------------
-- Return a category name with the number of products -----------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE CategoriesWithProductCount
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