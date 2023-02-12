USE movie_dataset;

DROP TABLE IF EXISTS movie_producer;
CREATE TABLE movie_producer(
  IDProd VARCHAR(250),
  IDMov INT,
  PRIMARY KEY (IDMov, IDProd),
  FOREIGN KEY (IDProd) REFERENCES production_companies(IDProdC),
  FOREIGN KEY (IDMov) REFERENCES movie_dataset(id)
);

DROP PROCEDURE IF EXISTS MOVIE_PRODUCER;
DELIMITER $$
CREATE PROCEDURE MOVIE_PRODUCER()
BEGIN

    DECLARE IDProd VARCHAR(250);

    DECLARE jsons JSON;
    DECLARE movie INT;
    DECLARE i INT;

    DECLARE fila CURSOR FOR SELECT production_companies, id FROM movie_dataset;
    OPEN fila;
    FETCH fila INTO jsons, movie;

    WHILE jsons IS NOT NULL DO
        Set i = 0;

        WHILE i < JSON_LENGTH(jsons) DO
            -- SET Department = JSON_UNQUOTE(JSON_EXTRACT(jsons, CONCAT('$[', i, '].department')));
            SET IDProd = JSON_EXTRACT(jsons, CONCAT('$[', i, '].id'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO movie_producer VALUES (',IDProd,',',movie,')');
            PREPARE stmt FROM @sql;
            EXECUTE stmt;


        END WHILE;
        FETCH fila INTO jsons, movie;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL MOVIE_PRODUCER();