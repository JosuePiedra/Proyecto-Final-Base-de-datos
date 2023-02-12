use movie_dataset;

CREATE TABLE jobs12(
  IDJob VARCHAR(250),
  IDDepartment VARCHAR(250),
  FOREIGN KEY (IDDepartment) REFERENCES departmentTable(IDDepartment)
);

DROP PROCEDURE IF EXISTS JOBPROCEDURE123;
DELIMITER $$
CREATE PROCEDURE JOBPROCEDURE123()
BEGIN
    DECLARE Department VARCHAR(250);
    DECLARE Job VARCHAR(250);

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
            SET Job = JSON_EXTRACT(jsons, CONCAT('$[', i, '].job'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO jobs12 (IDJob, IDDepartment) VALUES (', Job,',',Department,')');

                PREPARE stmt FROM @sql;
                EXECUTE stmt;


        END WHILE;
        FETCH fila INTO jsons;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL JOBPROCEDURE123();

SELECT DISTINCT * FROM jobs12;


SELECT * FROM crewer_job INNER JOIN crewer ON crewer_job.IDMov = crewer.IDCrewer
         WHERE (
            SELECT COUNT(cast.name) FROM cast where cast.name = crewer.name
                ) > 0;

SELECT * FROM crewer_job INNER JOIN crewer ON crewer_job.IDMov = crewer.IDCrewer
         WHERE IDJob = 'Director';

SELECT * FROM crewer_job INNER JOIN crewer ON crewer_job.IDMov = crewer.IDCrewer
INNER JOIN director ON Director_name != name

SELECT Director FROM movie_dataset WHERE director NOT IN (SELECT crewer.name from crewer);
SELECT m.id, c.IDCrewer, m.director, c.name  FROM movie_dataset m, crewer c
WHERE m.director = c.name ;
SELECT m.id, c.IDCrewer, m.director, c.name  FROM movie_dataset m, (SELECT name, MAX(IDCrewer) AS IdCrewer FROM crewer GROUP BY name) c
WHERE m.director = c.name ;

SELECT * FROM Crewer c WHERE name IN
(SELECT name
 FROM crewer c
 WHERE c.name IN (SELECT director FROM movie_dataset )
 GROUP BY name
 HAVING COUNT(*) > 1);


SELECT  * FROM crewer_job INNER JOIN crewer on crewer_job.IDCrewer = crewer.IDCrewer WHERE  name = 'George Lucas';

SELECT * From jobs WHERE IDJob = 'Other'

SELECT * FROM jobs WHERE IDJob = 'Director';



SELECT director FROM movie_dataset WHERE id = 11 OR id = 838 OR id = 1893 OR id = 1894 OR id = 1895



SELECT * FROM crewer_job WHERE IDJob = 'Other';

SELECT * FROM crewer WHERE IDCrewer;

