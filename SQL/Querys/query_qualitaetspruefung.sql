-- DB Namen bei Bedarf anpassen
USE MitarbeiterDB 

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