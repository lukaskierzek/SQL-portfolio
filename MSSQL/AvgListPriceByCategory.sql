-- ===================================================================================================================
-- List of products whose average list_price is greater than or equal to the average list for the category.
-- ===================================================================================================================

WITH cte_avg_list_price_by_category (categoryId, avgForCategory) AS (
    SELECT category_id
          ,AVG(list_price)
    FROM BikeStores.production.products
    GROUP BY category_id
) SELECT p.product_name
        ,c.category_name
        ,p.list_price
        ,cte.avgForCategory
  FROM production.products p
      INNER JOIN cte_avg_list_price_by_category cte ON cte.categoryId = p.category_id
      INNER JOIN production.categories c ON c.category_id = p.category_id
  WHERE p.list_price >= cte.avgForCategory
  ORDER BY category_name, list_price DESC;