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