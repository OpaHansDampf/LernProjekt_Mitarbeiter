# 🏢 MitarbeiterDB Projekt 

[![Status](https://img.shields.io/badge/Status-In%20Development-brightgreen)]()
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2019-blue)]()
[![License](https://img.shields.io/badge/License-MIT-yellow)]()

> Ein Lernprojekt zur praktischen Anwendung von Datenbankdesign und -entwicklung, von der Konzeption bis zur Implementierung einer grafischen Benutzeroberfläche.

[🔧 Technische Details und Implementierung finden Sie in der TECHNICAL.md](./TECHNICAL.md)

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
   - C# Integration

5. 🖥️ **Frontend-Entwicklung**
   - GUI für Dateneingabe
   - PLZ-Validierung und Autocomplete
   - Benutzeroberfläche für Abfragen

---

## 📁 Projektstruktur
```
LernProjekt_Mitarbeiter/
├── 📝 README.md
├── 📝 TECHNICAL.md
├── 📂 Dokumentation/
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
│       ├── 📜 view_mitarbeiter_kontakt.sql
│       └── 📜 view_projekt_uebersicht.sql
└── 📂 CSharp/
    ├── 📂 Models/
    └── 📂 Forms/
```

---

## ⚙️ Installation und Setup

### 📋 Voraussetzungen
- 🔷 Microsoft SQL Server 2019 (oder höher)
- 🔷 SQL Server Management Studio (SSMS)
- 🔷 Visual Studio 2022 (für C# Entwicklung)
- 🔷 Mindestens 100MB freier Festplattenspeicher
- 🔷 Serverrolle 'dbcreator'

### 📥 Installationsschritte

#### 1️⃣ Datenbank erstellen
```sql
-- Hauptskript ausführen:
SQL/Create/create_db_advanced.sql   

✨ Enthält:
  ├── Alle Tabellen inkl. neuer Ort-ID
  ├── Indizes
  ├── Trigger
  └── Views
```

#### 2️⃣ Stammdaten einfügen
```sql
-- Stammdaten-Skript ausführen:
SQL/Insert/insert_StammDaten.sql    

📚 Enthält:
  ├── PLZ(DE), Bundesländer(DE), Länder(Weltweit)
  └── Weitere Stammdaten (kontinuierliche Erweiterung)
```

#### 3️⃣ Testdaten einfügen (optional)
```sql
-- Multiple Testdatensätze:
SQL/Insert/insert_multi_Mitarbeiter_bsp.sql

📋 Fügt Testdaten ein:
  ├── 10 Mitarbeiter
  ├── Zugehörige Adressen
  ├── 21 Telefonnummern
  └── 5 Beispielprojekte
```

---

## 💾 Datenbank

### 🏗️ Datenbankdesign

#### Tabellen
| Tabelle | Beschreibung |
|---------|--------------|
| `Mitarbeiter` | 👤 Zentrale Mitarbeiterdaten mit Zeitstempel |
| `Adressen` | 📍 Adressverwaltung |
| `Ort` | 🏘️ PLZ-Stammdaten mit ID |
| `Bundesland` | 🏘️ Bundesländer-Stammdaten |
| `Land` | 🏘️ Länder-Stammdaten |
| `Phone` | 📱 Telefonnummern |
| `Phone_Types` | 📋 Telefontypen |
| `Geschlecht` | 👥 Geschlechter-Stammdaten |
| `Projekte` | 📊 Projektverwaltung |
| `MitarbeiterProjekte` | 🔗 Projekt-Mitarbeiter-Zuordnung |
| `DataQualityLog` | 📈 Qualitätsprotokollierung |

#### 🛡️ Besondere Merkmale
- ✅ Neue ID_ORT als Primary Key
- ✅ PLZ/Ort Validierung durch Composite Unique
- ✅ Referenzielle Integrität durch Fremdschlüssel
- 🔄 Cascading Updates/Deletes wo sinnvoll
- ⏱️ Automatische Zeitstempelaktualisierung
- 📊 Datenqualitätsprüfung durch Trigger
- 🚀 Optimierte Indizes für häufige Abfragen

[Weitere technische Details finden Sie in der TECHNICAL.md](./TECHNICAL.md)

---

## 📋 Datenqualität

### Automatische Prüfungen
- Vollständigkeit der Adressdaten
- PLZ-Validierung
- Gültigkeit der Telefonnummern
- Projektzuordnungen
- Stammdatenreferenzen

### Logging und Monitoring
- Automatische Protokollierung von Problemen
- Qualitätsmetriken
- Korrekturvorschläge

---

## 🚀 Geplante Erweiterungen

### Kurzfristig
- 🖥️ Erweiterte PLZ-Validierung
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