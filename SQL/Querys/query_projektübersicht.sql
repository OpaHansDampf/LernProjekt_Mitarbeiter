-- DB Namen bei Bedarf anpassen
USE MitarbeiterDB 

SELECT 
    p.Projekt_Name,
    p.Projekt_Nummer,
    COUNT(DISTINCT mp.ID_Mitarbeiter) AS AnzahlMitarbeiter,
    SUM(mp.Projekt_Stunden) AS GesamtStunden
FROM Projekte p
LEFT JOIN MitarbeiterProjekte mp ON p.ID_Projekt = mp.ID_Projekt
GROUP BY p.Projekt_Name, p.Projekt_Nummer
ORDER BY p.Projekt_Nummer;