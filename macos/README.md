# macOS – Bit Slicer

**Geld, Münzen und Sterne mit ein paar Klicks ändern** · ⏱ ca. 5 Minuten

[← Alle Spiele](../README.md) · **Deutsch** · [English](#english)

Gilt für **alle Spiele** in diesem Repo. Beispielwerte: Pizza Inc. (`750`), die
richtigen Zahlen stehen auf der jeweiligen Spielseite.

---

## Deutsch

### Was du brauchst

- macOS 11 oder neuer
- Firefox mit dem geöffneten Spiel
- [Bit Slicer](https://github.com/zorgiepoo/Bit-Slicer/releases) (kostenlos,
  Open Source)

### Schritt 1 – Bit Slicer installieren

1. Auf <https://github.com/zorgiepoo/Bit-Slicer/releases> die neueste
   `.zip`-Datei herunterladen.
2. Entpacken und **Bit Slicer.app** nach `/Programme` verschieben.
3. Beim ersten Start: Rechtsklick → **Öffnen** (die App ist nicht signiert).
   Falls macOS blockt: **Systemeinstellungen → Datenschutz & Sicherheit** →
   „Dennoch öffnen".
4. Erlauben, dass Bit Slicer andere Apps steuern darf
   (Bedienungshilfen / „App erlauben").

### Schritt 2 – Spiel öffnen und Wert ablesen

1. Spiel auf YouTube öffnen (Link auf der Spielseite).
2. Warten, bis der Spielstand sichtbar ist.
3. Die Zahl notieren, die du ändern willst – z. B. `750` Geld oder `80` Münzen.

### Schritt 3 – Den richtigen Firefox-Prozess finden

Firefox läuft **mehrfach**. Das Spiel steckt in einem eigenen Prozess.

1. **Aktivitätsanzeige** öffnen (`Cmd+Leertaste` → „Aktivitätsanzeige").
2. Reiter **Speicher** → oben rechts nach `firefox` filtern.
3. Der Eintrag mit **mehreren hundert MB** ist der Spiel-Prozess.
4. In Bit Slicer oben links: **Target** anklicken → diesen Prozess auswählen.

> 💡 **Unsicher?** Andere Tabs schließen. Der Spiel-Prozess ist dann der
> einzige mit großem Speicherverbrauch.

### Schritt 4 – Suchen

1. **Value Type:** `4-Byte Integer` (signed).
2. Aktuellen Wert eintragen (`750`) → **Search**. Tausende Treffer – normal.
3. Im Spiel **kaufen oder verkaufen**, sodass sich die Zahl ändert (z. B.
   `650`).
4. Neuen Wert eintragen → **Search** (filtert die bisherigen Treffer).
5. Noch einmal im Spiel ändern und erneut **Search**. Meist bleibt **ein**
   Treffer übrig.

### Schritt 5 – Wert setzen und sperren

1. Treffer markieren → **Edit** → neuen Wert eintragen (`999999999`).
2. Für Geld-Spiele **Lock** aktivieren – das Spiel zieht sonst laufend
   Ausgaben ab.
3. Im Spiel eine Transaktion auslösen (kaufen/verkaufen), damit die Anzeige
   aktualisiert.

> ⚠️ **Niemals hunderte Treffer gleichzeitig beschreiben.** Erst filtern, bis
> nur wenige Adressen übrig sind.

### Wenn's nicht klappt

| Problem | Lösung |
| :--- | :--- |
| Bit Slicer startet nicht / wird blockiert | Rechtsklick → **Öffnen**, oder in **Datenschutz & Sicherheit** freigeben. |
| Kein Treffer beim ersten Scan | Wert nochmal genau ablesen (ganze Zahl, keine Punkte/Kommas). |
| Nach dem zweiten Scan noch hunderte Treffer | Wert hat sich mehrfach geändert. Noch eine Runde: ändern → **Search**. |
| „4 Byte" findet nichts | **8-Byte Integer** wählen und von vorn beginnen. |
| Wert springt zurück | **Lock** aktivieren oder mehrfach neu setzen. |
| Anzeige bleibt alt | Echte Transaktion im Spiel auslösen. |
| Alles nach Reload weg | Adresse ändert sich. Schritte 3–5 wiederholen (~1 Minute). |
| Kein Schreibzugriff auf den Prozess | Bit Slicer mit `sudo open -a "Bit Slicer"` starten (nur wenn nötig). |

<details>
<summary><b>Spiele mit mehreren Kopien (Pizza Inc., Claw Master)</b></summary>

Manche Spiele speichern denselben Wert an mehreren Stellen. Dann bleiben beim
Filtern **mehrere gleiche Adressen** übrig – z. B. vier bei Pizza Inc.

- **Pizza Inc.:** alle vier Treffer markieren, denselben Wert eintragen und
  **Lock** für alle aktivieren.
- **Claw Master:** Münzen suchen. Gelbe Sterne liegen `+0x18` (24 Bytes)
  dahinter, rote Sterne `+0x30` (48 Bytes). In Bit Slicer die Adresse
  duplizieren und den Wert der Adresse um `18` bzw. `30` erhöhen.

</details>

<details>
<summary><b>Warum funktioniert das?</b></summary>

Das Spiel ist WebAssembly (Unity) und hält seinen Spielstand im
Browser-Speicher. Ein einzelner Scan findet tausende Zahlen – Preise, Zähler,
Grafikwerte. Erst die **Änderung** ist der Filter: Nur die echte Geld-Zahl
ändert sich genau so wie die Anzeige.

</details>

---

## English

### What you need

- macOS 11 or newer
- Firefox with the game open
- [Bit Slicer](https://github.com/zorgiepoo/Bit-Slicer/releases) (free, open
  source)

### Step 1 – Install Bit Slicer

1. Open <https://github.com/zorgiepoo/Bit-Slicer/releases> and download the
   latest `.zip`.
2. Unzip it and move **Bit Slicer.app** to `/Applications`.
3. On first launch: right-click → **Open** (the app is not signed). If macOS
   blocks it: **System Settings → Privacy & Security** → "Open Anyway".
4. Allow Bit Slicer to control other apps (Accessibility / "allow app").

### Step 2 – Open the game and read the value

1. Open the game on YouTube (link on the game page).
2. Wait until the HUD is visible.
3. Note the number you want to change – e.g. `750` money or `80` coins.

### Step 3 – Find the right Firefox process

Firefox runs **multiple** processes. The game lives in its own one.

1. Open **Activity Monitor** (`Cmd+Space` → "Activity Monitor").
2. **Memory** tab → filter for `firefox` in the top right.
3. The entry with **several hundred MB** is the game process.
4. In Bit Slicer click **Target** at the top left → select that process.

> 💡 **Not sure?** Close other tabs. The game process is then the only one with
> a big memory footprint.

### Step 4 – Search

1. **Value Type:** `4-Byte Integer` (signed).
2. Enter the current value (`750`) → **Search**. Thousands of hits – expected.
3. **Buy or sell** something in game so the number changes (e.g. `650`).
4. Enter the new value → **Search** (filters the previous hits).
5. Change it once more in game and **Search** again. Usually **one** hit
   remains.

### Step 5 – Set and lock

1. Select the hit → **Edit** → enter the new value (`999999999`).
2. For money games enable **Lock** – otherwise the game keeps deducting
   expenses.
3. Trigger a transaction in game (buy/sell) so the display updates.

> ⚠️ **Never write to hundreds of hits at once.** Filter down to a few addresses
> first.

### If it doesn't work

| Problem | Fix |
| :--- | :--- |
| Bit Slicer won't start / is blocked | Right-click → **Open**, or allow it in **Privacy & Security**. |
| No hit on the first scan | Read the value again carefully (whole number, no dots or commas). |
| Still hundreds of hits after the second scan | The value changed several times. Do another round: change → **Search**. |
| "4 Byte" finds nothing | Choose **8-Byte Integer** and start over. |
| The value drops back | Enable **Lock** or set it repeatedly. |
| Display stays old | Trigger a real transaction in game. |
| Everything gone after a reload | The address changes. Repeat steps 3–5 (~1 minute). |
| No write access to the process | Start Bit Slicer with `sudo open -a "Bit Slicer"` (only if needed). |

<details>
<summary><b>Games with several copies (Pizza Inc., Claw Master)</b></summary>

Some games store the same value in several places, so filtering leaves
**several identical addresses** – four in Pizza Inc., for example.

- **Pizza Inc.:** select all four hits, enter the same value and enable **Lock**
  for each.
- **Claw Master:** search the coins. Yellow stars sit `+0x18` (24 bytes) behind
  them, red stars `+0x30` (48 bytes). In Bit Slicer duplicate the address and
  increase it by `18` or `30`.

</details>

<details>
<summary><b>Why does this work?</b></summary>

The game is WebAssembly (Unity) and keeps its state in browser memory. A single
scan finds thousands of numbers – prices, counters, graphics data. The
**change** is the filter: only the real money value changes exactly like the
display does.

</details>
