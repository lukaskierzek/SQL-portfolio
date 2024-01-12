---- ===================================================================================================================
---- Return the number of films by actor's first name and last name --
---- ===================================================================================================================

CREATE OR REPLACE FUNCTION get_film_count_by_actor(IN p_actor_first_name TEXT, IN p_actor_last_name TEXT)
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

---- ===================================================================================================================
---- Adding a new city
---- ===================================================================================================================

DROP PROCEDURE IF EXISTS add_new_city;

CREATE OR REPLACE PROCEDURE add_new_city(
    IN city_name varchar,
    IN _country_id int
)
LANGUAGE plpgsql
AS
$$
DECLARE
city_count INTEGER;
country_count INTEGER;
BEGIN
    WITH cte_the_city_count AS (
        SELECT c.city
        FROM city AS c
        WHERE c.city LIKE '%' || city_name || '%' AND c.country_id = _country_id
    )
    SELECT COUNT(*)
    INTO city_count
    FROM cte_the_city_count;

    WITH cte_country_count AS (
        SELECT c.country_id
        FROM country AS c
        WHERE c.country_id = _country_id
    )
    SELECT count(*)
    INTO country_count
    FROM cte_country_count;

    IF city_count >= 1  THEN
        RAISE EXCEPTION  'There is a % city for the country id %', city_name, _country_id;
    ELSIF country_count = 0 THEN
        RAISE EXCEPTION  'There is no country with id %', _country_id;
    ELSE
        INSERT INTO city (city, country_id)
        VALUES (city_name, _country_id);
        RAISE info  'Added city % for country id %', city_name, _country_id;
        COMMIT;
    END IF;
END;
$$;

CALL add_new_city('Stockport', 102);
-- raise exception "There is a Stockport city for the country id 102"

CALL add_new_city('Stockport', 99999);
-- raise exception "There is no country with id 99999"

CALL add_new_city('Krakow', 76);
-- raise info 'Added city Krakow for country id 76' and added a new city to the city table.