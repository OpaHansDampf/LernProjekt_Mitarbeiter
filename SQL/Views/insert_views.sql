/*
*********************************************************
*                                                       *
*   DATABASE VIEWS SCRIPT                               *
*                                                       *
*   Script zum erstellen der Views zur Datenbank        *
*   bitte ansehen und bei Bedarf ändern,                *
*   bei änderungen ist es möglich das                   *
*   an allen Scripten diese gemacht werden müssen.      *
*                                                       *
*********************************************************
*/

-- View: Mitarbeiter mit allen Projektbeteiligungen
CREATE VIEW vw_MitarbeiterProjekte AS
SELECT 
    m.ID_Mitarbeiter,
    m.Vorname,
    m.Nachname,
    p.ID_Projekt,
    p.Projekt_Name,
    mp.Projekt_Stunden
FROM Mitarbeiter m
INNER JOIN MitarbeiterProjekte mp ON m.ID_Mitarbeiter = mp.ID_Mitarbeiter
INNER JOIN Projekte p ON mp.ID_Projekt = p.ID_Projekt;
GO

-- View: Mitarbeiter mit Adresse und Telefonnummer
CREATE VIEW vw_MitarbeiterKontaktdaten AS
SELECT 
    m.ID_Mitarbeiter,
    m.Vorname,
    m.Nachname,
    a.Strasse,
    a.Hausnummer,
    a.Hausnummer_Zusatz,
    a.Adresszusatz,
    a.PLZ,
    o.Ort_Name,
    l.Land_Name,
    p.Phone_Number,
    pt.Type_Lang AS Phone_Type
FROM Mitarbeiter m
LEFT JOIN Adressen a ON m.ID_ADRESSEN = a.ID_ADRESSEN
LEFT JOIN Ort o ON a.PLZ = o.PLZ
LEFT JOIN Land l ON a.ID_LAND = l.ID_LAND
LEFT JOIN Phone p ON m.ID_Mitarbeiter = p.ID_Mitarbeiter
LEFT JOIN Phone_Types pt ON p.ID_Phone_Type = pt.ID_Phone_Type;
GO

-- View: Projekte ohne Mitarbeiterzuordnung
CREATE VIEW vw_ProjekteOhneMitarbeiter AS
SELECT 
    p.ID_Projekt,
    p.Projekt_Name,
    p.Projekt_Nummer
FROM Projekte p
LEFT JOIN MitarbeiterProjekte mp ON p.ID_Projekt = mp.ID_Projekt
WHERE mp.ID_Projekt IS NULL;
GO

-- View: Mitarbeiter mit Geschlecht
CREATE VIEW vw_MitarbeiterMitGeschlecht AS
SELECT 
    m.ID_Mitarbeiter,
    m.Vorname,
    m.Nachname,
    g.Geschlecht_Lang,
    g.Geschlecht_Kurz
FROM Mitarbeiter m
INNER JOIN Geschlecht g ON m.ID_GESCHLECHT = g.ID_GESCHLECHT;
GO

-- View: Adressen mit zugehörigem Bundesland und Land
CREATE VIEW vw_AdressenMitDetails AS
SELECT 
    a.ID_ADRESSEN,
    a.Strasse,
    a.Hausnummer,
    a.Hausnummer_Zusatz,
    a.Adresszusatz,
    a.PLZ,
    o.Ort_Name,
    b.Bundesland_Name,
    l.Land_Name
FROM Adressen a
INNER JOIN Ort o ON a.PLZ = o.PLZ
INNER JOIN Bundesland b ON o.ID_BUNDESLAND = b.ID_BUNDESLAND
INNER JOIN Land l ON a.ID_LAND = l.ID_LAND;
GO

-- View: Mitarbeiter ohne Adresse
CREATE VIEW vw_MitarbeiterOhneAdresse AS
SELECT 
    m.ID_Mitarbeiter,
    m.Vorname,
    m.Nachname,
    m.letzte_aenderung
FROM Mitarbeiter m
WHERE m.ID_ADRESSEN IS NULL;
GO

-- View: Mitarbeiter ohne Telefonnummer
CREATE VIEW vw_MitarbeiterOhneTelefon AS
SELECT 
    m.ID_Mitarbeiter,
    m.Vorname,
    m.Nachname,
    m.letzte_aenderung
FROM Mitarbeiter m
LEFT JOIN Phone p ON m.ID_Mitarbeiter = p.ID_Mitarbeiter
WHERE p.ID_PHONE IS NULL;
GO

-- View: Mitarbeiter unvollständig (ohne Adresse oder Telefonnummer)
CREATE VIEW vw_MitarbeiterUnvollstaendig AS
SELECT 
    m.ID_Mitarbeiter,
    m.Vorname,
    m.Nachname,
    m.letzte_aenderung,
    CASE 
        WHEN m.ID_ADRESSEN IS NULL THEN 1 
        ELSE 0 
    END AS [Adresse_fehlt],
    CASE 
        WHEN p.ID_PHONE IS NULL THEN 1 
        ELSE 0 
    END AS [Telefon_fehlt]
FROM Mitarbeiter m
LEFT JOIN Phone p ON m.ID_Mitarbeiter = p.ID_Mitarbeiter;
GO
