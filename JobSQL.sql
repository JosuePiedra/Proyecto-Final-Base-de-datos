USE movie_dataset;

DROP TABLE IF EXISTS jobs;
CREATE TABLE jobs(
  IDJob VARCHAR(250) PRIMARY KEY,
  IDDepartment VARCHAR(250),
  FOREIGN KEY (IDDepartment) REFERENCES departmentTable(IDDepartment)
);

DROP PROCEDURE IF EXISTS JOBPROCEDURE;
DELIMITER $$
CREATE PROCEDURE JOBPROCEDURE()
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
            IF (Job = '"other"' ) THEN
                SET @sql = CONCAT('INSERT INTO jobs (IDJob, IDDepartment) VALUES (', Job,', ''OtherDepartment'')');
            ELSE
                SET @sql = CONCAT('INSERT INTO jobs (IDJob, IDDepartment) VALUES (', Job,',',Department,')');
            end if;

            IF (SELECT COUNT(*) FROM jobs WHERE IDJob = JSON_UNQUOTE(Job)) = 0 THEN
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
            END IF;

        END WHILE;
        FETCH fila INTO jsons;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL JOBPROCEDURE();
