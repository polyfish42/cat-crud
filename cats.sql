CREATE TABLE humans (
  id serial PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES humans (id)
);

CREATE TABLE cats (
  id serial PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES humans (id)
);

CREATE TABLE houses (
  id serial PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (address)
VALUES
  ('26th and Guerrero'), ('Dolores and Market');

INSERT INTO
  humans (fname, lname, house_id)
VALUES
  ('Devon', 'Watts', 1),
  ('Matt', 'Rubens', 1),
  ('Ned', 'Ruggeri', 2),
  ('Catless', 'Human', 2);

INSERT INTO
  cats ( name, owner_id)
VALUES
  ('Breakfast', 1),
  ('Earl', 2),
  ('Haskell', 3),
  ('Markov', 3),
  ('Stray Cat', 1);
