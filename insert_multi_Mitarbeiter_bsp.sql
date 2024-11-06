USE MitarbeiterDB;
GO

-- Orte einfügen (Falls nicht vorhanden)
INSERT INTO Ort (PLZ, Stadt) VALUES 
('10115', 'Berlin'),
('20095', 'Hamburg'),
('80331', 'München'),
('50667', 'Köln'),
('60313', 'Frankfurt'),
('70173', 'Stuttgart'),
('04109', 'Leipzig'),
('30159', 'Hannover'),
('40213', 'Düsseldorf'),
('28195', 'Bremen');

-- Adressen einfügen
INSERT INTO Adressen (Strasse, HausNr, PLZ, Land) VALUES 
('Hauptstraße', '1', '10115', 'Deutschland'), -- ID 1
('Hafenstraße', '23', '20095', 'Deutschland'), -- ID 2
('Marienplatz', '8', '80331', 'Deutschland'), -- ID 3
('Domstraße', '15', '50667', 'Deutschland'), -- ID 4
('Zeil', '127', '60313', 'Deutschland'), -- ID 5
('Königstraße', '45', '70173', 'Deutschland'), -- ID 6
('Augustusplatz', '3', '04109', 'Deutschland'), -- ID 7
('Georgstraße', '19', '30159', 'Deutschland'), -- ID 8
('Königsallee', '56', '40213', 'Deutschland'), -- ID 9
('Böttcherstraße', '12', '28195', 'Deutschland'); -- ID 10 

-- Mitarbeiter einfügen (mit Geschlecht)
-- prüfen ob richtiges Geschlecht vorhanden ist, ansonsten vorher anlegen
INSERT INTO Mitarbeiter (Vorname, Nachname, ID_ADRESSEN, ID_GESCHLECHT) VALUES 
('Max', 'Mustermann', 1, 1),
('Anna', 'Schmidt', 2, 2),
('Thomas', 'Weber', 3, 1),
('Laura', 'Meyer', 4, 2),
('Michael', 'Wagner', 5, 1),
('Sarah', 'Becker', 6, 2),
('Daniel', 'Koch', 7, 1),
('Julia', 'Fischer', 8, 2),
('Alexander', 'Schulz', 9, 1),
('Lisa', 'Hoffmann', 10, 2);

-- Telefonnummern einfügen mit korrekten Spaltennamen
-- prüfen ob richtiger Phone_Type vorhanden ist, ansonsten vorher anlegen
INSERT INTO Phone (ID_Mitarbeiter, Phone_Number, ID_Phone_Type) VALUES 
(1, '030 12345678', 2),  
(1, '0151 11111111', 1),
(2, '040 23456789', 2),
(2, '0176 23456789', 1),
(2, '040 34567890', 3),
(3, '089 34567890', 2),
(3, '0162 34567890', 1),
(4, '0221 45678901', 2),
(4, '0177 45678901', 1),
(5, '069 56789012', 3),
(5, '0152 56789012', 1),
(6, '0711 67890123', 2),
(6, '0163 67890123', 1),
(7, '0341 78901234', 2),
(7, '0178 78901234', 1),
(8, '0511 89012345', 3),
(8, '0155 89012345', 1),
(9, '0211 90123456', 2),
(9, '0165 90123456', 1),
(10, '0421 01234567', 2),
(10, '0170 01234567', 1);

-- Projekte einfügen
INSERT INTO Projekte (Projekt_Name, Projekt_Nummer) VALUES 
('Webseitenrelaunch', 1001),
('Mobile App', 1002),
('Datenmigration', 1003),
('KI-Integration', 1004),
('Cloud Migration', 1005);

-- Mitarbeiter-Projekte Zuordnung mit Stunden
INSERT INTO MitarbeiterProjekte (ID_Mitarbeiter, ID_Projekt, Projekt_Stunden) VALUES 
(1, 1, 20.5),  -- Max Mustermann im Webseitenrelaunch
(1, 2, 15.0),  -- Max Mustermann auch in Mobile App
(2, 1, 30.0),  -- Anna Schmidt im Webseitenrelaunch
(3, 2, 40.0),  -- Thomas Weber in Mobile App
(4, 3, 25.5),  -- Laura Meyer in Datenmigration
(5, 3, 35.0),  -- Michael Wagner in Datenmigration
(6, 4, 22.5),  -- Sarah Becker in KI-Integration
(7, 4, 28.0),  -- Daniel Koch in KI-Integration
(8, 5, 32.5),  -- Julia Fischer in Cloud Migration
(9, 5, 18.0),  -- Alexander Schulz in Cloud Migration
(10, 1, 15.5); -- Lisa Hoffmann im Webseitenrelaunch