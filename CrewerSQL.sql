USE movie_dataset;

-- Se crea la tabla crewer
DROP TABLE IF EXISTS crewer;
CREATE TABLE crewer(
    IDCrewer INT PRIMARY KEY,
    name VARCHAR(250),
    gender INT
);

-- Se crea la tabla crewer
DROP PROCEDURE IF EXISTS Crew;
DELIMITER $$
CREATE PROCEDURE Crew()
BEGIN
    DECLARE IDCrewer VARCHAR(250);
    DECLARE gender INT;
    DECLARE name VARCHAR(250);

    DECLARE jsons JSON;
    DECLARE i INT;


    DECLARE fila CURSOR FOR SELECT crew FROM crewCoreccted;
    OPEN fila;
    FETCH fila INTO jsons;

    WHILE jsons IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET IDCrewer = JSON_EXTRACT(jsons, CONCAT('$[', i, '].id'));
            set gender = JSON_EXTRACT(jsons, CONCAT('$[', i, '].gender'));
            set name = JSON_EXTRACT(jsons, CONCAT('$[', i, '].name'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO crewer (IDCrewer, name, gender) VALUES (', IDCrewer, ',',name,',',gender,')');
            IF (SELECT COUNT(*) FROM crewer WHERE crewer.IDCrewer = IDCrewer) = 0 THEN
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
            END IF;
        END WHILE;
        FETCH fila INTO jsons;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL Crew();


