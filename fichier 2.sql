
-- 1. Créer la base
CREATE DATABASE IF NOT EXISTS HotelDB;
USE HotelDB;

-- 2. Création des tables
CREATE TABLE Hotel (
    id_Hotel INT PRIMARY KEY,
    Ville VARCHAR(100),
    Pays VARCHAR(100),
    Code_postal INT
);

CREATE TABLE Client (
    id_Client INT PRIMARY KEY,
    Adresse TEXT,
    Ville TEXT,
    Code_postal INT,
    Email TEXT,
    Telephone TEXT,
    Nom_complet TEXT
);

CREATE TABLE Prestation (
    id_Prestation INT PRIMARY KEY,
    Prix DECIMAL(10,2),
    Nom TEXT
);

CREATE TABLE Type_Chambre (
    id_Type INT PRIMARY KEY,
    Type TEXT,
    Tarif DECIMAL(10,2)
);

CREATE TABLE Chambre (
    id_Chambre INT PRIMARY KEY,
    Etage INT,
    Numéro INT,
    Fumeurs BOOLEAN,
    id_Type INT,
    id_Hotel INT,
    FOREIGN KEY (id_Type) REFERENCES Type_Chambre(id_Type),
    FOREIGN KEY (id_Hotel) REFERENCES Hotel(id_Hotel)
);

CREATE TABLE Reservation (
    id_Reservation INT PRIMARY KEY,
    Date_arrivee DATE,
    Date_depart DATE,
    id_Client INT,
    FOREIGN KEY (id_Client) REFERENCES Client(id_Client)
);

CREATE TABLE Evaluation (
    id_Evaluation INT PRIMARY KEY,
    Date_arrivee DATE,
    La_note INT,
    Texte_descriptive TEXT,
    id_Client INT,
    FOREIGN KEY (id_Client) REFERENCES Client(id_Client)
);

-- 3. Insertion des données
INSERT INTO Hotel VALUES
(1, 'Paris', 'France', 75001),
(2, 'Lyon', 'France', 69002);

INSERT INTO Client VALUES
(1, '12 Rue de Paris', 'Paris', 75001, 'jean.dupont@email.fr', '0612345678', 'Jean Dupont'),
(2, '5 Avenue Victor Hugo', 'Lyon', 69002, 'marie.leroy@email.fr', '0623456789', 'Marie Leroy'),
(3, '8 Boulevard Saint-Michel', 'Marseille', 13005, 'paul.moreau@email.fr', '0634567890', 'Paul Moreau'),
(4, '27 Rue Nationale', 'Lille', 59800, 'lucie.martin@email.fr', '0645678901', 'Lucie Martin'),
(5, '3 Rue des Fleurs', 'Nice', 06000, 'emma.giraud@email.fr', '0656789012', 'Emma Giraud');

INSERT INTO Prestation VALUES
(1, 15, 'Petit-déjeuner'),
(2, 30, 'Navette aéroport'),
(3, 0, 'Wi-Fi gratuit'),
(4, 50, 'Spa et bien-être'),
(5, 20, 'Parking sécurisé');

INSERT INTO Type_Chambre VALUES
(1, 'Simple', 80),
(2, 'Double', 120);

INSERT INTO Chambre VALUES
(1, 2, 201, 0, 1, 1),
(2, 5, 502, 1, 1, 2),
(3, 3, 305, 0, 2, 1),
(4, 4, 410, 0, 2, 2),
(5, 1, 104, 1, 2, 2),
(6, 2, 202, 0, 1, 1),
(7, 3, 307, 1, 1, 2),
(8, 1, 101, 0, 1, 1);

INSERT INTO Reservation VALUES
(1, '2025-06-15', '2025-06-18', 1),
(2, '2025-07-01', '2025-07-05', 2),
(3, '2025-08-10', '2025-08-14', 3),
(4, '2025-09-05', '2025-09-07', 4),
(5, '2025-09-20', '2025-09-25', 5),
(6, '2025-10-01', '2025-10-04', 6),
(7, '2025-11-12', '2025-11-14', 2),
(8, '2026-02-01', '2026-02-05', 2),
(9, '2026-01-15', '2026-01-18', 4),
(10, '2026-02-01', '2026-02-05', 2);

INSERT INTO Evaluation VALUES
(1, '2025-06-15', 5, 'Excellent séjour, personnel très accueillant.', 1),
(2, '2025-07-01', 4, 'Chambre propre, bon rapport qualité/prix.', 2),
(3, '2025-08-10', 3, 'Séjour correct mais bruyant la nuit.', 3),
(4, '2025-09-05', 5, 'Service impeccable, je recommande.', 4),
(5, '2025-09-20', 4, 'Très bon petit-déjeuner, hôtel bien situé.', 5);
