-- ===================================================================================================================
-- Return the number of films based on the actor's first name and last name --
-- ===================================================================================================================

DROP ROUTINE IF EXISTS get_film_count_by_actor();

CREATE OR REPLACE FUNCTION get_film_count_by_actor(
    IN _p_actor_first_name TEXT,
    IN _p_actor_last_name TEXT
)
RETURNS TABLE (
    actor_name TEXT,
    movie_count BIGINT
)
LANGUAGE PLPGSQL
AS
$$
BEGIN
    RETURN QUERY
    WITH cte_films_with_actor AS (
        SELECT p_a.first_name, p_a.last_name, f_a.film_id
        FROM film_actor f_a
        INNER JOIN public.actor p_a ON p_a.actor_id = f_a.actor_id
        WHERE (_p_actor_first_name IS NULL OR p_a.first_name ILIKE '%' || _p_actor_first_name || '%')
        AND (_p_actor_last_name IS NULL OR p_a.last_name ILIKE '%' || _p_actor_last_name || '%')
    )
    SELECT first_name || ' ' || last_name AS actor_name
         , count(film_id) AS movie_cout
    FROM cte_films_with_actor
    group by first_name, last_name;
END
$$;

SELECT * from get_film_count_by_actor('Penelope', 'Guiness');

SELECT * from get_film_count_by_actor('Penelope', null);

SELECT * from get_film_count_by_actor(null, null);

SELECT * from get_film_count_by_actor(null, 'Guiness');
