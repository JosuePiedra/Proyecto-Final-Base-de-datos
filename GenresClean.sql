USE movie_dataset;

SELECT genres FROM movie_dataset WHERE genres LIKE '%Fiction%';

SELECT DISTINCT id, REPLACE(SUBSTRING_INDEX(REPLACE(genres,'Science Fiction', 'Science_Fiction'), ' ', -1), 'Science_Fiction', 'Science Fiction') FROM movie_dataset
union
SELECT DISTINCT  id,REPLACE(SUBSTRING_INDEX(REPLACE(genres,'Science Fiction', 'Science_Fiction'), ' ', 1), 'Science_Fiction', 'Science Fiction') FROM movie_dataset;


