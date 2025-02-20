-- ===================================================================================================================
-- Adding a new city
-- ===================================================================================================================

DROP ROUTINE IF EXISTS add_new_city(VARCHAR, INT);

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