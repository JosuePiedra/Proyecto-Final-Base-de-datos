USE movie_dataset;

-- SE crea la table department
DROP TABLE IF EXISTS departmentTable;
CREATE TABLE departmentTable(
  indice AU
  IDDepartment VARCHAR(250) PRIMARY KEY
);

SELECT crew FROM c
SELECT (JSON_UNQUOTE(JSON_EXTRACT(crew, concat('$[1].department')))) FROM crewCoreccted;

-- Se crea el procedimiento Department
DROP PROCEDURE IF EXISTS Department;
DELIMITER $$
CREATE PROCEDURE Department()
BEGIN
    DECLARE Department VARCHAR(250);

    DECLARE jsons JSON;
    DECLARE i INT;

    DECLARE fila CURSOR FOR SELECT crew FROM crewCoreccted;
    OPEN fila;
    FETCH fila INTO jsons;

    WHILE jsons IS NOT NULL DO
        Set i = 0;

        WHILE i < JSON_LENGTH(jsons) DO
            -- SET Department = JSON_UNQUOTE(JSON_EXTRACT(jsons, CONCAT('$[', i, '].department')));
            SET Department = JSON_EXTRACT(jsons, CONCAT('$[', i, '].department'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO departmentTable (IDDepartment) VALUES (', Department,')');

            IF (SELECT COUNT(*) FROM departmentTable WHERE IDDepartment = JSON_UNQUOTE(Department)) = 0 THEN
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
            END IF;


        END WHILE;
        FETCH fila INTO jsons;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL Department()
;

INSERT INTO departmentTable VALUES ('OtherDepartment');