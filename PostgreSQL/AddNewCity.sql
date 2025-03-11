-- ===================================================================================================================
-- Adding a new city
-- ===================================================================================================================

DROP ROUTINE IF EXISTS add_new_city();

CREATE OR REPLACE PROCEDURE add_new_city(
    IN _city_name VARCHAR,
    IN _country_id INT
)
LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXISTS(
        SELECT 1 FROM city c
        WHERE c.city = _city_name AND c.country_id = _country_id
    ) THEN
        RAISE EXCEPTION 'There is already a city named % in country with id %', _city_name, _country_id;
    END IF;

    IF NOT EXISTS(
        SELECT 1 FROM country co
        WHERE co.country_id = _country_id
    ) THEN
        RAISE EXCEPTION 'There is no country with id %', _country_id;
    END IF;

    INSERT INTO city (city, country_id)
    VALUES (_city_name, _country_id);
    RAISE INFO 'Added city % for country id %', _city_name, _country_id;
END;
$$;

CALL add_new_city('Stockport', 102);
-- raise exception "There is already a city named Stockport in country with id 102"

CALL add_new_city('Stockport', 99999);
-- raise exception "There is no country with id 99999"

CALL add_new_city('Krakow', 76);
-- raise info 'Added city Krakow for country id 76'