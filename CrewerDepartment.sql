USE movie_dataset;

DROP TABLE IF EXISTS crewer_department;
CREATE TABLE crewer_department(
    IDMov int,
    IDDepartment VARCHAR(250),
    IDCrewer VARCHAR(250),
    PRIMARY KEY (IDMov, IDDepartment, IDCrewer),
    FOREIGN KEY (IDMov) REFERENCES movie_dataset(id),
    FOREIGN KEY (IDDepartment) REFERENCES departmentTable(IDDepartment),
    FOREIGN KEY (IDCrewer) REFERENCES crewer(IDCrewer)
);





SELECT (JSON_EXTRACT(crew, '$[*].department')), idMov, (JSON_EXTRACT(crew, '$[*].id')) FROM crewCoreccted WHERE C

DROP PROCEDURE IF EXISTS CREWER_DEPARTMENT;
DELIMITER $$
CREATE PROCEDURE CREWER_DEPARTMENT()
BEGIN
    DECLARE idDepartmentRow VARCHAR(250);
    DECLARE idCrewRow VARCHAR(250);

    DECLARE jsons JSON;
    DECLARE movie INT;
    DECLARE i INT;

    DECLARE fila CURSOR FOR SELECT crew, idMov FROM crewCoreccted;
    OPEN fila;
    FETCH fila INTO jsons, movie;

    WHILE jsons IS NOT NULL DO
        Set i = 0;

        WHILE i < JSON_LENGTH(jsons) DO
            -- SET Department = JSON_UNQUOTE(JSON_EXTRACT(jsons, CONCAT('$[', i, '].department')));
            SET idDepartmentRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].department'));
            SET idCrewRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].id'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO crewer_department2 (IDMov, IDCrewer, IDDepartment) VALUES (',movie,',',idCrewRow,',',idDepartmentRow,')');
            PREPARE stmt FROM @sql;
            EXECUTE stmt;


        END WHILE;
        FETCH fila INTO jsons, movie;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL CREWER_DEPARTMENT();