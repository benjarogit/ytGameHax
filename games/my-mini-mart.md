# My Mini Mart

**Geld auf Maximum** · ⏱ ca. 2 Minuten

[← Alle Spiele](../README.md) · **Deutsch** · [English](#english)

[![My Mini Mart mit 999.999.995 auf dem Konto](../docs/img/my-mini-mart.png)](../docs/img/my-mini-mart.png)

*Screenshot: das Ergebnis im Spiel – klicken zum Vergrößern*

**Spiel:** <https://www.youtube.com/playables/Ugkxto-OwJZo4rm8Xl2Nj3K403nHlYThf-sr>

---

## Deutsch

### In 2 Minuten

1. **Spiel öffnen** – Link oben anklicken und den Geldstand oben im Bild
   ablesen (z. B. `383`).
2. **Skript starten** – Terminal im Repo-Ordner:

   ```bash
   sudo ./linux/money_hunt.sh --set 999999999 --freeze 2
   ```

3. **Der Anleitung im Terminal folgen:**
   - aktuellen Geldstand eingeben (`383`)
   - im Spiel etwas **verkaufen oder kaufen**, bis die Anzeige sich ändert
   - den neuen Geldstand eingeben (z. B. `463`)
4. **Fertig** – das Skript setzt `999999999` und hält den Wert fest.

> 💡 **Warum Freeze?** Das Spiel zieht laufend Ausgaben ab. Ohne Freeze sinkt
> der Wert sofort wieder. Das Skript schreibt ihn deshalb alle 2 Sekunden neu.

Freeze beenden: `Strg+C` im Terminal – oder den `kill`-Befehl, den das Skript
am Ende ausgibt.

### Was du brauchst

- Linux mit **scanmem** (einmalig installieren, siehe
  [Hauptseite](../README.md#3-dein-betriebssystem))
- Den Spiel-Tab offen und fertig geladen
- Windows oder macOS? → [Cheat Engine](../windows/README.md) bzw.
  [Bit Slicer](../macos/README.md)

### Wenn's nicht klappt

| Problem | Lösung |
| :--- | :--- |
| „Wert nicht gefunden“ | Der Betrag muss **genau** der Anzeige entsprechen. Nochmal ablesen und neu starten. |
| „Es sind noch mehrere Kandidaten“ | Das Geld hat sich zwischen den Scans mehrfach geändert. Skript erneut starten und zügig den neuen Wert eingeben. |
| Der Wert springt zurück | Freeze aktiv lassen (`--freeze 2`) oder das Skript mit `--freeze 1` starten. |
| Anzeige bleibt alt | Eine echte Transaktion auslösen (kaufen oder verkaufen). |
| Nach einem Reload ist alles weg | Die Adresse ändert sich. Schritte 1–4 wiederholen. |

<details>
<summary><b>So funktioniert's (Technik)</b></summary>

Der Geldstand liegt als 32-Bit-Ganzzahl (int32) im WASM-Heap und wird **jedes
Frame** direkt aus dem Speicher gezeichnet.

Fundweg beim Test:

1. Scan nach `383` → 3629 Kandidaten.
2. Im Spiel verkauft, Anzeige springt auf `463`.
3. Scan nach `463` → **genau 1 Adresse**.
4. Testschreibung `777777`: nach der nächsten Verkaufstransaktion stand dort
   `777900` – das Spiel hatte selbst `+123` addiert. Adresse bestätigt.

Gefundene Adresse beim Test: `0x7f19e896c2bc` (Heap-Basis `0x7f19e3def000`,
Offset `0x4b7d2bc`, Heap ca. 115 MB). Nach einem Reload sind die Werte andere –
deshalb sucht das Skript jedes Mal neu.

</details>

<details>
<summary><b>Selbst scannen mit scanmem</b></summary>

```
option region_scan_level 3
reset
lregions                  # ID der wasm-reserved-Zeile merken (z. B. 42)
option scan_data_type number
dregion !42
383                       # aktueller Geldstand
```

Im Spiel verkaufen, dann:

```
463                       # neuer Geldstand
list                      # sollte 1 Treffer sein
set 0=999999999/2         # setzen + Freeze alle 2 Sekunden
```

</details>

### Windows / macOS

Gleiches Vorgehen mit Cheat Engine bzw. Bit Slicer: **4 Bytes**, Geldstand
scannen, im Spiel kaufen/verkaufen, mit dem neuen Betrag neu filtern. Am Ende
den Wert setzen und **Freeze/Lock** aktivieren – sonst zieht das Spiel die
Ausgaben weiter ab.

---

## English

### In 2 minutes

1. **Open the game** – click the link above and read the money display
   (e.g. `383`).
2. **Run the script** – in a terminal inside the repo folder:

   ```bash
   sudo ./linux/money_hunt.sh --set 999999999 --freeze 2
   ```

3. **Follow the prompts:**
   - enter the current money (`383`)
   - **sell or buy** something in game until the display changes
   - enter the new money (e.g. `463`)
4. **Done** – the script writes `999999999` and keeps it frozen.

> 💡 **Why freeze?** The game constantly deducts expenses. Without a freeze the
> value drops again immediately, so the script rewrites it every 2 seconds.

Stop the freeze: `Ctrl+C` in the terminal – or the `kill` command printed at the
end.

### What you need

- Linux with **scanmem** (install once, see
  [main page](../README.en.md#3-your-operating-system))
- The game tab open and fully loaded
- On Windows or macOS? → [Cheat Engine](../windows/README.md) or
  [Bit Slicer](../macos/README.md)

### If it doesn't work

| Problem | Fix |
| :--- | :--- |
| "value not found" | The amount must **exactly** match the display. Read it again and restart. |
| "several candidates left" | The money changed several times between the scans. Restart and enter the new value quickly. |
| The value drops back | Keep the freeze on (`--freeze 2`) or use `--freeze 1`. |
| Display stays old | Trigger a real transaction (buy or sell). |
| Everything is gone after a reload | The address changes. Repeat steps 1–4. |

<details>
<summary><b>How it works (technical)</b></summary>

The money is a 32-bit integer (int32) in the WASM heap and is drawn **every
frame** straight from memory.

How it was found in the test:

1. Scan for `383` → 3629 candidates.
2. Sold something, the display jumped to `463`.
3. Scan for `463` → **exactly 1 address**.
4. Test write of `777777`: after the next sale it read `777900` – the game had
   added `+123` itself. Address confirmed.

Address in the test: `0x7f19e896c2bc` (heap base `0x7f19e3def000`, offset
`0x4b7d2bc`, heap ~115 MB). After a reload these values differ – that's why the
script searches again every time.

</details>

<details>
<summary><b>Manual scanmem flow</b></summary>

```
option region_scan_level 3
reset
lregions                  # note the wasm-reserved region ID (e.g. 42)
option scan_data_type number
dregion !42
383                       # current money
```

Sell something in game, then:

```
463                       # new money
list                      # should be 1 hit
set 0=999999999/2         # set + freeze every 2 seconds
```

</details>

### Windows / macOS

Same approach with Cheat Engine or Bit Slicer: **4 bytes**, scan the money, buy
or sell in game, filter with the new amount. Finally set the value and enable
**Freeze/Lock** – otherwise the game keeps deducting expenses.
