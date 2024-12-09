-- ===================================================================================================================
-- Procedure for adding new test customers
-- ===================================================================================================================

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