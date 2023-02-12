USE movie_dataset;

DROP TABLE IF EXISTS movie_genre;
CREATE TABLE movie_genre(
    IDGenres VARCHAR(250),
   IDMov INT,
   PRIMARY KEY (IDGenres, IDMov),
   FOREIGN KEY (IDGenres) REFERENCES genre(IDGenre),
   FOREIGN KEY (IDMov) REFERENCES movie_dataset(id)
);

INSERT INTO movie_genre
(SELECT DISTINCT REPLACE(SUBSTRING_INDEX(REPLACE(genres,'Science Fiction', 'Science_Fiction'), ' ', -1), 'Science_Fiction', 'Science Fiction'), id
 FROM movie_dataset
 WHERE genres IS NOT NULL
union
SELECT DISTINCT  REPLACE(SUBSTRING_INDEX(REPLACE(genres,'Science Fiction', 'Science_Fiction'), ' ', 1), 'Science_Fiction', 'Science Fiction'), id
FROM movie_dataset
WHERE genres IS NOT NULL);
