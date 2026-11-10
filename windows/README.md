# Windows – Cheat Engine

[← Alle Spiele / all games](../README.md)

**Deutsch** · [English](#english)

*Gilt für alle Spiele in diesem Repo (Beispielwerte: Pizza Inc.). /
Applies to all games in this repo (example values: Pizza Inc.).*

---

## Deutsch

### 1. Vorbereiten

1. Spiel öffnen: <https://www.youtube.com/playables/Ugkxto-OwJZo4rm8Xl2Nj3K403nHlYThf-sr>
2. Geldstand oben rechts notieren (z. B. `750`).
3. [Cheat Engine](https://www.cheatengine.org/) installieren (bei der
   Installation die mitgelieferten Zusatzprogramme abwählen).

### 2. Den richtigen Prozess finden

Firefox hat **mehrere** `firefox.exe`-Prozesse. Das Spiel läuft in einem
**Content Process**, nicht im Hauptprozess.

1. Task-Manager → Reiter **Details**.
2. Nach `firefox.exe` sortieren und **den Prozess mit dem größten
   Arbeitsspeicher** nehmen (das Spiel belegt ~800 MB–1 GB, der Hauptprozess
   deutlich weniger).
3. In Cheat Engine: **Open Process** → genau diesen `firefox.exe` auswählen.

> Tipp: Der richtige Prozess hat im Reiter „Leistung"/„Details" den größten
> Arbeitssatz. Wenn du unsicher bist, schließe andere Tabs und vergleiche.

### 3. Scannen

1. **Value Type:** `4 Bytes`
2. **First Scan** mit dem aktuellen Wert, z. B. `750`.
3. Im Spiel etwas kaufen oder verkaufen, sodass sich das Geld ändert
   (z. B. auf `650`).
4. Neuen Wert eintragen → **Next Scan**.
5. Es sollte **genau eine** Adresse übrig bleiben.

Falls nicht:

- Wert noch einmal ändern und erneut **Next Scan** mit dem neuen Betrag.
- Wenn `4 Bytes` gar nichts findet: **Value Type** auf `8 Bytes` stellen und
  von vorn beginnen.
- Immer nur **eine** Adresse am Ende beschreiben – nicht hunderte Treffer
  gleichzeitig ändern (das kann den Tab abstürzen lassen).

### 4. Wert setzen / einfrieren

1. Adresse per Doppelklick in die Liste unten übernehmen.
2. Wert markieren, neuen Betrag eintragen (z. B. `999999999`), Enter.
3. Für dauerhaftes Halten die **Freeze**-Checkbox aktivieren.

Das Spiel zieht laufend Ausgaben ab – ohne Freeze sinkt der Wert wieder.

> **Obergrenze:** `2.147.483.647` (32-Bit). Darüber läuft der Wert über.

### 5. Nach einem Reload

Nach Seiten-Reload oder Browser-Neustart ändert sich die Adresse. Dann einfach
die Schritte 2–4 wiederholen (dauert ca. eine Minute).

---

## English

### 1. Prepare

1. Open the game: <https://www.youtube.com/playables/Ugkxto-OwJZo4rm8Xl2Nj3K403nHlYThf-sr>
2. Note the money in the top right (e.g. `750`).
3. Install [Cheat Engine](https://www.cheatengine.org/) (opt out of the bundled
   offers during setup).

### 2. Find the right process

Firefox has **several** `firefox.exe` processes. The game runs in a **content
process**, not the main process.

1. Task Manager → **Details** tab.
2. Sort by `firefox.exe` and pick the **process with the highest memory usage**
   (the game uses ~800 MB–1 GB; the main process uses much less).
3. In Cheat Engine: **Open Process** → select exactly that `firefox.exe`.

### 3. Scan

1. **Value Type:** `4 Bytes`
2. **First Scan** with the current value, e.g. `750`.
3. Buy or sell something in game so the money changes (e.g. to `650`).
4. Enter the new value → **Next Scan**.
5. Exactly **one** address should remain.

If not:

- Change the value again and run **Next Scan** with the new amount.
- If `4 Bytes` finds nothing at all, switch **Value Type** to `8 Bytes` and
  start over.
- Only write to the final single address – never change hundreds of hits at
  once (that can crash the tab).

### 4. Set / freeze

1. Double-click the address to add it to the list.
2. Select it, enter a new amount (e.g. `999999999`), press Enter.
3. Tick the **Freeze** checkbox to keep it at that value.

The game constantly deducts expenses – without freeze the value drops again.

> **Limit:** `2,147,483,647` (32-bit). Above that the value overflows.

### 5. After a reload

After a page reload or browser restart the address changes. Just repeat steps
2–4 (takes about a minute).
