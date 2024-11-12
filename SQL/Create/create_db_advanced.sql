CREATE DATABASE MitarbeiterDB
GO

USE MitarbeiterDB;
GO

CREATE TABLE Land (
    ID_LAND INT IDENTITY(1,1),
    Land_Name NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE Bundesland (
    ID_BUNDESLAND INT IDENTITY(1,1),
        CONSTRAINT PK_Bundesland PRIMARY KEY (ID_BUNDESLAND),
    Bundesland_Name NVARCHAR(50) NOT NULL,
        CONSTRAINT FK_Bundesland_Land FOREIGN KEY (ID_LAND) 
            REFERENCES Land (ID_LAND)
);
GO

CREATE TABLE Ort (
    PLZ VARCHAR(10)
    CONSTRAINT PF_PLZ PRIMARY KEY (PLZ),
    Ort_Name NVARCHAR(60) NOT NULL,
    ID_BUNDESLAND INT NOT NULL,
        CONSTRAINT FK_Ort_Bundesland FOREIGN KEY (ID_BUNDESLAND)
            REFERENCES Bundesland (ID_BUNDESLAND)
);
GO

CREATE TABLE Adressen (
    ID_ADRESSEN INT IDENTITY(1,1)
        CONSTRAINT PK_ID_ADRESSEN PRIMARY KEY (ID_ADRESSEN),
    Strasse NVARCHAR(60) NOT NULL,
    Hausnummer VARCHAR(10) NOT NULL,
    Hausnummer_Zusatz VARCHAR(10),
    Adresszusatz NVARCHAR(60),
    PLZ VARCHAR(10) NOT NULL,
        CONSTRAINT FK_Adressen_Ort FOREIGN KEY (PLZ)
            REFERENCES Ort (PLZ)
                ON UPDATE CASCADE
);
GO

CREATE TABLE Geschlecht(
    ID_GESCHLECHT INT IDENTITY(1,1)
    CONSTRAINT PK_ID_GESCHLECHT PRIMARY KEY (ID_GESCHLECHT),
    Geschlecht_Lang NVARCHAR(50),
    Geschlecht_Kurz NVARCHAR(3)
);
GO

CREATE TABLE Mitarbeiter(
    ID_Mitarbeiter INT IDENTITY(1,1)
    CONSTRAINT PK_ID_Mitarbeiter PRIMARY KEY (ID_Mitarbeiter),
    ID_ADRESSEN INT NULL,
    ID_GESCHLECHT INT NOT NULL,
    Vorname NVARCHAR(40),
    Nachname NVARCHAR(40),
    letzte_aenderung DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Mitarbeiter_Adressen FOREIGN KEY (ID_ADRESSEN) 
        REFERENCES Adressen (ID_ADRESSEN),
    CONSTRAINT FK_Mitarbeiter_Geschlecht FOREIGN KEY (ID_GESCHLECHT) 
        REFERENCES Geschlecht (ID_GESCHLECHT)
);
GO

CREATE TABLE Phone_Types (
    ID_Phone_Type INT IDENTITY(1,1)
    CONSTRAINT PK_Phone_Type PRIMARY KEY (ID_Phone_Type),
    Type_Kurz NVARCHAR(1),
    Type_Lang NVARCHAR(20)
);
GO

CREATE TABLE Phone(
    ID_PHONE INT IDENTITY(1,1)
    CONSTRAINT PK_ID_PHONE PRIMARY KEY (ID_PHONE),
    ID_Mitarbeiter INT NOT NULL,
    ID_Phone_Type INT NOT NULL
    CONSTRAINT FK_Phone_Types FOREIGN KEY (ID_Phone_Type)
        REFERENCES Phone_Types (ID_Phone_Type),
    Phone_Number NVARCHAR(40),
    CONSTRAINT FK_Phone_Mitarbeiter FOREIGN KEY (ID_Mitarbeiter) 
        REFERENCES Mitarbeiter (ID_Mitarbeiter)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

CREATE TABLE Projekte(
    ID_Projekt INT IDENTITY(1,1)
    CONSTRAINT PK_ID_Projekt PRIMARY KEY (ID_Projekt),
    Projekt_Name NVARCHAR(50),
    Projekt_Nummer INT NOT NULL UNIQUE
);
GO

CREATE TABLE MitarbeiterProjekte(
    ID_Mitarbeiter_Projekt INT IDENTITY(1,1)
    CONSTRAINT PK_ID_Mitarbeiter_Projekt PRIMARY KEY (ID_Mitarbeiter_Projekt),
    ID_Mitarbeiter INT NOT NULL,
    ID_Projekt INT NOT NULL,
    Projekt_Stunden DECIMAL(5,2),
    CONSTRAINT FK_MitarbeiterProjekte_Mitarbeiter FOREIGN KEY (ID_Mitarbeiter) 
        REFERENCES Mitarbeiter (ID_Mitarbeiter),
    CONSTRAINT FK_MitarbeiterProjekte_Projekte FOREIGN KEY (ID_Projekt) 
        REFERENCES Projekte (ID_Projekt)
);
GO

CREATE TABLE DataQualityLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    MitarbeiterID INT,
    Problem NVARCHAR(200),
    Datum DATETIME2 DEFAULT GETDATE()
);
GO

CREATE INDEX IX_Mitarbeiter_Name ON Mitarbeiter(Nachname, Vorname);
CREATE INDEX IX_Projekte_Nummer ON Projekte(Projekt_Nummer);
CREATE INDEX IX_Ort_PLZ ON Ort(PLZ);
GO

CREATE TRIGGER TR_Mitarbeiter_UpdateTimestamp
    ON Mitarbeiter
    AFTER UPDATE
    AS
    BEGIN
        UPDATE Mitarbeiter
        SET letzte_aenderung = GETDATE()
        FROM Mitarbeiter m
        INNER JOIN inserted i ON m.ID_Mitarbeiter = i.ID_Mitarbeiter
    END;
GO

-- Trigger für Mitarbeiter (prüft nur Adressen)
CREATE OR ALTER TRIGGER TR_Check_Address
ON [dbo].[Mitarbeiter]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lösche alte Adress-Probleme für betroffene Mitarbeiter
    DELETE FROM DataQualityLog
    WHERE MitarbeiterID IN (SELECT ID_Mitarbeiter FROM inserted)
    AND Problem = 'Fehlende Adresse';
    
    -- Füge neue Adress-Probleme ein
    INSERT INTO DataQualityLog(MitarbeiterID, Problem)
    SELECT 
        ID_Mitarbeiter,
        'Fehlende Adresse'
    FROM inserted
    WHERE ID_ADRESSEN IS NULL;
END;
GO

-- Trigger für Phone-Tabelle
CREATE OR ALTER TRIGGER TR_Check_Phone
ON [dbo].[Phone]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Sammle alle betroffenen Mitarbeiter-IDs
    DECLARE @AffectedEmployees TABLE (ID_Mitarbeiter INT);
    
    INSERT INTO @AffectedEmployees (ID_Mitarbeiter)
    SELECT ID_Mitarbeiter FROM inserted
    UNION
    SELECT ID_Mitarbeiter FROM deleted;
    
    -- Lösche alte Telefon-Probleme für betroffene Mitarbeiter
    DELETE FROM DataQualityLog
    WHERE MitarbeiterID IN (SELECT ID_Mitarbeiter FROM @AffectedEmployees)
    AND Problem = 'Keine Telefonnummer vorhanden';
    
    -- Füge neue Telefon-Probleme ein
    INSERT INTO DataQualityLog(MitarbeiterID, Problem)
    SELECT DISTINCT 
        m.ID_Mitarbeiter,
        'Keine Telefonnummer vorhanden'
    FROM Mitarbeiter m
    INNER JOIN @AffectedEmployees ae ON m.ID_Mitarbeiter = ae.ID_Mitarbeiter
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Phone p 
        WHERE p.ID_Mitarbeiter = m.ID_Mitarbeiter
    );
