CREATE TABLE vrstvy (
    id SERIAL PRIMARY KEY,
    nazev VARCHAR(100) NOT NULL,
    popis TEXT
);

CREATE TABLE body_zajmu (
    id SERIAL PRIMARY KEY,
    vrstva_id INTEGER REFERENCES vrstvy(id),
    nazev VARCHAR(100) NOT NULL,
    lat DOUBLE PRECISION NOT NULL,
    lng DOUBLE PRECISION NOT NULL,
    text_obsah TEXT,
    obrazek_url VARCHAR(255)
);

-- VLOŽENÍ TESTOVACÍCH DAT (Zítra je promažeš a dáš sem ta reálná)
INSERT INTO vrstvy (nazev, popis) VALUES ('Testovací trasa', 'Zkouška před nasazením reálných dat');

INSERT INTO body_zajmu (vrstva_id, nazev, lat, lng, text_obsah, obrazek_url) VALUES
(1, 'Rektorát UJEP', 50.6655, 14.0322, 'Tady bude zítra reálný text o rektorátu.', 'https://via.placeholder.com/300x200?text=Rektorat'),
(1, 'Menza', 50.6660, 14.0335, 'Zítřejší text o menze.', 'https://via.placeholder.com/300x200?text=Menza');