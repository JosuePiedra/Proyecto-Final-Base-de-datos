
USE movie_dataset;

DROP TABLE IF EXISTS spoken_languages;
CREATE TABLE spoken_languages (
    iso639_1 VARCHAR(250) NOT NULL,
    name VARCHAR(40) NOT NULL,
    PRIMARY KEY(iso639_1)
);

DROP PROCEDURE IF EXISTS SpokenLanguages;
DELIMITER $$
CREATE PROCEDURE SpokenLanguages()
BEGIN
    DECLARE ids INT;
    DECLARE jsons JSON;
    DECLARE i INT;
    DECLARE isoRow JSON;
    DECLARE nameRow JSON;

    DECLARE fila CURSOR FOR SELECT spoken_languages FROM movie_dataset;
    OPEN fila;
    FETCH fila INTO jsons;

    WHILE jsons IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET isoRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].iso_639_1'));
            set nameRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].name'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO spoken_languages (iso639_1, name ) VALUES (', isoRow, ',',nameRow,')');
            IF (SELECT COUNT(*) FROM spoken_languages WHERE iso639_1 = isoRow) = 0 THEN
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
            END IF;
        END WHILE;
        FETCH fila INTO jsons;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL SpokenLanguages;


