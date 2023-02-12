create table cast
(
    name varchar(250) not null
        primary key
);

create table crewCoreccted
(
    idMov varchar(250) null,
    crew  text         null
);

create table crewer
(
    IDCrewer int          not null
        primary key,
    name     varchar(250) null,
    gender   int          null
);

create table departmentTable
(
    IDDepartment varchar(250) not null
        primary key
);

create table director
(
    Director_name varchar(255) not null
        primary key
);

create table genre
(
    IDGenre varchar(250) not null
        primary key
);

create table jobs
(
    IDJob        varchar(250) not null
        primary key,
    IDDepartment varchar(250) null,
    constraint jobs_ibfk_1
        foreign key (IDDepartment) references departmentTable (IDDepartment)
);

create index IDDepartment
    on jobs (IDDepartment);

create table jobs12
(
    IDJob        varchar(250) null,
    IDDepartment varchar(250) null,
    constraint jobs12_ibfk_1
        foreign key (IDDepartment) references departmentTable (IDDepartment)
);

create index IDDepartment
    on jobs12 (IDDepartment);

create table movie_Actors
(
    idMovie varchar(255) null,
    name    varchar(255) null
);

create table movie_dataset
(
    `index`              int          not null,
    budget               mediumtext   not null,
    genres               text         null,
    homepage             varchar(255) null,
    id                   int          not null
        primary key,
    keywords             text         null,
    original_language    varchar(5)   null,
    original_title       varchar(255) not null,
    overview             text         null,
    popularity           double       not null,
    production_companies text         null,
    production_countries text         null,
    release_date         date         null,
    revenue              mediumtext   not null,
    runtime              int          null,
    spoken_languages     json         null,
    status               varchar(255) not null,
    tagline              varchar(255) null,
    title                varchar(255) not null,
    vote_average         double       not null,
    vote_count           int          not null,
    cast                 text         null,
    crew                 text         null,
    director             varchar(255) null
);

create table crewer_job
(
    IDMov    int          not null,
    IDJob    varchar(250) not null,
    IDCrewer int          not null,
    IDCredit varchar(250) not null,
    primary key (IDMov, IDJob, IDCrewer, IDCredit),
    constraint crewer_job_ibfk_1
        foreign key (IDMov) references movie_dataset (id),
    constraint crewer_job_ibfk_2
        foreign key (IDJob) references jobs (IDJob),
    constraint crewer_job_ibfk_3
        foreign key (IDCrewer) references crewer (IDCrewer)
);

create index IDCrewer
    on crewer_job (IDCrewer);

create index IDJob
    on crewer_job (IDJob);

create table director_movies
(
    IDMov      int not null,
    IDDirector int not null,
    primary key (IDMov, IDDirector),
    constraint director_movies_ibfk_1
        foreign key (IDMov) references movie_dataset (id),
    constraint director_movies_ibfk_2
        foreign key (IDDirector) references crewer_job (IDCrewer)
);

create index IDDirector
    on director_movies (IDDirector);

create table movie_genre
(
    IDGenres varchar(250) not null,
    IDMov    int          not null,
    primary key (IDGenres, IDMov),
    constraint movie_genre_ibfk_1
        foreign key (IDGenres) references genre (IDGenre),
    constraint movie_genre_ibfk_2
        foreign key (IDMov) references movie_dataset (id)
);

create index IDMov
    on movie_genre (IDMov);

create table movies
(
    id                int          not null,
    `index`           int          not null,
    revenue           mediumtext   not null,
    release_date      date         null,
    tagline           varchar(255) null,
    overview          text         null,
    homepage          varchar(255) null,
    original_title    varchar(255) not null,
    popularity        double       not null,
    budget            mediumtext   not null,
    vote_average      double       not null,
    vote_count        int          not null,
    original_language varchar(5)   null,
    title             varchar(255) not null,
    runtime           int          null,
    status            varchar(255) not null
);

create table production_companies
(
    IDProdC varchar(250) not null
        primary key,
    name    varchar(250) null
);

create table movie_producer
(
    IDProd varchar(250) not null,
    IDMov  int          not null,
    primary key (IDMov, IDProd),
    constraint movie_producer_ibfk_1
        foreign key (IDProd) references production_companies (IDProdC),
    constraint movie_producer_ibfk_2
        foreign key (IDMov) references movie_dataset (id)
);

create index IDProd
    on movie_producer (IDProd);

create table production_countries
(
    iso3166_1 varchar(250) not null
        primary key,
    name      varchar(40)  not null
);

create table produced_movie
(
    ISO3166_1 varchar(250) not null,
    IDMov     int          not null,
    primary key (ISO3166_1, IDMov),
    constraint produced_movie_ibfk_1
        foreign key (ISO3166_1) references production_countries (iso3166_1),
    constraint produced_movie_ibfk_2
        foreign key (IDMov) references movie_dataset (id)
);

