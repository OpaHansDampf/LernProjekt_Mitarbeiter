USE [MitarbeiterDB]
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









EXEC SP_InitialQualityCheck;







--prüfung

SELECT 
    m.Vorname + ' ' + m.Nachname AS MitarbeiterName,
    dql.Problem,
    dql.Datum,
    COUNT(p.ID_PHONE) as AnzahlTelefonnummern
FROM DataQualityLog dql
JOIN Mitarbeiter m ON dql.MitarbeiterID = m.ID_Mitarbeiter
LEFT JOIN Phone p ON m.ID_Mitarbeiter = p.ID_Mitarbeiter
GROUP BY m.Vorname, m.Nachname, dql.Problem, dql.Datum
ORDER BY dql.Datum DESC;