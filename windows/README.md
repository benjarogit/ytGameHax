# Windows – Cheat Engine

**Geld, Münzen und Sterne mit ein paar Klicks ändern** · ⏱ ca. 5 Minuten

[← Alle Spiele](../README.md) · **Deutsch** · [English](#english)

Gilt für **alle Spiele** in diesem Repo. Beispielwerte: Pizza Inc. (`750`), die
richtigen Zahlen stehen auf der jeweiligen Spielseite.

---

## Deutsch

### Was du brauchst

- Windows 10 oder 11
- Firefox mit dem geöffneten Spiel
- [Cheat Engine](https://www.cheatengine.org/) (kostenlos)

### Schritt 1 – Cheat Engine installieren

1. Auf <https://www.cheatengine.org/> auf **Download Cheat Engine** klicken.
2. Installer starten. Bei der Installation **alle zusätzlichen Angebote
   abwählen** („I agree", „Decline", „Skip") – Cheat Engine selbst ist
   kostenlos, die Zusatzprogramme braucht niemand.
3. Cheat Engine starten. Windows fragt evtl. nach Administratorrechten →
   **Ja**.

### Schritt 2 – Spiel öffnen und Wert ablesen

1. Spiel auf YouTube öffnen (Link auf der Spielseite).
2. Warten, bis der Spielstand sichtbar ist.
3. Die Zahl notieren, die du ändern willst – z. B. `750` Geld oder `80` Münzen.

### Schritt 3 – Den richtigen Firefox-Prozess finden

Firefox läuft **mehrfach**. Das Spiel steckt in einem eigenen Prozess, nicht im
Hauptfenster.

1. **Task-Manager** öffnen: `Strg+Shift+Esc`.
2. Reiter **Details** → auf **Arbeitsspeicher** sortieren.
3. Der oberste `firefox.exe`-Eintrag mit **mehreren hundert MB bis 1 GB** ist
   der Spiel-Prozess (der Hauptprozess braucht deutlich weniger).
4. In Cheat Engine oben links auf das **Computer-Symbol** („Open Process")
   klicken → genau diesen `firefox.exe` auswählen → **Open**.

> 💡 **Unsicher?** Andere Tabs schließen. Der Spiel-Prozess ist dann der
> einzige mit großem Speicherverbrauch.

### Schritt 4 – Suchen

1. **Value Type:** `4 Bytes`.
2. **Scan Type:** `Exact Value`.
3. Bei **First Scan** den aktuellen Wert eintragen (`750`) → **First Scan**.
   Es bleiben tausende Treffer – das ist normal.
4. Im Spiel etwas **kaufen oder verkaufen**, sodass sich die Zahl ändert
   (z. B. auf `650`).
5. Neuen Wert eintragen → **Next Scan**. Jetzt bleiben nur wenige Treffer.
6. Zur Sicherheit noch einmal im Spiel ändern und erneut **Next Scan**.
   Meist bleibt **genau eine** Adresse übrig.

### Schritt 5 – Wert setzen und einfrieren

1. Adresse per **Doppelklick** in die Liste unten übernehmen.
2. In der Spalte **Value** doppelklicken, neuen Wert eintragen
   (z. B. `999999999`), **Enter**.
3. Für Geld-Spiele die **Freeze**-Checkbox aktivieren – das Spiel zieht sonst
   laufend Ausgaben ab.
4. Im Spiel eine Transaktion auslösen (kaufen/verkaufen). Bei manchen Spielen
   aktualisiert sich die Anzeige erst dann.

> ⚠️ **Niemals hunderte Treffer gleichzeitig beschreiben.** Erst filtern, bis
> nur wenige Adressen übrig sind – ein Massen-Schreibversuch hat schon einen
> Tab zum Absturz gebracht.

### Wenn's nicht klappt

| Problem | Lösung |
| :--- | :--- |
| Kein Treffer beim ersten Scan | Wert nochmal genau ablesen (ganze Zahl, keine Punkte/Kommas). |
| Nach dem zweiten Scan noch hunderte Treffer | Wert hat sich mehrfach geändert. Noch eine Runde: ändern → **Next Scan**. |
| „4 Bytes" findet nichts | **Value Type** auf `8 Bytes` stellen und von vorn beginnen. |
| Wert springt zurück | **Freeze** aktivieren oder mehrfach neu setzen. |
| Anzeige bleibt alt | Echte Transaktion im Spiel auslösen. |
| Alles nach Reload weg | Adresse ändert sich. Schritte 3–5 wiederholen (~1 Minute). |
| Cheat Engine findet den Prozess nicht | Cheat Engine als Administrator starten (Rechtsklick → „Als Administrator ausführen"). |

<details>
<summary><b>Spiele mit mehreren Kopien (Pizza Inc., Claw Master)</b></summary>

Manche Spiele speichern denselben Wert an mehreren Stellen. Dann bleiben beim
Filtern **mehrere gleiche Adressen** übrig – z. B. vier bei Pizza Inc.

- **Pizza Inc.:** alle vier Adressen in die Liste übernehmen, denselben Wert
  eintragen und **Freeze** für alle vier aktivieren.
- **Claw Master:** Münzen scannen. Gelbe Sterne liegen `+0x18` (24 Bytes)
  dahinter, rote Sterne `+0x30` (48 Bytes). In Cheat Engine: Adresse markieren →
  `Strg+C` / `Strg+V`, dann die Adresse manuell um `18` bzw. `30` erhöhen
  (Rechtsklick → **Change record → Address**), oder die Nachbar-Adressen direkt
  in der Trefferliste suchen.

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

- Windows 10 or 11
- Firefox with the game open
- [Cheat Engine](https://www.cheatengine.org/) (free)

### Step 1 – Install Cheat Engine

1. Open <https://www.cheatengine.org/> and click **Download Cheat Engine**.
2. Run the installer and **decline every bundled offer** ("I agree",
   "Decline", "Skip"). Cheat Engine itself is free; the extras are not needed.
3. Launch Cheat Engine. Windows may ask for administrator rights → **Yes**.

### Step 2 – Open the game and read the value

1. Open the game on YouTube (link on the game page).
2. Wait until the HUD is visible.
3. Note the number you want to change – e.g. `750` money or `80` coins.

### Step 3 – Find the right Firefox process

Firefox runs **multiple** processes. The game lives in its own one, not in the
main window.

1. Open **Task Manager**: `Ctrl+Shift+Esc`.
2. Go to the **Details** tab and sort by **Memory**.
3. The top `firefox.exe` with **several hundred MB up to 1 GB** is the game
   process (the main process uses far less).
4. In Cheat Engine click the **computer icon** ("Open Process") → select that
   exact `firefox.exe` → **Open**.

> 💡 **Not sure?** Close other tabs. The game process is then the only one with
> a big memory footprint.

### Step 4 – Scan

1. **Value Type:** `4 Bytes`.
2. **Scan Type:** `Exact Value`.
3. Enter the current value (`750`) and click **First Scan**. Thousands of hits
   remain – that's expected.
4. **Buy or sell** something in game so the number changes (e.g. to `650`).
5. Enter the new value → **Next Scan**. Only a few hits remain.
6. Change it once more in game and run **Next Scan** again. Usually **exactly
   one** address is left.

### Step 5 – Set and freeze

1. **Double-click** the address to add it to the list.
2. Double-click its **Value**, enter the new amount (e.g. `999999999`), press
   **Enter**.
3. For money games tick the **Freeze** checkbox – otherwise the game keeps
   deducting expenses.
4. Trigger a transaction in game (buy/sell). Some games only update the display
   then.

> ⚠️ **Never write to hundreds of hits at once.** Filter down to a few addresses
> first – a mass write has crashed a tab before.

### If it doesn't work

| Problem | Fix |
| :--- | :--- |
| No hit on the first scan | Read the value again carefully (whole number, no dots or commas). |
| Still hundreds of hits after the second scan | The value changed several times. Do another round: change → **Next Scan**. |
| "4 Bytes" finds nothing | Switch **Value Type** to `8 Bytes` and start over. |
| The value drops back | Enable **Freeze** or set it repeatedly. |
| Display stays old | Trigger a real transaction in game. |
| Everything gone after a reload | The address changes. Repeat steps 3–5 (~1 minute). |
| Cheat Engine cannot find the process | Run Cheat Engine as administrator (right-click → "Run as administrator"). |

<details>
<summary><b>Games with several copies (Pizza Inc., Claw Master)</b></summary>

Some games store the same value in several places. Then filtering leaves
**several identical addresses** – four in Pizza Inc., for example.

- **Pizza Inc.:** add all four addresses to the list, enter the same value and
  enable **Freeze** for all four.
- **Claw Master:** scan the coins. Yellow stars sit `+0x18` (24 bytes) behind
  them, red stars `+0x30` (48 bytes). In Cheat Engine: copy the address
  (`Ctrl+C` / `Ctrl+V`) and adjust it manually by `18` or `30` (right-click →
  **Change record → Address**), or look for the neighbouring addresses in the
  result list.

</details>

<details>
<summary><b>Why does this work?</b></summary>

The game is WebAssembly (Unity) and keeps its state in browser memory. A single
scan finds thousands of numbers – prices, counters, graphics data. The
**change** is the filter: only the real money value changes exactly like the
display does.

</details>