create index IDMov
    on produced_movie (IDMov);

create table spoken_languages
(
    iso639_1 varchar(250) not null
        primary key,
    name     varchar(40)  not null
);

create table movies_languages
(
    iso639_1 varchar(250) not null,
    IDMov    int          not null,
    primary key (iso639_1, IDMov),
    constraint movies_languages_ibfk_1
        foreign key (iso639_1) references spoken_languages (iso639_1),
    constraint movies_languages_ibfk_2
        foreign key (IDMov) references movie_dataset (id)
);

create index IDMov
    on movies_languages (IDMov);

create table temporalCast
(
    columnReplaced varchar(255) null
);

create
    definer = root@localhost procedure CREWER_DEPARTMENT()
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
END;

create
    definer = root@localhost procedure CREWER_JOBPROC()
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
END;

create
    definer = root@localhost procedure Crew()
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
END;

create
    definer = root@localhost procedure Department()
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

            IF (SELECT COUNT(*) FROM departmentTable WHERE  IDDepartment = JSON_UNQUOTE(Department)) = 0 THEN
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
            END IF;


        END WHILE;
        FETCH fila INTO jsons;
    END WHILE;
CLOSE fila;
END;

create
    definer = root@localhost procedure ExtractValuesJson(IN jsonKey varchar(250), IN jsonValue varchar(250),
                                                         IN jsonColum varchar(250), IN pkNewTab varchar(250),
                                                         IN vNewTable varchar(250))
BEGIN
    DECLARE ids INT;
    DECLARE indexN INT;
    DECLARE i INT;
    DECLARE idRow JSON;
    DECLARE valueRow JSON;
    DECLARE jsonRow JSON;

    Set indexN = 0;
    CREATE TABLE temporal(id JSON);

    WHILE indexN <= 4802 DO
        SET jsonRow = (SELECT spoken_languages FROM movie_dataset WHERE `index` = indexN);
        Set i = 0;
        WHILE i < JSON_LENGTH(jsonRow) DO
            SET idRow = JSON_EXTRACT(jsonRow, CONCAT('$[', i, '].',jsonKey));
            SET valueRow = JSON_EXTRACT(jsonRow, CONCAT('$[', i, '].',jsonValue));
            SET i = i + 1;
            -- Generate the column dynamically

            INSERT INTO temporal (id)VALUES (idRow);

            IF (SELECT COUNT(*) FROM temporal WHERE id = idRow) = 1 THEN
                SET @sql = CONCAT('INSERT INTO ',jsonColum ,'(',pkNewTab,', ',vNewTable,') VALUES (', idRow, ', ',valueRow,')');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
            END IF;
        END WHILE;
        SET indexN = indexN + 1;
    END WHILE;
    DROP TABLE IF EXISTS temporal;
END;

create
    definer = root@localhost procedure InsertJsonArrays(IN idColumnName varchar(250), IN jsonColumnName varchar(250),
                                                        IN keyJsonSearch varchar(250), IN newTableName varchar(250))
BEGIN
    DECLARE ids VARCHAR(250);
    DECLARE jsons JSON;
    DECLARE i INT;
    DECLARE jsonRow JSON;

    DECLARE fila CURSOR FOR SELECT idColumnName, jsonColumnName FROM movie_dataset;
    OPEN fila;
    FETCH fila INTO ids, jsons;


    WHILE ids IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET jsonRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].', keyJsonSearch));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO ', newTableName, '(idMov, idSpokenLanguages) VALUES (', ids, ',',jsonRow,')');

            PREPARE stmt FROM @sql;
            EXECUTE stmt;
        END WHILE;
        FETCH fila INTO ids, jsons;
    END WHILE;

CLOSE fila;

END;

create
    definer = root@localhost procedure InsertJsonArrays2(IN idColumnName varchar(250), IN jsonColumnName varchar(250),
                                                         IN keyJsonSearch varchar(250), IN newTableName varchar(250))
BEGIN
    DECLARE ids VARCHAR(250);
    DECLARE jsons VARCHAR(250);
    DECLARE i INT;
    DECLARE jsonRow JSON;

    DECLARE fila CURSOR FOR SELECT idColumnName, jsonColumnName;
    OPEN fila;
    FETCH fila INTO ids, jsons;

    SELECT ids, jsons;


CLOSE fila;

END;

create
    definer = root@localhost procedure JOBPROCEDURE()
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
END;

create
    definer = root@localhost procedure JOBPROCEDURE123()
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
END;

create
    definer = root@localhost procedure MOVIE_LANGUAGUESPROCEDURE()
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
END;

create
    definer = root@localhost procedure MOVIE_PRODUCER()
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
END;

