---- ===================================================================================================================
---- Return the number of customers by the State
---- ===================================================================================================================

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

---- ===================================================================================================================
---- Return a category name with the number of products
---- ===================================================================================================================

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

---- ===================================================================================================================
---- View with amount of order_status in particular year, store and state in the state of Texas
---- ===================================================================================================================

CREATE OR ALTER VIEW sales.amount_order_status WITH SCHEMABINDING
AS
SELECT o.order_id
    ,"order_status" = CASE
    WHEN order_status = 1 THEN 'Pending'
    WHEN order_status = 2 THEN 'Processing'
    WHEN order_status = 3 THEN 'Rejected'
    WHEN order_status = 4 THEN 'Completed'
    END
    ,year(o.order_date) year
    ,s.store_name
    ,s.state
FROM sales.orders o
         INNER JOIN sales.stores s ON o.store_id = s.store_id;
GO;

CREATE UNIQUE CLUSTERED INDEX IX_order_id ON sales.amount_order_status(order_id);
CREATE NONCLUSTERED INDEX IX_state on sales.amount_order_status(state);
GO;

SELECT order_status
    , year
    , count_big(*) amount
    , store_name
    , state
    FROM sales.amount_order_status
WHERE state = 'TX'
group by year
       , order_status
       , store_name
       , state
ORDER BY year DESC;
GO;

-- Result:
-- +------------+----+------+-------------+-----+
-- |order_status|year|amount|store_name   |state|
-- +------------+----+------+-------------+-----+
-- |Completed   |2018|17    |Rowlett Bikes|TX   |
-- |Pending     |2018|8     |Rowlett Bikes|TX   |
-- |Processing  |2018|5     |Rowlett Bikes|TX   |
-- |Rejected    |2018|4     |Rowlett Bikes|TX   |
-- |Completed   |2017|67    |Rowlett Bikes|TX   |
-- |Rejected    |2017|8     |Rowlett Bikes|TX   |
-- |Completed   |2016|58    |Rowlett Bikes|TX   |
-- |Rejected    |2016|7     |Rowlett Bikes|TX   |
-- +------------+----+------+-------------+-----+

---- ===================================================================================================================
---- Procedure for adding new test customers
---- ===================================================================================================================

CREATE OR ALTER PROCEDURE NewSalesTestCustomers
AS
    BEGIN TRAN
    SAVE TRAN START_ADD_NEW_CUSTOMERS
INSERT INTO BikeStores.sales.customers(first_name, last_name, phone, email, street, city, state, zip_code)
VALUES ('John', 'Connor', '111-222-333', 'john.connor@jc.com', '123 grov', 'Sandy', 'OR', '97055')
    IF @@error <> 0
        BEGIN
            ROLLBACK TRAN START_ADD_NEW_CUSTOMERS
            RETURN 10
        END
    SAVE TRAN ADD_NEW_CUSTOMERS
    COMMIT TRAN
GO;

exec NewSalesTestCustomers;
GO;

-- Result:
-- +-----------+----------+---------+-----------+------------------ +--------+-----+-----+--------+
-- |customer_id|first_name|last_name|phone      |email              |street  |city |state|zip_code|
-- +-----------+----------+---------+-----------+------------------ +--------+-----+-----+--------+
-- |1447       |John      |Connor   |111-222-333|john.connor@jc.com |123 grov|Sandy|OR   |97055   |
-- +-----------+----------+---------+-----------+------------------ +--------+-----+-----+--------+
