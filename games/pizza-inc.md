# Pizza Inc.

**Geld auf Maximum** · ⏱ ca. 2 Minuten

[← Alle Spiele](../README.md) · **Deutsch** · [English](#english)

[![Pizza Inc. mit 999.999.999 auf dem Konto](../docs/img/pizza-inc.png)](../docs/img/pizza-inc.png)

*Screenshot: das Ergebnis im Spiel – klicken zum Vergrößern*

**Spiel:** <https://www.youtube.com/playables/UgkxOTqK6a2_6ChV0IEN39C8HVRNNaDNa_St>

---

## Deutsch

### In 2 Minuten

1. **Spiel öffnen** – Link oben anklicken und den Geldstand ablesen
   (z. B. `750`).
2. **Skript starten** – Terminal im Repo-Ordner:

   ```bash
   sudo ./linux/money_hunt.sh --set 999999999 --freeze 2 --all
   ```

3. **Der Anleitung im Terminal folgen:**
   - aktuellen Geldstand eingeben (`750`)
   - im Spiel etwas **kaufen**, bis die Anzeige sich ändert (z. B. `650`)
   - den neuen Geldstand eingeben (`650`)
4. **Fertig** – das Skript schreibt `999999999` in **alle vier Kopien** und hält
   sie fest.

> 💡 **Warum `--all`?** Pizza Inc. speichert das Geld an vier Stellen
> gleichzeitig. Nur wenn alle vier denselben Wert haben, übernimmt das Spiel
> ihn. Das Skript schreibt deshalb alle übrigen Treffer gemeinsam.

Danach im Spiel **eine echte Transaktion** auslösen (kaufen/verkaufen) – erst
dann zeichnet das Spiel den neuen Betrag.

### Was du brauchst

- Linux mit **scanmem** (einmalig installieren, siehe
  [Hauptseite](../README.md#3-dein-betriebssystem))
- Den Spiel-Tab offen und fertig geladen
- Windows oder macOS? → [Cheat Engine](../windows/README.md) bzw.
  [Bit Slicer](../macos/README.md)

### Wenn's nicht klappt

| Problem | Lösung |
| :--- | :--- |
| „Wert nicht gefunden“ | Der Betrag muss **genau** der Anzeige entsprechen – auch die Nachkommastellen weglassen, nur die ganze Zahl eingeben. |
| „Es sind noch mehrere Kandidaten“ | Mit `--all` starten, dann werden alle Kopien gemeinsam gesetzt. |
| Anzeige bleibt alt | Das ist normal: erst eine **echte Transaktion** (kaufen/verkaufen) zeigt den neuen Wert. |
| Der Wert springt zurück | Freeze aktiv lassen (`--freeze 2`). |
| Nach einem Reload ist alles weg | Die Adressen ändern sich. Schritte 1–4 wiederholen. |

<details>
<summary><b>So funktioniert's (Technik)</b></summary>

Das Spiel hält den Geldstand in **vier Kopien** im WASM-Heap. Sie werden alle
gleichzeitig aktualisiert – deshalb reicht es nicht, nur eine Adresse zu
beschreiben.

Fundweg beim Test:

1. Scan nach `750` → 464 Kandidaten.
2. Im Spiel gekauft, Anzeige springt auf `650`.
3. Scan nach `650` → **4 Kandidaten**.
4. Noch eine Transaktion, Anzeige `550` → **alle 4 Kandidaten** standen
   ebenfalls auf `550`. Damit war klar: vier Kopien.

Adressen beim Test (Heap-Basis `0x7f19e0def000`, ca. 166 MB):

```
0x7f19e24f9e7c
0x7f19e2fc074c
0x7f19e2fc0cbc
0x7f19e3715f10
```

Besonderheit: Die Anzeige wird **nur bei einer echten Transaktion** neu
berechnet. Ein Schreibvorgang ändert den Speicher sofort, sichtbar wird er aber
erst beim nächsten Kauf oder Verkauf.

</details>

<details>
<summary><b>Selbst scannen mit scanmem</b></summary>

```
option region_scan_level 3
reset
lregions                  # ID der wasm-reserved-Zeile merken (z. B. 42)
option scan_data_type number
dregion !42
750                       # aktueller Geldstand
```

Im Spiel kaufen, dann:

```
650                       # neuer Geldstand
list                      # 4 Treffer = 4 Kopien
set 0,1,2,3=999999999/2   # alle vier gleichzeitig setzen + Freeze
```

</details>

### Windows / macOS

Gleiches Vorgehen mit Cheat Engine bzw. Bit Slicer: **4 Bytes**, Geldstand
scannen, im Spiel kaufen, mit dem neuen Betrag neu filtern. Es bleiben **vier**
Adressen – alle vier in die Liste übernehmen, denselben Wert eintragen und
**Freeze/Lock** für alle aktivieren. Erst eine Transaktion im Spiel zeigt den
neuen Betrag.

---

## English

### In 2 minutes

1. **Open the game** – click the link above and read the money (e.g. `750`).
2. **Run the script** – in a terminal inside the repo folder:

   ```bash
   sudo ./linux/money_hunt.sh --set 999999999 --freeze 2 --all
   ```

3. **Follow the prompts:**
   - enter the current money (`750`)
   - **buy** something in game until the display changes (e.g. `650`)
   - enter the new money (`650`)
4. **Done** – the script writes `999999999` into **all four copies** and keeps
   them frozen.

> 💡 **Why `--all`?** Pizza Inc. stores the money in four places at once. The
> game only accepts the value when all four match, so the script writes every
> remaining hit together.

Afterwards trigger a **real transaction** in game (buy/sell) – only then does
the game draw the new amount.

### What you need

- Linux with **scanmem** (install once, see
  [main page](../README.en.md#3-your-operating-system))
- The game tab open and fully loaded
- On Windows or macOS? → [Cheat Engine](../windows/README.md) or
  [Bit Slicer](../macos/README.md)

### If it doesn't work

| Problem | Fix |
| :--- | :--- |
| "value not found" | The amount must **exactly** match the display – enter the whole number only. |
| "several candidates left" | Start with `--all`; then all copies are written together. |
| Display stays old | That's normal: only a **real transaction** (buy/sell) shows the new value. |
| The value drops back | Keep the freeze on (`--freeze 2`). |
| Everything is gone after a reload | The addresses change. Repeat steps 1–4. |

<details>
<summary><b>How it works (technical)</b></summary>

The game keeps the money in **four copies** in the WASM heap, all updated at
the same time – so writing a single address is not enough.

How it was found in the test:

1. Scan for `750` → 464 candidates.
2. Bought something, the display jumped to `650`.
3. Scan for `650` → **4 candidates**.
4. Another transaction, display `550` → **all 4 candidates** were `550` too.
   That confirmed the four copies.

Addresses in the test (heap base `0x7f19e0def000`, ~166 MB):

```
0x7f19e24f9e7c
0x7f19e2fc074c
0x7f19e2fc0cbc
0x7f19e3715f10
```

Special: the HUD is recomputed **only on a real transaction**. A write changes
memory immediately, but it becomes visible on the next buy or sell.

</details>

<details>
<summary><b>Manual scanmem flow</b></summary>

```
option region_scan_level 3
reset
lregions                  # note the wasm-reserved region ID (e.g. 42)
option scan_data_type number
dregion !42
750                       # current money
```

Buy something in game, then:

```
650                       # new money
list                      # 4 hits = 4 copies
set 0,1,2,3=999999999/2   # set all four + freeze
```

</details>

### Windows / macOS

Same approach with Cheat Engine or Bit Slicer: **4 bytes**, scan the money, buy
something, filter with the new amount. **Four** addresses remain – add all four
to the list, enter the same value and enable **Freeze/Lock** for each. The new
amount only shows up after a transaction in game.
