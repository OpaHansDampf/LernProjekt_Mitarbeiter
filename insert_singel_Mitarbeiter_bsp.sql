-- 1. Erst den Ort anlegen (falls noch nicht vorhanden)
INSERT INTO Ort (PLZ, Stadt)
VALUES ('12345', 'Berlin');

-- 2. Dann die Adresse
INSERT INTO Adressen (Strasse, HausNr, PLZ, Land)
VALUES ('Musterstraße', '42', '12345', 'Deutschland');

-- 3. Den Mitarbeiter anlegen und die ID speichern
DECLARE @MitarbeiterID INT;

INSERT INTO Mitarbeiter (Vorname, Nachname, ID_GESCHLECHT, ID_ADRESSEN)
VALUES ('Max', 'Mustermann', 1, SCOPE_IDENTITY());

SET @MitarbeiterID = SCOPE_IDENTITY();

-- 4. Telefonnummer hinzufügen
INSERT INTO Phone (ID_Mitarbeiter, Phone_Number, Phone_Type)
VALUES (@MitarbeiterID, '+49 123 456789', 'Mobil');

-- 5. Projekt anlegen (falls noch nicht vorhanden)
INSERT INTO Projekte (Projekt_Name, Projekt_Nummer)
VALUES ('Website Relaunch', 2024001);

-- 6. Mitarbeiter dem Projekt zuordnen
INSERT INTO MitarbeiterProjekte (ID_Mitarbeiter, ID_Projekt, Projekt_Stunden)
VALUES (
    @MitarbeiterID,
    (SELECT ID_Projekt FROM Projekte WHERE Projekt_Nummer = 2024001),
    40.00
);