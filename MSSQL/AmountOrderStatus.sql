-- ===================================================================================================================
-- View with amount of order_status in particular year, store and state in the state of Texas
-- ===================================================================================================================

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
GROUP BY year
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