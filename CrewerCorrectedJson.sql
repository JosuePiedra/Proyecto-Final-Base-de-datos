USE movie_dataset;

-- Se crea la tabla crewCorrected.
DROP TABLE IF EXISTS crewCoreccted;
CREATE TABLE crewCoreccted(
    idMov VARCHAR(250),
    crew text
);


/* Se inserta de movie_dataset dos valores. El primer valor id de la película y, el segundo,
   el valor de crew con los replace que se deben realizar. Esto es debido a que el JSON
   tiene problemas
 */

INSERT INTO crewCoreccted
(SELECT id,
CONVERT (
 REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(crew,
   '"', '\''),
   '{\'', '{"'),
  '\': \'', '": "'),
  '\', \'', '", "'),
  '\': ', '": '),
  ', \'', ', "'')
 USING UTF8mb4 )
FROM movie_dataset);
