/*
*********************************************************
*                                                       *
*   DATABASE CREATE SCRIPT - PART 1                     *
*                                                       *
*   Enthält:                                           *
*   - Datenbankerstellung                              *
*   - Tabellenerstellung                               *
*   - Primäre Indexe                                   *
*                                                       *
*********************************************************
*/

-- Optional: Datenbank löschen falls vorhanden
/*
IF DB_ID('MitarbeiterDB') IS NOT NULL
BEGIN
    DROP DATABASE MitarbeiterDB;
END
GO
*/

CREATE DATABASE MitarbeiterDB;
GO

USE MitarbeiterDB;
GO

/*
*********************************************************
*   TABELLEN                                             *
*********************************************************
*/

-- Stammdaten-Tabellen
CREATE TABLE Land (
    ID_LAND VARCHAR(2) UNIQUE,
    CONSTRAINT PK_ID_LAND PRIMARY KEY (ID_LAND),
    Land_Name NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE Bundesland (
    ID_BUNDESLAND INT IDENTITY(1,1),
    CONSTRAINT PK_Bundesland PRIMARY KEY (ID_BUNDESLAND),
    Bundesland_Name NVARCHAR(50) NOT NULL,
    ID_LAND VARCHAR(2) NOT NULL,
    CONSTRAINT FK_Bundesland_Land FOREIGN KEY (ID_LAND) 
        REFERENCES Land (ID_LAND)
);
GO

CREATE TABLE Ort (
    ID_ORT INT IDENTITY(1,1),
    CONSTRAINT PK_ID_ORT PRIMARY KEY (ID_ORT),
    PLZ VARCHAR(10) NOT NULL,
    Ort_Name NVARCHAR(60) NOT NULL,
    ID_BUNDESLAND INT NOT NULL,
    CONSTRAINT FK_Ort_Bundesland FOREIGN KEY (ID_BUNDESLAND)
        REFERENCES Bundesland (ID_BUNDESLAND),
    CONSTRAINT UQ_PLZ_Ort UNIQUE (PLZ, Ort_Name)
);
GO

CREATE TABLE Adressen (
    ID_ADRESSEN INT IDENTITY(1,1),
    CONSTRAINT PK_ID_ADRESSEN PRIMARY KEY (ID_ADRESSEN),
    Strasse NVARCHAR(60) NOT NULL,
    Hausnummer VARCHAR(10) NOT NULL,
    Hausnummer_Zusatz VARCHAR(10),
    Adresszusatz NVARCHAR(60),
    ID_ORT INT NOT NULL,
    CONSTRAINT FK_Adressen_Ort FOREIGN KEY (ID_ORT)
        REFERENCES Ort (ID_ORT)
        ON UPDATE CASCADE,
    ID_LAND VARCHAR(2) NOT NULL,
    CONSTRAINT FK_Adressen_Land FOREIGN KEY (ID_LAND)
        REFERENCES Land (ID_LAND)
        ON UPDATE CASCADE
);
GO

CREATE TABLE Geschlecht (
    ID_GESCHLECHT INT IDENTITY(1,1),
    CONSTRAINT PK_ID_GESCHLECHT PRIMARY KEY (ID_GESCHLECHT),
    Geschlecht_Lang NVARCHAR(50),
    Geschlecht_Kurz NVARCHAR(3)
);
GO

CREATE TABLE Mitarbeiter (
    ID_Mitarbeiter INT IDENTITY(1,1),
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
    ID_Phone_Type INT IDENTITY(1,1),
    CONSTRAINT PK_Phone_Type PRIMARY KEY (ID_Phone_Type),
    Type_Kurz NVARCHAR(1),
    Type_Lang NVARCHAR(20)
);
GO

CREATE TABLE Phone (
    ID_PHONE INT IDENTITY(1,1),
    CONSTRAINT PK_ID_PHONE PRIMARY KEY (ID_PHONE),
    ID_Mitarbeiter INT NOT NULL,
    ID_Phone_Type INT NOT NULL,
    CONSTRAINT FK_Phone_Types FOREIGN KEY (ID_Phone_Type)
        REFERENCES Phone_Types (ID_Phone_Type),
    Phone_Number NVARCHAR(40),
    CONSTRAINT FK_Phone_Mitarbeiter FOREIGN KEY (ID_Mitarbeiter) 
        REFERENCES Mitarbeiter (ID_Mitarbeiter)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

CREATE TABLE Projekte (
    ID_Projekt INT IDENTITY(1,1),
    CONSTRAINT PK_ID_Projekt PRIMARY KEY (ID_Projekt),
    Projekt_Name NVARCHAR(50),
    Projekt_Nummer INT NOT NULL UNIQUE
);
GO

CREATE TABLE MitarbeiterProjekte (
    ID_Mitarbeiter_Projekt INT IDENTITY(1,1),
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

/*
*********************************************************
*   INDEXE                                               *
*********************************************************
*/

-- Namenssuche für Mitarbeiter
CREATE INDEX IX_Mitarbeiter_Name 
ON Mitarbeiter(Nachname, Vorname);

-- Projektnummernsuche
CREATE INDEX IX_Projekte_Nummer 
ON Projekte(Projekt_Nummer);

-- PLZ-Suche für Autocomplete
CREATE INDEX IX_Ort_PLZ 
ON Ort(PLZ);
GO

/*
*********************************************************
*   TRIGGER                                              *
*********************************************************
*/

-- Aktualisiert Zeitstempel bei Mitarbeiteränderungen
CREATE TRIGGER TR_Mitarbeiter_UpdateTimestamp
    ON Mitarbeiter
    AFTER UPDATE
    AS
    BEGIN
        UPDATE m
        SET letzte_aenderung = GETDATE()
        FROM Mitarbeiter m
        INNER JOIN inserted i ON m.ID_Mitarbeiter = i.ID_Mitarbeiter;
    END;
GO

-- Prüft Adress- und Telefondaten bei Mitarbeiteränderungen
CREATE OR ALTER TRIGGER TR_Check_Address_Phone
ON [dbo].[Mitarbeiter]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lösche alte Adress-Probleme für betroffene Mitarbeiter
    DELETE FROM DataQualityLog
    WHERE MitarbeiterID IN (SELECT ID_Mitarbeiter FROM inserted)
    AND (Problem = 'Fehlende Adresse' OR Problem = 'Keine Telefonnummer vorhanden');
    
    -- Füge neue Adress-Probleme ein
    INSERT INTO DataQualityLog(MitarbeiterID, Problem)
    SELECT 
        ID_Mitarbeiter,
        'Fehlende Adresse'
    FROM inserted
    WHERE ID_ADRESSEN IS NULL;
    
    -- Füge neue Telefon-Probleme ein
    INSERT INTO DataQualityLog(MitarbeiterID, Problem)
    SELECT DISTINCT 
        m.ID_Mitarbeiter,
        'Keine Telefonnummer vorhanden'
    FROM Mitarbeiter m
    INNER JOIN inserted i ON m.ID_Mitarbeiter = i.ID_Mitarbeiter
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Phone p 
        WHERE p.ID_Mitarbeiter = m.ID_Mitarbeiter
    );
END;
GO

/*
*********************************************************
*   STORED PROCEDURES                                    *
*********************************************************
*/

-- Hilfsfunktion für PLZ-Validierung
CREATE OR ALTER FUNCTION fn_GetOrtID
(
    @PLZ VARCHAR(10),
    @Ort_Name NVARCHAR(60) = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1 ID_ORT
    FROM Ort
    WHERE PLZ = @PLZ
    AND (@Ort_Name IS NULL OR Ort_Name = @Ort_Name)
);
GO

-- Hauptprozedur für Mitarbeiteranlage
CREATE OR ALTER PROCEDURE sp_InsertMitarbeiterMitAdresse
    @Vorname NVARCHAR(40),
    @Nachname NVARCHAR(40),
    @ID_GESCHLECHT INT,
    @Strasse NVARCHAR(60),
    @Hausnummer VARCHAR(10),
    @Hausnummer_Zusatz VARCHAR(10) = NULL,
    @Adresszusatz NVARCHAR(60) = NULL,
    @PLZ VARCHAR(10),
    @ID_LAND VARCHAR(2),
    @ReturnValue INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
            
        -- 1. Prüfe ob PLZ existiert
        DECLARE @ID_ORT INT;
        
        SELECT @ID_ORT = ID_ORT 
        FROM fn_GetOrtID(@PLZ);
        
        IF @ID_ORT IS NULL
        BEGIN
            RAISERROR('Die angegebene PLZ existiert nicht in der Datenbank!', 16, 1);
            RETURN;
        END;

        -- 2. Adresse anlegen
        DECLARE @ID_ADRESSEN INT;
        
        INSERT INTO Adressen (
            Strasse,
            Hausnummer,
            Hausnummer_Zusatz,
            Adresszusatz,
            ID_ORT,
            ID_LAND
        ) VALUES (
            @Strasse,
            @Hausnummer,
            @Hausnummer_Zusatz,
            @Adresszusatz,
            @ID_ORT,
            @ID_LAND
        );
        
        SET @ID_ADRESSEN = SCOPE_IDENTITY();

        -- 3. Mitarbeiter anlegen
        INSERT INTO Mitarbeiter (
            Vorname,
            Nachname,
            ID_ADRESSEN,
            ID_GESCHLECHT
        ) VALUES (
            @Vorname,
            @Nachname,
            @ID_ADRESSEN,
            @ID_GESCHLECHT
        );
        
        SET @ReturnValue = SCOPE_IDENTITY();

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO

-- PLZ-Suche für Autocomplete
CREATE OR ALTER PROCEDURE sp_GetPLZInfo
    @SearchTerm VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        o.PLZ,
        o.Ort_Name,
        b.Bundesland_Name
    FROM Ort o
    INNER JOIN Bundesland b ON o.ID_BUNDESLAND = b.ID_BUNDESLAND
    WHERE o.PLZ LIKE @SearchTerm + '%'
    OR o.Ort_Name LIKE '%' + @SearchTerm + '%'
    ORDER BY o.PLZ;
END;
GO

/*
*********************************************************
*   VIEWS                                               *
*********************************************************
*/

-- Mitarbeiter-Kontaktdaten-Übersicht
CREATE OR ALTER VIEW vw_MitarbeiterKontaktdaten AS
SELECT 
    m.ID_Mitarbeiter,
    m.Vorname,
    m.Nachname,
    a.Strasse,
    a.Hausnummer,
    a.Hausnummer_Zusatz,
    a.Adresszusatz,
    o.PLZ,
    o.Ort_Name,
    l.Land_Name,
    p.Phone_Number,
    pt.Type_Lang AS Phone_Type
FROM Mitarbeiter m
LEFT JOIN Adressen a ON m.ID_ADRESSEN = a.ID_ADRESSEN
LEFT JOIN Ort o ON a.ID_ORT = o.ID_ORT
LEFT JOIN Land l ON a.ID_LAND = l.ID_LAND
LEFT JOIN Phone p ON m.ID_Mitarbeiter = p.ID_Mitarbeiter
LEFT JOIN Phone_Types pt ON p.ID_Phone_Type = pt.ID_Phone_Type;
GO

/*
*********************************************************
*   BEISPIELE                                           *
*********************************************************

-- Neuen Mitarbeiter anlegen:
DECLARE @NewMitarbeiterID INT;
EXEC sp_InsertMitarbeiterMitAdresse
    @Vorname = 'Max',
    @Nachname = 'Mustermann',
    @ID_GESCHLECHT = 1,
    @Strasse = 'Musterstraße',
    @Hausnummer = '1',
    @PLZ = '10115',
    @ID_LAND = 'DE',
    @ReturnValue = @NewMitarbeiterID OUTPUT;

-- PLZ suchen:
EXEC sp_GetPLZInfo '101';

*/