def process_entries(input_file, output_file, block_size=900, instruction="COMMIT;"):
    """
    Liest Einträge aus einer Datei, teilt sie in Blöcke und fügt Anweisungen dazwischen ein.
    Am Ende jedes Blocks wird das letzte Komma durch ein Semikolon ersetzt.
    
    Args:
        input_file (str): Pfad zur Eingabedatei
        output_file (str): Pfad zur Ausgabedatei
        block_size (int): Größe der Blöcke (Standard: 900)
        instruction (str): Anweisung, die zwischen den Blöcken eingefügt wird
    """
    try:
        # Einträge aus der Datei lesen
        with open(input_file, 'r', encoding='utf-8') as f:
            entries = f.readlines()
        
        # Datei zum Schreiben öffnen
        with open(output_file, 'w', encoding='utf-8') as f:
            # Durch die Einträge in Blöcken iterieren
            for i in range(0, len(entries), block_size):
                # Aktuellen Block extrahieren
                block = entries[i:i + block_size]
                
                # Das letzte Komma im Block durch Semikolon ersetzen
                if block:  # Prüfen ob der Block nicht leer ist
                    if block[-1].rstrip().endswith(','):
                        block[-1] = block[-1].rstrip()[:-1] + ';\n'
                
                # Block schreiben
                f.writelines(block)
                
                # Anweisung nach jedem Block einfügen (außer nach dem letzten)
                if i + block_size < len(entries):
                    f.write(f"\n{instruction}\n\n")

        print(f"Verarbeitung abgeschlossen. Ausgabe wurde in '{output_file}' gespeichert.")
        print(f"Insgesamt {len(entries)} Einträge in {len(entries) // block_size + 1} Blöcke aufgeteilt.")
        print("In jedem Block wurde das letzte Komma durch ein Semikolon ersetzt.")
        
    except Exception as e:
        print(f"Fehler bei der Verarbeitung: {str(e)}")

# Hier die Argumente setzen:
if __name__ == "__main__":
    # Passen Sie diese Zeile an Ihre Bedürfnisse an:
    process_entries(
        input_file='input.txt',      # Name Ihrer Eingabedatei
        output_file='ausgabe.txt',     # Name der gewünschten Ausgabedatei
        block_size=900,                # Anzahl der Einträge pro Block
        instruction='COMMIT TRANSACTION; BEGIN TRANSACTION; INSERT INTO Ort(PLZ,Ort_Name,ID_BUNDESLAND) WITH (IGNORE_DUP_KEY = ON) VALUES' # Die Anweisung zwischen den Blöcken
    )