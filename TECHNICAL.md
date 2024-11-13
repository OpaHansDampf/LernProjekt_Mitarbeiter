# 🔧 MitarbeiterDB - Technische Dokumentation

> Technische Details und Implementierungsrichtlinien für das MitarbeiterDB Projekt.

---

## 📑 Inhaltsverzeichnis
- [💾 Datenbankstruktur](#-datenbankstruktur)
- [🔨 Stored Procedures](#-stored-procedures)
- [📊 Views](#-views)
- [🔄 Trigger](#-trigger)
- [💻 C# Implementierung](#-c-implementierung)
- [🎯 Best Practices](#-best-practices)
- [📈 Qualitätssicherung](#-qualitätssicherung)
- [🚀 Performance-Optimierung](#-performance-optimierung)

---

## 💾 Datenbankstruktur

### Ort-Tabelle mit ID
```sql
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
```

### Wichtige Indexe
```sql
-- Namenssuche für Mitarbeiter
CREATE INDEX IX_Mitarbeiter_Name 
ON Mitarbeiter(Nachname, Vorname);

-- PLZ-Suche für Autocomplete
CREATE INDEX IX_Ort_PLZ 
ON Ort(PLZ);

-- Projektnummernsuche
CREATE INDEX IX_Projekte_Nummer 
ON Projekte(Projekt_Nummer);
```

---

## 🔨 Stored Procedures

### PLZ-Validierung und Suche
```sql
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
```

### Mitarbeiter-Verwaltung
```sql
-- Mitarbeiter anlegen
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
    
    -- Implementation siehe create_db_advanced.sql
END;
```

---

## 📊 Views

### Mitarbeiterdaten
```sql
CREATE OR ALTER VIEW vw_MitarbeiterKontaktdaten AS
SELECT 
    m.ID_Mitarbeiter,
    m.Vorname,
    m.Nachname,
    a.Strasse,
    a.Hausnummer,
    o.PLZ,
    o.Ort_Name,
    l.Land_Name
FROM Mitarbeiter m
LEFT JOIN Adressen a ON m.ID_ADRESSEN = a.ID_ADRESSEN
LEFT JOIN Ort o ON a.ID_ORT = o.ID_ORT
LEFT JOIN Land l ON a.ID_LAND = l.ID_LAND;
```

### Unvollständige Datensätze
```sql
CREATE OR ALTER VIEW vw_UnvollstaendigeMitarbeiter AS
SELECT 
    m.ID_Mitarbeiter,
    m.Vorname,
    m.Nachname,
    CASE 
        WHEN a.ID_ADRESSEN IS NULL THEN 'Fehlend'
        ELSE 'Vorhanden'
    END AS Adressstatus,
    CASE 
        WHEN p.ID_PHONE IS NULL THEN 'Fehlend'
        ELSE 'Vorhanden'
    END AS Telefonstatus
FROM Mitarbeiter m
LEFT JOIN Adressen a ON m.ID_ADRESSEN = a.ID_ADRESSEN
LEFT JOIN Phone p ON m.ID_Mitarbeiter = p.ID_Mitarbeiter
WHERE a.ID_ADRESSEN IS NULL OR p.ID_PHONE IS NULL;
```

---

## 🔄 Trigger

### Zeitstempel-Aktualisierung
```sql
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
```

### Datenqualitätsprüfung
```sql
CREATE TRIGGER TR_Check_Address_Phone
    ON Mitarbeiter
    AFTER INSERT, UPDATE
    AS
    BEGIN
        -- Implementation siehe create_db_advanced.sql
    END;
```

---

## 💻 C# Implementierung

### Grundlegende Modelle
```csharp
public class PLZInfo
{
    public string PLZ { get; set; }
    public string Ort { get; set; }
    public string Bundesland { get; set; }
}

public class Mitarbeiter
{
    public string Vorname { get; set; }
    public string Nachname { get; set; }
    public string Strasse { get; set; }
    public string Hausnummer { get; set; }
    public string PLZ { get; set; }
}
```

### Datenbankzugriff
```csharp
public class MitarbeiterDB
{
    private readonly string connectionString;

    public MitarbeiterDB(string connection)
    {
        connectionString = connection;
    }

    public List<PLZInfo> SuchePLZ(string plzInput)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand("sp_GetPLZInfo", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@SearchTerm", plzInput);

                var ergebnisse = new List<PLZInfo>();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ergebnisse.Add(new PLZInfo
                        {
                            PLZ = reader["PLZ"].ToString(),
                            Ort = reader["Ort_Name"].ToString(),
                            Bundesland = reader["Bundesland_Name"].ToString()
                        });
                    }
                }
                return ergebnisse;
            }
        }
    }

    public int MitarbeiterAnlegen(Mitarbeiter mitarbeiter)
    {
        // Implementation mit Stored Procedure-Aufruf
        // Siehe vorherige Beispiele
    }
}
```

### Error Handling
```csharp
public class MitarbeiterDBException : Exception
{
    public MitarbeiterDBException(string message, Exception innerException) 
        : base(message, innerException) { }
}

public int MitarbeiterAnlegenMitErrorHandling(Mitarbeiter mitarbeiter)
{
    try
    {
        // Implementierung
        return MitarbeiterAnlegen(mitarbeiter);
    }
    catch (SqlException ex)
    {
        throw new MitarbeiterDBException(
            "Fehler beim Anlegen des Mitarbeiters in der Datenbank", ex);
    }
}
```

---

## 🎯 Best Practices

### Datenbankzugriff
1. **Verbindungen**
   - Immer `using` verwenden
   - Connection Pooling nutzen
   - Timeouts definieren

2. **Fehlerbehandlung**
   - Try-Catch Blöcke
   - Transaktionen bei mehreren Operationen
   - Sinnvolle Fehlermeldungen

3. **Performance**
   - Prepared Statements
   - Indexnutzung beachten
   - Unnötige Abfragen vermeiden

### PLZ-Validierung
1. **Eingabevalidierung**
   - Mindestens 3 Zeichen
   - Nur gültige Zeichen
   - Formatierung prüfen

2. **Benutzerführung**
   - Autocomplete anbieten
   - Klare Fehlermeldungen
   - Vorschläge bei Tippfehlern

---

## 📈 Qualitätssicherung

### Datenqualität
- Automatische Validierung durch Trigger
- Logging von Problemen
- Regelmäßige Qualitätsprüfungen

### Code-Qualität
- Einheitliche Namenskonventionen
- Dokumentation wichtiger Stellen
- Testabdeckung

### Performance-Monitoring
- Index-Nutzung überwachen
- Langlaufende Queries identifizieren
- Ressourcenverbrauch kontrollieren

---

## 🚀 Performance-Optimierung

### Indexstrategie
- Sinnvolle Indexauswahl
- Regelmäßige Index-Wartung
- Monitoring der Index-Nutzung

### Query-Optimierung
- Effiziente Joins
- Vermeidung von Table Scans
- Nutzung von Views für komplexe Abfragen

### Allgemeine Tipps
- Batch-Verarbeitung für große Datenmengen
- Caching wo sinnvoll
- Regelmäßige Statistik-Updates

---

## 📚 Weiterführende Ressourcen

- [SQL Server Dokumentation](https://docs.microsoft.com/sql/)
- [C# Coding Conventions](https://docs.microsoft.com/dotnet/csharp/programming-guide/inside-a-program/coding-conventions)
- [Best Practices für Datenbankdesign](https://docs.microsoft.com/sql/relational-databases/design/design-guidance-for-sql-server)