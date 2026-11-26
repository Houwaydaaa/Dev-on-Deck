CREATE TABLE IF NOT EXISTS gouvernorat (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS utilisateur (
    id SERIAL PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    mot_de_passe_hache VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS developpeur (
    id INTEGER PRIMARY KEY REFERENCES utilisateur(id) ON DELETE CASCADE,
    prenom VARCHAR(80) NOT NULL,
    nom VARCHAR(80) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    ville VARCHAR(100) NOT NULL,
    gouvernorat_id INTEGER NOT NULL REFERENCES gouvernorat(id)
);

CREATE TABLE IF NOT EXISTS organisation (
    id INTEGER PRIMARY KEY REFERENCES utilisateur(id) ON DELETE CASCADE,
    nom_organisation VARCHAR(150) NOT NULL,
    prenom_contact VARCHAR(80) NOT NULL,
    nom_contact VARCHAR(80) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    ville VARCHAR(100) NOT NULL,
    gouvernorat_id INTEGER NOT NULL REFERENCES gouvernorat(id)
);

INSERT INTO gouvernorat (nom) VALUES
('Ariana'), ('Béja'), ('Ben Arous'), ('Bizerte'), ('Gabès'), ('Gafsa'),
('Jendouba'), ('Kairouan'), ('Kasserine'), ('Kébili'), ('Le Kef'), ('Mahdia'),
('La Manouba'), ('Médenine'), ('Monastir'), ('Nabeul'), ('Sfax'), ('Sidi Bouzid'),
('Siliana'), ('Sousse'), ('Tataouine'), ('Tozeur'), ('Tunis'), ('Zaghouan')
ON CONFLICT (nom) DO NOTHING;