create
    definer = root@localhost procedure PRODUCED_MOVIEPROCEDURE()
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
END;

create
    definer = root@localhost procedure ProductionCompaniesProcedure()
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
END;

create
    definer = root@localhost procedure ProductionCountries()
BEGIN
    DECLARE ids INT;
    DECLARE jsons JSON;
    DECLARE i INT;
    DECLARE isoRow JSON;
    DECLARE nameRow JSON;

    DECLARE fila CURSOR FOR SELECT production_countries FROM movie_dataset;
    OPEN fila;
    FETCH fila INTO jsons;

    WHILE jsons IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET isoRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].iso_3166_1'));
            set nameRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].name'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO production_countries (iso3166_1, name ) VALUES (', isoRow, ',',nameRow,')');
            IF (SELECT COUNT(*) FROM production_countries WHERE iso3166_1 = isoRow) = 0 THEN
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
            END IF;
        END WHILE;
        FETCH fila INTO jsons;
    END WHILE;
CLOSE fila;
END;

create
    definer = root@localhost procedure SpokenLanguages()
BEGIN
    DECLARE ids INT;
    DECLARE jsons JSON;
    DECLARE i INT;
    DECLARE isoRow JSON;
    DECLARE nameRow JSON;

    DECLARE fila CURSOR FOR SELECT spoken_languages FROM movie_dataset;
    OPEN fila;
    FETCH fila INTO jsons;

    WHILE jsons IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET isoRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].iso_639_1'));
            set nameRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].name'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO spoken_languages (iso639_1, name ) VALUES (', isoRow, ',',nameRow,')');
            IF (SELECT COUNT(*) FROM spoken_languages WHERE iso639_1 = isoRow) = 0 THEN
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
            END IF;
        END WHILE;
        FETCH fila INTO jsons;
    END WHILE;
CLOSE fila;
END;

create
    definer = root@localhost procedure cursor_json_example()
BEGIN
 DECLARE done INT DEFAULT FALSE ;
 DECLARE jsonData json ;
 DECLARE jsonId varchar(250) ;
 DECLARE jsonLabel varchar(250) ;
 DECLARE resultSTR LONGTEXT DEFAULT '';
 DECLARE i INT;



 -- Declarar el cursor
 DECLARE myCursor
  CURSOR FOR
   SELECT JSON_EXTRACT(CONVERT(production_companies USING UTF8MB4), '$[*]') FROM movie_dataset ;

 -- Declarar el handler para NOT FOUND (esto es marcar cuando el cursor ha llegado a su fin)
 DECLARE CONTINUE HANDLER
  FOR NOT FOUND SET done = TRUE ;

 -- Abrir el cursor
 OPEN myCursor  ;

 cursorLoop: LOOP
  FETCH myCursor INTO jsonData;


  -- Controlador para buscar cada uno de lso arrays
    SET i = 0;

  -- Si alcanzo el final del cursor entonces salir del ciclo repetitivo
  IF done THEN
   LEAVE  cursorLoop ;
  END IF ;


  WHILE(JSON_EXTRACT(jsonData, CONCAT('$[', i, ']')) IS NOT NULL) DO


  SET jsonId = IFNULL(JSON_EXTRACT(jsonData,  CONCAT('$[', i, '].id')), '') ;
  SET jsonLabel = IFNULL(JSON_UNQUOTE(JSON_EXTRACT(jsonData, CONCAT('$[', i,'].name'))), '') ;
  SET resultSTR = CONCAT(resultSTR, ' INSERT INTO temporal VALUES (', jsonId, ', ', '\'', REPLACE(jsonLabel, '\'', '^'), '\'); ');
  SET i = i + 1;

  END WHILE;

 END LOOP ;

 SELECT resultSTR ;
 CLOSE myCursor ;

END;

create
    definer = root@localhost procedure generalGenerator(IN sql_text varchar(250))
BEGIN
    DECLARE ids INT;
    DECLARE jsons VARCHAR(250);
    DECLARE i INT;
    DECLARE isoRow JSON;

    SELECT sql_text FROM movie_dataset;

 /*
    DECLARE fila CURSOR FOR SELECT sql_text ;

    OPEN fila;
    FETCH fila INTO jsons;

  */

    SELECT sql_text;



    WHILE jsons IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET isoRow = CONCAT(isoRow,JSON_EXTRACT(jsons, CONCAT('$[', i, '].iso_639_1')));
            SET i = i + 1;
            -- Generate the column dynamically
        END WHILE;
        -- FETCH fila INTO jsons;
    END WHILE;

    SELECT isoRow;
-- CLOSE fila;
END;

