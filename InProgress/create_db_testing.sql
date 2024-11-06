CREATE DATABASE MitarbeiterDB
GO

USE MitarbeiterDB;
GO

CREATE TABLE Ort(
    PLZ CHAR(5)
    CONSTRAINT PK_PLZ PRIMARY KEY (PLZ),
    Stadt NVARCHAR(60)
);
GO

CREATE TABLE Adressen(
    ID_ADRESSEN INT IDENTITY
    CONSTRAINT PK_ID_ADRESSEN PRIMARY KEY (ID_ADRESSEN),
    Strasse NVARCHAR(60),
    HausNr NVARCHAR(10),
    PLZ CHAR(5),
    Land NVARCHAR(50),
    CONSTRAINT FK_Adressen_Ort FOREIGN KEY (PLZ)
        REFERENCES Ort (PLZ)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO

CREATE TABLE Geschlecht(
    ID_GESCHLECHT INT
    CONSTRAINT PK_ID_GESCHLECHT PRIMARY KEY (ID_GESCHLECHT),
    Geschlecht_Lang NVARCHAR(50),
    Geschlecht_Kurz NVARCHAR(3)
);
GO

CREATE TABLE Mitarbeiter(
    ID_Mitarbeiter INT IDENTITY
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
    ID_Phone_Type INT IDENTITY
    CONSTRAINT PK_Phone_Type PRIMARY KEY (ID_Phone_Type),
    Type_Kurz NVARCHAR(1),
    Type_Lang NVARCHAR(20)
);
GO

CREATE TABLE Phone(
    ID_PHONE INT IDENTITY
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
    ID_Projekt INT IDENTITY
    CONSTRAINT PK_ID_Projekt PRIMARY KEY (ID_Projekt),
    Projekt_Name NVARCHAR(50),
    Projekt_Nummer INT NOT NULL UNIQUE
);
GO

CREATE TABLE MitarbeiterProjekte(
    ID_Mitarbeiter_Projekt INT IDENTITY
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

CREATE TRIGGER TR_Check_Missing_Data
ON Mitarbeiter
AFTER INSERT, UPDATE
AS
BEGIN
    -- Adress-Check
    INSERT INTO DataQualityLog(MitarbeiterID, Problem)
    SELECT 
        ID_Mitarbeiter,
        'Fehlende Adresse'
    FROM inserted
    WHERE ID_ADRESSEN IS NULL;

    -- Phone-Check
    INSERT INTO DataQualityLog(MitarbeiterID, Problem)
    SELECT 
        i.ID_Mitarbeiter,
        'Keine Telefonnummer vorhanden'
    FROM inserted i
    LEFT JOIN Phone p ON i.ID_Mitarbeiter = p.ID_Mitarbeiter
    WHERE p.ID_Phone IS NULL;
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

CREATE VIEW v_Adressen AS
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