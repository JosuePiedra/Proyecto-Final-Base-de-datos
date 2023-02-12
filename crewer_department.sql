USE movie_dataset;

CREATE TABLE crewer_department(
    IDMov VARCHAR(250) PRIMARY KEY ,
    IDDepartment VARCHAR(250) PRIMARY KEY ,
    IDCrewer VARCHAR(250) PRIMARY KEY,
    FOREIGN KEY (IDMov) REFERENCES movie_dataset(id),
    FOREIGN KEY (IDDepartment) REFERENCES movie_dataset(id),
    FOREIGN KEY (IDCrewer) REFERENCES movie_dataset(id)


)

CREATE TABLE parent_table (
  id INT PRIMARY KEY,
  name VARCHAR(50)
);

CREATE TABLE child_table (
  child_id INT,
  parent_id INT,
  FOREIGN KEY (parent_id) REFERENCES parent_table (id)
);
