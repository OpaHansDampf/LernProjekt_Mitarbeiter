# 🏢 MitarbeiterDB Projekt 

[![Status](https://img.shields.io/badge/Status-In%20Development-brightgreen)]()
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2019-blue)]()
[![License](https://img.shields.io/badge/License-MIT-yellow)]()

> Ein Lernprojekt zur praktischen Anwendung von Datenbankdesign und -entwicklung, von der Konzeption bis zur Implementierung einer grafischen Benutzeroberfläche.

---

## 📑 Inhaltsverzeichnis
- [🎯 Projektbeschreibung](#-projektbeschreibung)
- [📁 Projektstruktur](#-projektstruktur)
- [⚙️ Installation und Setup](#️-installation-und-setup)
- [💾 Datenbank](#-datenbank)
  - [📊 Entity Relationship Model](#-entity-relationship-model)
  - [🏗️ Datenbankdesign](#️-datenbankdesign)
  - [🔨 Implementierung](#-implementierung)
- [📋 Datenqualität](#-datenqualität)
- [📊 Beispielabfragen](#-beispielabfragen)
- [🚀 Geplante Erweiterungen](#-geplante-erweiterungen)

---

## 🎯 Projektbeschreibung

Das Projekt entstand als Lernprojekt zur Demonstration des vollständigen Entwicklungszyklus einer Datenbankapplikation. Ausgehend von einer Excel-Tabelle wurden folgende Schritte durchgeführt:

### 📌 Entwicklungsphasen
1. 📑 **Analyse der Excel-Daten**
   - Identifikation von Datenfeldern
   - Erkennung von Abhängigkeiten

2. 🔄 **Normalisierung**
   - Erste Normalform (1NF)
   - Zweite Normalform (2NF)
   - Dritte Normalform (3NF)

3. 📐 **Modellierung**
   - Entwicklung des ER-Modells
   - UML Datenbankdesign

4. 💻 **Implementierung**
   - MSSQL Datenbankentwicklung
   - Testdaten-Integration

5. 🖥️ **Frontend-Entwicklung** (geplant)
   - GUI für Dateneingabe
   - Benutzeroberfläche für Abfragen

---

## 📁 Projektstruktur
```
LernProjekt_Mitarbeiter/
├── 📝 README.md
├── 📂 Dokumentation/
│   ├── 📄 Excel_Entwurf.xlsx (COMMING SOON)
│   ├── 📄 ER-Modell.pdf (COMMING SOON)
│   └── 📄 UML-Diagramm.png (NOT FINAL)
├── 📂 SQL/
│   ├── 📂 Create/
│   │   ├── 📜 create_db_advanced.sql
│   │   └── 📜 create_db_basics.sql
│   ├── 📂 Insert/
│   │   ├── 📜 insert_stammdaten.sql
│   │   ├── 📜 insert_multi_mitarbeiter.sql
│   │   └── 📜 insert_single_mitarbeiter.sql
│   └── 📂 Views/
│       ├── 📜 PLACEHOLDER.sql
│       └── 📜 PLACEHOLDER1.sql
└── 📂 GUI/         # Zukünftige GUI-Implementierung
```

---

## ⚙️ Installation und Setup

### 📋 Voraussetzungen
- 🔷 Microsoft SQL Server 2019 (oder höher)
- 🔷 SQL Server Management Studio (SSMS)
- 🔷 Mindestens 100MB freier Festplattenspeicher
- 🔷 Serverrolle 'dbcreator'

### 📥 Installationsschritte

#### 1️⃣ Datenbank erstellen
```sql
-- Hauptskript ausführen:
SQL/Create/create_db_advanced.sql   

✨ Enthält:
  ├── Alle Tabellen
  ├── Indizes
  ├── Trigger
  ├── Views
  └── Initiale Stammdaten
      ├── Geschlecht
      └── Phone_Types
```

#### 2️⃣ Stammdaten einfügen
```sql
-- Stammdaten-Skript ausführen:
SQL/Insert/insert_StammDaten.sql    

📚 Enthält und wird erweitert um:
  ├── PLZ-Verzeichnis
  └── Weitere Stammdaten (kontinuierliche Erweiterung)
```

#### 3️⃣ Testdaten einfügen (optional)

##### Option A: Einzelner Testdatensatz
```sql
SQL/Insert/insert_single_Mitarbeiter_bsp.sql

📋 Fügt einen vollständigen Datensatz ein:
  ├── Persönliche Daten
  ├── Adresse
  ├── Telefonnummer
  └── Projektzuordnung
```

##### Option B: Multiple Testdatensätze
```sql
SQL/Insert/insert_multi_Mitarbeiter_bsp.sql

📋 Fügt 10 komplette Datensätze ein:
  ├── 10 Mitarbeiter
  ├── Zugehörige Adressen
  ├── 21 Telefonnummern
  ├── 5 Beispielprojekte
  └── Projektzuordnungen mit Stunden
```

---

## 💾 Datenbank

### 📊 Entity Relationship Model
(COMMING SOON) Das ER-Modell finden Sie in der Dokumentation unter `Dokumentation/ER-Modell.pdf`

### 🏗️ Datenbankdesign
(COMMING SOON) 
#### Tabellen
| Tabelle | Beschreibung |
|---------|--------------|
| `Mitarbeiter` | 👤 Zentrale Mitarbeiterdaten mit Zeitstempel |
| `Adressen` | 📍 Adressverwaltung |
| `Ort` | 🏘️ PLZ-Stammdaten |
| `Phone` | 📱 Telefonnummern |
| `Phone_Types` | 📋 Telefontypen (mobil, privat, geschäftlich) |
| `Geschlecht` | 👥 Geschlechter-Stammdaten |
| `Projekte` | 📊 Projektverwaltung |
| `MitarbeiterProjekte` | 🔗 Projekt-Mitarbeiter-Zuordnung |
| `DataQualityLog` | 📈 Qualitätsprotokollierung |

#### 🛡️ Besondere Merkmale
- ✅ Referenzielle Integrität durch Fremdschlüssel
- 🔄 Cascading Updates/Deletes wo sinnvoll
- ⏱️ Automatische Zeitstempelaktualisierung
- 📊 Datenqualitätsprüfung durch Trigger
- 🚀 Optimierte Indizes für häufige Abfragen
- 👁️ Views für Datenqualitätsmonitoring

### 🔨 Implementierung

#### Funktionen

1. **Zeitstempel-Management**
   - Trigger für automatische Aktualisierung
   - Nachverfolgung von Änderungen

2. **Datenqualitätssicherung**
   - Automatische Prüfungen
   - Logging von Problemen
   - Vollständigkeitsprüfungen

3. **Monitoring Views**
   - Übersicht fehlender Daten
   - Qualitätsmetriken
   - Adressvalidierung

4. **Performance-Optimierung**
   - Strategische Indizierung
   - Optimierte Abfragen
   - Effiziente Datenstrukturen

---

## 📋 Datenqualität

### Automatische Prüfungen
- Vollständigkeit der Adressdaten
- Gültigkeit der Telefonnummern
- Projektzuordnungen
- Stammdatenreferenzen

### Logging und Monitoring
- Automatische Protokollierung von Problemen
- Qualitätsmetriken
- Korrekturvorschläge

---

## 📊 Beispielabfragen

### 1️⃣ Mitarbeiter mit Kontaktdaten
```sql
SELECT 
    m.Vorname + ' ' + m.Nachname AS MitarbeiterName,
    a.Strasse + ' ' + a.HausNr AS Adresse,
    o.PLZ + ' ' + o.Stadt AS Ort,
    p.Phone_Number,
    pt.Type_Lang AS TelefonTyp
FROM Mitarbeiter m
LEFT JOIN Adressen a ON m.ID_ADRESSEN = a.ID_ADRESSEN
LEFT JOIN Ort o ON a.PLZ = o.PLZ
LEFT JOIN Phone p ON m.ID_Mitarbeiter = p.ID_Mitarbeiter
LEFT JOIN Phone_Types pt ON p.ID_Phone_Type = pt.ID_Phone_Type
ORDER BY m.Nachname, m.Vorname;
```

### 2️⃣ Projektübersicht
```sql
SELECT 
    p.Projekt_Name,
    p.Projekt_Nummer,
    COUNT(DISTINCT mp.ID_Mitarbeiter) AS AnzahlMitarbeiter,
    SUM(mp.Projekt_Stunden) AS GesamtStunden
FROM Projekte p
LEFT JOIN MitarbeiterProjekte mp ON p.ID_Projekt = mp.ID_Projekt
GROUP BY p.Projekt_Name, p.Projekt_Nummer
ORDER BY p.Projekt_Nummer;
```

### 3️⃣ Qualitätsprüfung
```sql
SELECT 
    m.Vorname + ' ' + m.Nachname AS MitarbeiterName,
    dql.Problem,
    dql.Datum
FROM DataQualityLog dql
JOIN Mitarbeiter m ON dql.MitarbeiterID = m.ID_Mitarbeiter
ORDER BY dql.Datum DESC;
```

---

## 🚀 Geplante Erweiterungen

### Kurzfristig
- 🖥️ Entwicklung der GUI
- 📊 Erweiterung der Berichtsoptionen
- 📋 Integration zusätzlicher Datenfelder

### Mittelfristig
- 📱 Mobile Ansicht
- 🔍 Erweiterte Suchfunktionen
- 📈 Datenanalyse-Tools

### Langfristig
- 🔄 API-Integration
- 🔐 Erweiterte Sicherheitsfunktionen
- 🌐 Multi-Mandanten-Fähigkeit

---

[![Made with ❤️](https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-red)]()