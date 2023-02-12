USE movie_dataset;

DROP TABLE IF EXISTS production_companies;
CREATE TABLE production_companies(
    IDProdC VARCHAR(250) PRIMARY KEY,
    name VARCHAR(250)
);

DROP PROCEDURE IF EXISTS ProductionCompaniesProcedure;
DELIMITER $$
CREATE PROCEDURE ProductionCompaniesProcedure()
BEGIN

    DECLARE jsons JSON;
    DECLARE i INT;
    DECLARE id VARCHAR(250);
    DECLARE name VARCHAR(250);

    DECLARE fila CURSOR FOR SELECT production_companies FROM movie_dataset;
    OPEN fila;
    FETCH fila INTO jsons;

    WHILE jsons IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET id = JSON_EXTRACT(jsons, CONCAT('$[', i, '].id'));
            set name = JSON_EXTRACT(jsons, CONCAT('$[', i, '].name'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO production_companies (IDProdC, name ) VALUES (', id, ',',name,')');
            IF (SELECT COUNT(*) FROM production_companies WHERE JSON_UNQUOTE(id) = IDProdC) = 0 THEN
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
            END IF;
        END WHILE;
        FETCH fila INTO jsons;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL ProductionCompaniesProcedure();