END;
GO

-- Optional: Initialer Check für alle bestehenden Datensätze
CREATE OR ALTER PROCEDURE SP_InitialQualityCheck
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lösche alte Qualitätsprobleme
    TRUNCATE TABLE DataQualityLog;
    
    -- Prüfe fehlende Adressen
    INSERT INTO DataQualityLog(MitarbeiterID, Problem)
    SELECT 
        ID_Mitarbeiter,
        'Fehlende Adresse'
    FROM Mitarbeiter
    WHERE ID_ADRESSEN IS NULL;
    
    -- Prüfe fehlende Telefonnummern
    INSERT INTO DataQualityLog(MitarbeiterID, Problem)
    SELECT 
        m.ID_Mitarbeiter,
        'Keine Telefonnummer vorhanden'
    FROM Mitarbeiter m
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Phone p 
        WHERE p.ID_Mitarbeiter = m.ID_Mitarbeiter
    );
END;
GO

CREATE VIEW vw_MitarbeiterOhneAdresse AS
SELECT 
    ID_Mitarbeiter,
    Vorname,
    Nachname,
    letzte_aenderung
FROM Mitarbeiter
WHERE ID_ADRESSEN IS NULL;
GO

CREATE VIEW vw_MitarbeiterOhneTelefon AS
SELECT 
    m.ID_Mitarbeiter,
    m.Vorname,
    m.Nachname,
    m.letzte_aenderung
FROM Mitarbeiter m
LEFT JOIN Phone p ON m.ID_Mitarbeiter = p.ID_Mitarbeiter
WHERE p.ID_Phone IS NULL;
GO

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
        WHEN p.ID_Phone IS NULL THEN 1 
        ELSE 0 
    END AS [Telefon_fehlt]
FROM Mitarbeiter m
LEFT JOIN Phone p ON m.ID_Mitarbeiter = p.ID_Mitarbeiter;
GO

CREATE VIEW vw_Adressen AS
SELECT 
    a.ID_ADRESSEN,
    a.Strasse,
    a.HausNr,
    a.PLZ,
    o.Stadt,
    a.Land
FROM Adressen a
INNER JOIN Ort o ON a.PLZ = o.PLZ;
GO

-- Initiale Geschlechtsdaten einfügen
INSERT INTO Geschlecht (ID_GESCHLECHT, Geschlecht_Lang, Geschlecht_Kurz)
VALUES 
    (1, 'Männlich', 'm'),
    (2, 'Weiblich', 'w'),
    (3, 'Divers', 'd');
GO

-- Initiale Phone_Types einfügen
INSERT INTO Phone_Types (Type_Kurz, Type_Lang) VALUES
('m', 'Mobil'),
('p', 'Privat'),
('g', 'Geschäftlich');
GO