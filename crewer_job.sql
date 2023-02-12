USE movie_dataset;

DROP TABLE IF EXISTS crewer_job;
CREATE TABLE crewer_job(
    IDMov INT,
    IDJob VARCHAR(250),
    IDCrewer INT,
    IDCredit VARCHAR(250),
    PRIMARY KEY (IDMov, IDJob, IDCrewer, IDCredit),
    FOREIGN KEY (IDMov) REFERENCES movie_dataset(id),
    FOREIGN KEY (IDJob) REFERENCES jobs(IDJob),
    FOREIGN KEY (IDCrewer) REFERENCES crewer(IDCrewer)
);


DROP PROCEDURE IF EXISTS CREWER_JOBPROC;
DELIMITER $$
CREATE PROCEDURE CREWER_JOBPROC()
BEGIN
    DECLARE idJobRow VARCHAR(250);
    DECLARE idCrewRow VARCHAR(250);
    DECLARE IDCredit VARCHAR(250);

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
            SET idJobRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].job'));
            SET idCrewRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].id'));
            SET IDCredit = JSON_EXTRACT(jsons, CONCAT('$[', i, '].credit_id'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO crewer_job VALUES (',movie,',',idJobRow,',',idCrewRow,',',IDCredit,')');
            PREPARE stmt FROM @sql;
            EXECUTE stmt;



        END WHILE;
        FETCH fila INTO jsons, movie;
    END WHILE;
CLOSE fila;
END$$
DELIMITER ;

CALL CREWER_JOBPROC();


