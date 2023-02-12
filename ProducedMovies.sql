USE movie_dataset;

DROP TABLE IF EXISTS produced_movie;
CREATE TABLE produced_movie(
       ISO3166_1 VARCHAR(250),
       IDMov INT,
       PRIMARY KEY (ISO3166_1, IDMov),
       FOREIGN KEY (ISO3166_1) REFERENCES production_countries(ISO3166_1) ,
       FOREIGN KEY (IDMov) REFERENCES movie_dataset(id)

);

DROP PROCEDURE IF EXISTS PRODUCED_MOVIEPROCEDURE;
DELIMITER $$
CREATE PROCEDURE PRODUCED_MOVIEPROCEDURE()
BEGIN
    DECLARE movie INT;
    DECLARE jsons JSON;
    DECLARE i INT;
    DECLARE isoRow JSON;

    DECLARE fila CURSOR FOR SELECT production_countries, id FROM movie_dataset;
    OPEN fila;
    FETCH fila INTO jsons, movie;

    WHILE jsons IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET isoRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].iso_3166_1'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO produced_movie (ISO3166_1, IDMov ) VALUES (', isoRow, ',',movie,')');
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
        END WHILE;
        FETCH fila INTO jsons, movie;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL PRODUCED_MOVIEPROCEDURE();