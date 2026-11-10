# macOS – Bit Slicer

**Deutsch** · [English](#english)

---

## Deutsch

### 1. Vorbereiten

1. Spiel öffnen: <https://www.youtube.com/playables/Ugkxto-OwJZo4rm8Xl2Nj3K403nHlYThf-sr>
2. Geldstand oben rechts notieren (z. B. `383`).
3. [Bit Slicer](https://github.com/zorgiepoo/Bit-Slicer) herunterladen
   (kostenlos, Open Source) und nach `/Applications` verschieben.
4. Beim ersten Start ggf. in **Systemeinstellungen → Datenschutz & Sicherheit**
   die Freigabe erteilen (Bedienungshilfen / „App erlauben").

> Bit Slicer muss in andere Prozesse schreiben dürfen. Bei systemnahen
> Prozessen kann ein Start mit `sudo open -a "Bit Slicer"` nötig sein.

### 2. Den richtigen Prozess finden

Firefox hat mehrere Prozesse; das Spiel läuft in einem **Content Process** mit
großem WASM-Heap.

1. **Aktivitätsanzeige** öffnen → Reiter „Speicher" → nach `firefox` filtern.
2. Den Firefox-Prozess mit dem **größten Speicherverbrauch** heraussuchen
   (das Spiel belegt mehrere hundert MB).
3. In Bit Slicer: **Target** wählen → diesen Firefox-Prozess auswählen.

### 3. Suchen

1. **Search → Value Type:** `4-Byte Integer` (Signed).
2. Wert `383` eingeben → **Search**.
3. Im Spiel kaufen/verkaufen, sodass sich das Geld ändert (z. B. `463`).
4. Neuen Wert eingeben → **Search** (filtert die bisherigen Treffer).
5. Es sollte **ein** Treffer übrig bleiben.

Falls nicht: Wert erneut ändern und wieder filtern. Wenn `4 Byte` nichts
findet, mit **8-Byte Integer** wiederholen.

> Wichtig: erst filtern, bis nur eine Adresse übrig ist – nicht hunderte
> Treffer gleichzeitig beschreiben.

### 4. Wert setzen / sperren

1. Treffer markieren → **Edit** / Wert ändern (z. B. `999999999`).
2. Für dauerhaftes Halten **Lock** aktivieren.

Das Spiel zieht laufend Ausgaben ab – ohne Lock sinkt der Wert wieder.

> **Obergrenze:** `2.147.483.647` (32-Bit).

### 5. Nach einem Reload

Nach Seiten-Reload oder Browser-Neustart ändert sich die Adresse. Schritte 2–4
einfach wiederholen.

---

## English

### 1. Prepare

1. Open the game: <https://www.youtube.com/playables/Ugkxto-OwJZo4rm8Xl2Nj3K403nHlYThf-sr>
2. Note the money in the top right (e.g. `383`).
3. Download [Bit Slicer](https://github.com/zorgiepoo/Bit-Slicer) (free, open
   source) and move it to `/Applications`.
4. On first launch, grant permission in **System Settings → Privacy & Security**
   (Accessibility / "allow app") if prompted.

> Bit Slicer needs to write into other processes. For hardened processes you may
> need to start it with `sudo open -a "Bit Slicer"`.

### 2. Find the right process

Firefox has several processes; the game runs in a **content process** with a
large WASM heap.

1. Open **Activity Monitor** → "Memory" tab → filter for `firefox`.
2. Pick the Firefox process with the **highest memory usage** (the game uses
   several hundred MB).
3. In Bit Slicer: choose **Target** → that Firefox process.

### 3. Search

1. **Search → Value Type:** `4-Byte Integer` (signed).
2. Enter `383` → **Search**.
3. Buy/sell in game so the money changes (e.g. `463`).
4. Enter the new value → **Search** (filters the previous hits).
5. **One** hit should remain.

If not: change the value again and filter again. If `4 Byte` finds nothing,
retry with **8-Byte Integer**.

> Important: filter down to a single address first – never write to hundreds of
> hits at once.

### 4. Set / lock

1. Select the hit → **Edit** / change the value (e.g. `999999999`).
2. Enable **Lock** to keep it.

The game constantly deducts expenses – without lock the value drops again.

> **Limit:** `2,147,483,647` (32-bit).

### 5. After a reload

After a page reload or browser restart the address changes. Just repeat steps
2–4.
