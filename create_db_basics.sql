CREATE DATABASE MitarbeiterDB 
GO 

USE MitarbeiterDB;
GO
CREATE TABLE Ort (
    PLZ CHAR(5) CONSTRAINT PK_PLZ PRIMARY KEY (PLZ),
    Ort NVARCHAR (60)
);

GO
CREATE TABLE Adressen (
    ID_ADRESSEN INT IDENTITY CONSTRAINT PK_ID_ADRESSEN PRIMARY KEY (ID_ADRESSEN),
    Strasse NVARCHAR (60),
    HausNr NVARCHAR (10),
    Stadt NVARCHAR (40),
    PLZ CHAR(5),
    Land NVARCHAR (50),
    CONSTRAINT FK_Adressen_Ort FOREIGN KEY (PLZ) REFERENCES Ort (PLZ) ON UPDATE CASCADE ON DELETE CASCADE
);

GO
CREATE TABLE Geschlecht (
    ID_GESCHLECHT INT CONSTRAINT PK_ID_GESCHLECHT PRIMARY KEY (ID_GESCHLECHT),
    Geschlecht_Lang NVARCHAR (50),
    Geschlecht_Kurz NVARCHAR (3)
);

GO
CREATE TABLE Mitarbeiter (
    ID_Mitarbeiter INT IDENTITY CONSTRAINT PK_ID_Mitarbeiter PRIMARY KEY (ID_Mitarbeiter),
    ID_ADRESSEN INT NOT NULL,
    ID_GESCHLECHT INT NOT NULL,
    Vorname NVARCHAR (40),
    Nachname NVARCHAR (40),
    CONSTRAINT FK_Mitarbeiter_Adressen FOREIGN KEY (ID_ADRESSEN) REFERENCES Adressen (ID_ADRESSEN),
    CONSTRAINT FK_Mitarbeiter_Geschlecht FOREIGN KEY (ID_GESCHLECHT) REFERENCES Geschlecht (ID_GESCHLECHT)
);

GO
CREATE TABLE Phone (
    ID_PHONE INT IDENTITY CONSTRAINT PK_ID_PHONE PRIMARY KEY (ID_PHONE),
    ID_Mitarbeiter INT NOT NULL,
    Phone_Number NVARCHAR (40),
    CONSTRAINT FK_Phone_Mitarbeiter FOREIGN KEY (ID_Mitarbeiter) REFERENCES Mitarbeiter (ID_Mitarbeiter) ON DELETE CASCADE ON UPDATE CASCADE
);

GO
CREATE TABLE Projekte (
    ID_Projekt INT IDENTITY CONSTRAINT PK_ID_Projekt PRIMARY KEY (ID_Projekt),
    Projekt_Name NVARCHAR (50),
    Projekt_Nummer INT NOT NULL UNIQUE
);

GO
CREATE TABLE MitarbeiterProjekte (
    ID_Mitarbeiter_Projekt INT IDENTITY CONSTRAINT PK_ID_Mitarbeiter_Projekt PRIMARY KEY (ID_Mitarbeiter_Projekt),
    ID_Mitarbeiter INT NOT NULL,
    ID_Projekt INT NOT NULL,
    Projekt_Stunden DECIMAL(5, 2),
    CONSTRAINT FK_MitarbeiterProjekte_Mitarbeiter FOREIGN KEY (ID_Mitarbeiter) REFERENCES Mitarbeiter (ID_Mitarbeiter),
    CONSTRAINT FK_MitarbeiterProjekte_Projekte FOREIGN KEY (ID_Projekt) REFERENCES Projekte (ID_Projekt)
);

GO
