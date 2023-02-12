USE movie_dataset;

DROP TABLE IF EXISTS movies_languages;
CREATE TABLE movies_languages(
   iso639_1 VARCHAR(250),
   IDMov INT,
   PRIMARY KEY (iso639_1, IDMov),
   FOREIGN KEY (iso639_1) REFERENCES spoken_languages(ISO639_1),
   FOREIGN KEY (IDMov) REFERENCES movie_dataset(id)
);

DROP PROCEDURE IF EXISTS MOVIE_LANGUAGUESPROCEDURE;
DELIMITER $$
CREATE PROCEDURE MOVIE_LANGUAGUESPROCEDURE()
BEGIN
    DECLARE movie INT;
    DECLARE jsons JSON;
    DECLARE i INT;
    DECLARE isoRow JSON;

    DECLARE fila CURSOR FOR SELECT spoken_languages, id FROM movie_dataset;
    OPEN fila;
    FETCH fila INTO jsons, movie;

    WHILE jsons IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET isoRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].iso_639_1'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO movies_languages (iso639_1, IDMov ) VALUES (', isoRow, ',',movie,')');
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
        END WHILE;
        FETCH fila INTO jsons, movie;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL MOVIE_LANGUAGUESPROCEDURE();