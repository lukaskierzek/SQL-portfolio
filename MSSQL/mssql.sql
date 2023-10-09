-------------------------------------------------
-- Return the number of customers by the State --
-------------------------------------------------

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
