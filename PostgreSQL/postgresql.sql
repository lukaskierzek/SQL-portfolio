------------------------------------------------------------------
-- Return the numbers of films by actor's first name and last name
------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_film_count_by_actor(p_actor_first_name TEXT, p_actor_last_name TEXT)
    RETURNS INT
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    film_count INTEGER;
BEGIN
    WITH cte_films_with_actor AS (
        SELECT *
        FROM film_actor f_a
        INNER JOIN public.actor p_a ON p_a.actor_id = f_a.actor_id
        WHERE p_a.first_name LIKE '%' || p_actor_first_name || '%'
          AND p_a.last_name LIKE '%' || p_actor_last_name || '%'
    )
    SELECT COUNT(*)
    INTO film_count
    FROM cte_films_with_actor;

    RETURN film_count;
END
$$;

SELECT get_film_count_by_actor('Penelope', 'Guiness');
-- Result: 19