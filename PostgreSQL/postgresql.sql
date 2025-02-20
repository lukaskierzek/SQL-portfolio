-- ===================================================================================================================
-- Return the number of films based on the actor's first name and last name --
-- ===================================================================================================================
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
        SELECT p_a.first_name, p_a.last_name
        FROM film_actor f_a
        INNER JOIN public.actor p_a ON p_a.actor_id = f_a.actor_id
        WHERE p_a.first_name LIKE '%' || COALESCE(_p_actor_first_name, '') || '%'
        AND p_a.last_name LIKE '%' || COALESCE(_p_actor_last_name, '') || '%'
    )
    SELECT cte_f_w_a.first_name || ' ' || cte_f_w_a.last_name
         , count(*)
    FROM cte_films_with_actor cte_f_w_a
    group by cte_f_w_a.first_name, cte_f_w_a.last_name;
END
$$;

SELECT * from get_film_count_by_actor('Penelope', 'Guiness');
SELECT * from get_film_count_by_actor('Penelope', null);
SELECT * from get_film_count_by_actor(null, null);
SELECT * from get_film_count_by_actor(null, 'Guiness');

-- ===================================================================================================================
-- Adding a new city
-- ===================================================================================================================

DROP PROCEDURE IF EXISTS add_new_city;

CREATE OR REPLACE PROCEDURE add_new_city(
    IN _city_name varchar,
    IN _country_id int
)
LANGUAGE plpgsql
AS
$$
DECLARE
    city_count    INTEGER;
    country_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO city_count
    FROM city
    WHERE city.city = _city_name
    AND city.country_id = _country_id;

    SELECT COUNT(*)
    INTO country_count
    FROM country
    WHERE country_id = _country_id;

    IF city_count >= 1 THEN
        RAISE EXCEPTION 'There is already a city named % in country with id %', _city_name, _country_id;
    ELSIF country_count = 0 THEN
        RAISE EXCEPTION 'There is no country with id %', _country_id;
    ELSE
        INSERT INTO city (city, country_id)
        VALUES (_city_name, _country_id);
        RAISE INFO 'Added city % for country id %', _city_name, _country_id;
        COMMIT;
    END IF;
END;
$$;

CALL add_new_city('Stockport', 102);
-- raise exception "There is already a city named Stockport in country with id 102"

CALL add_new_city('Stockport', 99999);
-- raise exception "There is no country with id 99999"

CALL add_new_city('Krakow', 76);
-- raise info 'Added city Krakow for country id 76'