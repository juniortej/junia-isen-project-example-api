-- Création de la base de données
CREATE TABLE Users (
    id_user SERIAL PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL
);

CREATE TABLE Baskets (
    id_basket SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(id_user) ON DELETE CASCADE,
    items TEXT NOT NULL
);

-- Insertion de données
INSERT INTO Users (firstname, lastname) VALUES ('John', 'Doe');
INSERT INTO Users (firstname, lastname) VALUES ('Jane', 'Doe');
INSERT INTO Users (firstname, lastname) VALUES ('Alice', 'Smith');
INSERT INTO Users (firstname, lastname) VALUES ('Bob', 'Smith');

INSERT INTO Baskets (user_id, items) VALUES (1, '1,2,3');
INSERT INTO Baskets (user_id, items) VALUES (2, '4,5,6');
INSERT INTO Baskets (user_id, items) VALUES (3, '1,3,5');
INSERT INTO Baskets (user_id, items) VALUES (4, '2,4,6');