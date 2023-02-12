USE movie_dataset;

DROP TABLE IF EXISTS genre;
CREATE TABLE genre(
  IDGenre VARCHAR(250) PRIMARY KEY
);

SELECT DISTINCT id, REPLACE(SUBSTRING_INDEX(REPLACE(genres,'Science Fiction', 'Science_Fiction'), ' ', -1), 'Science_Fiction', 'Science Fiction') FROM movie_dataset
union
SELECT DISTINCT  id,REPLACE(SUBSTRING_INDEX(REPLACE(genres,'Science Fiction', 'Science_Fiction'), ' ', 1), 'Science_Fiction', 'Science Fiction') FROM movie_dataset;