create
    definer = root@localhost procedure generate_columns(IN json_data json)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE json_array JSON;
    DECLARE json_object JSON;
    DECLARE column_name VARCHAR(255);

    SET json_array = JSON_EXTRACT(json_data, '$');

    WHILE i < JSON_LENGTH(json_array) DO
        SET json_object = JSON_EXTRACT(json_array, CONCAT('$[', i, ']'));
        SET column_name = JSON_UNQUOTE(JSON_EXTRACT(json_object, '$.name'));
        -- Generate the column dynamically
        -- SET @sql = CONCAT('ALTER TABLE mytable ADD COLUMN ', column_name, ' VARCHAR(255)');
        -- PREPARE stmt FROM @sql;
        -- EXECUTE stmt;
        SET i = i + 1;
        select column_name;
    END WHILE;

END;

create
    definer = root@localhost procedure generate_columns1()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE json_array JSON;
    DECLARE json_object TEXT;
    DECLARE column_name JSON;
    DECLARE idMovie INT;

    SET json_array = (SELECT JSON_EXTRACT(spoken_languages, '$') AS iso FROM movie_dataset);
    SET idMovie = (SELECT id FROM movie_dataset);


    WHILE i < JSON_LENGTH(json_array) DO

        SET json_object = (SELECT id, JSON_EXTRACT(json_array, CONCAT('$[', i, '].iso_639_1')) FROM movie_dataset);


       -- SET column_name = JSON_UNQUOTE(JSON_EXTRACT(json_object, '$.iso_639_1'));
        -- Generate the column dynamically
        -- SET @sql = CONCAT('ALTER TABLE mytable ADD COLUMN ', column_name, ' VARCHAR(255)');
        -- PREPARE stmt FROM @sql ;
        -- EXECUTE stmt;
        SET i = i + 1;
    END WHILE;
    SELECT json_object;
    -- SELECT @sql;
END;

create
    definer = root@localhost procedure movieSpokenLanguage()
BEGIN
    DECLARE ids INT;
    DECLARE jsons JSON;
    DECLARE i INT;
    DECLARE jsonRow JSON;

    DECLARE fila CURSOR FOR SELECT id, spoken_languages FROM movie_dataset;
    OPEN fila;
    FETCH fila INTO ids, jsons;

    WHILE ids IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET jsonRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].iso_639_1'));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO movies_languages (ID, iso639_1) VALUES (', ids, ',',jsonRow,')');
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
        END WHILE;
        FETCH fila INTO ids, jsons;
    END WHILE;

CLOSE fila;
END;

create
    definer = root@localhost procedure test_cursor(INOUT homepageList text)
BEGIN
    DECLARE finished INTEGER;

    DECLARE homepage TEXT;

    DECLARE fila CURSOR FOR SELECT homepage FROM movie_dataset;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    OPEN fila;

    getHomepage: LOOP
		FETCH fila INTO homepage;
		IF finished = 1 THEN
			LEAVE getHomepage;
		END IF;
		-- build email list
		SET homepageList = CONCAT(homepage,';',homepageList);
	END LOOP getHomepage;

    CLOSE fila;

END;

create
    definer = root@localhost procedure test_cursor2()
BEGIN
    DECLARE finished INTEGER;

    DECLARE homepage varchar(100);
    DECLARE homepageList varchar(100);

    DECLARE fila CURSOR FOR SELECT budget FROM movie_dataset;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    SET homepageList = '';

    OPEN fila;

    getHomepage: LOOP
		FETCH fila INTO homepage;
		IF finished = 1 THEN
			LEAVE getHomepage;
		END IF;
		-- build email list
		SET homepageList = CONCAT(homepage,';',homepageList);
	END LOOP getHomepage;

    CLOSE fila;
    SELECT homepageList;

END;

create
    definer = root@localhost procedure try1(IN nColumJson varchar(250), IN keyJson varchar(250),
                                            IN nameNewT varchar(250), IN nameNewPk varchar(250),
                                            IN nameNewValue varchar(250))
BEGIN
    DECLARE ids INT;
    DECLARE jsons TEXT;
    DECLARE i INT;
    DECLARE jsonRow JSON;

    SELECT `nColumJson` from movie_dataset;

    /*
    DECLARE fila CURSOR FOR SELECT id, `nColumJson` FROM movie_dataset;
    OPEN fila;
    FETCH fila INTO ids, jsons;

     */



    WHILE ids IS NOT NULL DO
        Set i = 0;
        WHILE i < JSON_LENGTH(jsons) DO
            SET jsonRow = JSON_EXTRACT(jsons, CONCAT('$[', i, '].',keyJson));
            SET i = i + 1;
            -- Generate the column dynamically
            SET @sql = CONCAT('INSERT INTO ', nameNewT,' (', nameNewPk ,', ',nameNewValue,') VALUES (', ids, ',',jsonRow,')');
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
        END WHILE;
        -- FETCH fila INTO ids, jsons;
    END WHILE;

-- CLOSE fila;
END;


