SELECT 
    m.Vorname + ' ' + m.Nachname AS MitarbeiterName,
    dql.Problem,
    dql.Datum
FROM DataQualityLog dql
JOIN Mitarbeiter m ON dql.MitarbeiterID = m.ID_Mitarbeiter
ORDER BY dql.Datum DESC;