USE movie_dataset;

DROP TABLE IF EXISTS director_movies;
CREATE TABLE director_movies(
    IDMov INT,
    IDDirector INT,
    PRIMARY KEY (IDMov, IDDirector),
    FOREIGN KEY (IDMov) REFERENCES movie_dataset(id),
    FOREIGN KEY (IDDirector) REFERENCES crewer_job(IDCrewer)
);


INSERT INTO director_movies
SELECT DISTINCT CJ.IDMov , c.IDCrewer FROM director d, crewer c, crewer_job cj WHERE d.Director_name = c.name
and cj.IDCrewer = c.IDCrewer;

INSERT INTO director_movies
SELECT m.id, c.IDCrewer FROM movie_dataset m, crewer_job c WHERE c.IDJob = 'Director';