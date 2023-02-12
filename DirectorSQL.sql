USE movie_dataset;

DROP TABLE IF EXISTS director;
CREATE TABLE director
(
    Director_name varchar(255) not null
        primary key
);

INSERT INTO director
SELECT DISTINCT (IFNULL(director, ''))
FROM movie_dataset;