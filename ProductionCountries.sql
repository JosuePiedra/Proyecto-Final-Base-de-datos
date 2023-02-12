
USE movie_dataset;

DROP TABLE IF EXISTS production_countries;
CREATE TABLE production_countries (
    iso3166_1 VARCHAR(250) NOT NULL,
    name VARCHAR(40) NOT NULL,
    PRIMARY KEY(iso3166_1)
);

DROP PROCEDURE IF EXISTS ProductionCountries;
DELIMITER $$
CREATE PROCEDURE ProductionCountries()
BEGIN
    DECLARE ids INT;
    DECLARE jsons JSON;
    DECLARE i INT;
    DECLARE isoRow JSON;
    DECLARE nameRow JSON;

    DECLARE fila CURSOR FOR SELECT production_countries FROM movie_dataset;
    OPEN fila;
    FETCH fila INTO jsons;

    WHILE jsons IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET isoRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].iso_3166_1'));
            set nameRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].name'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO production_countries (iso3166_1, name ) VALUES (', isoRow, ',',nameRow,')');
            IF (SELECT COUNT(*) FROM production_countries WHERE iso3166_1 = isoRow) = 0 THEN
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
            END IF;
        END WHILE;
        FETCH fila INTO jsons;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL ProductionCountries();