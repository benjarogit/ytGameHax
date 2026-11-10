# Claw Master – Münzen, gelbe & rote Sterne

[← Alle Spiele](../README.md) · **Deutsch** · [English](#english)

[![Claw Master mit 7777 roten Sternen, 8889 gelben Sternen und über 1 Mio. Münzen](../docs/img/claw-master.png)](../docs/img/claw-master.png)

*Klicken zum Vergrößern / click to enlarge*

**Spiel:** <https://www.youtube.com/playables/UgkxpLqVBYvac8lZ3ZJRIZG2KoKsj56nyq09>
(Big Game Freaks)

---

## Deutsch

### Gefundene Werte

| | |
| --- | --- |
| Prozess | Firefox Content Process (`-contentproc -isForBrowser …`) |
| Heap | `[anon:wasm-reserved]`, ~165–200 MB belegt |
| Region-ID in scanmem | `42` |
| Heap-Basis | `0x7f19e4cef000` |
| Münzen | `0x7f19e7acfbc0` (+0x00 im Record) |
| Gelbe Sterne | `0x7f19e7acfbd8` (+0x18) |
| Rote Sterne | `0x7f19e7acfbf0` (+0x30) |
| Weitere Kopie | `0x7f19e7acfda0` (+0x60·3 im Heap) |

Alle drei Werte liegen in **einem** 0x60-Byte-Record:

```
record + 0x00   Münzen
record + 0x18   gelbe Sterne
record + 0x30   rote Sterne
```

Das Spiel hält den Record in **mehreren identischen Kopien**. Beim Schreiben
müssen deshalb **alle Kopien** gleichzeitig gesetzt werden, sonst überschreibt
eine alte Kopie die geänderten Werte.

### Fundweg

1. Ausgangswerte im HUD: **0 rot / 1 gelb / 20 Münzen**.
2. Snapshot des WASM-Heaps, dann im Spiel gespielt → **0 / 2 / 60**.
3. Nochmal gespielt → **0 / 3 / 80**.
4. Filter über die Münzen: `60 → 80` ließ 8 Adressen übrig. Vier davon hatten
   direkt daneben (`+0x18`) den gelben Stern-Wert `3` – das ist der Record.
5. Testschreibung `8888` auf die Münz-Adressen: nach dem nächsten Gegner-Kill
   zeigte das HUD **8918** (8888 + 30 verdient). Damit war klar, dass die
   Adressen stimmen und nur die Anzeige auf ein Event wartet.
6. Endgültig gesetzt: Münzen `999999`, gelb `8888`, rot `7777` → HUD zeigte
   `7777 / 8889 / 1000009` (jeweils plus die im Spiel verdienten Beträge).

Den roten Stern erkennt man erst, wenn er ungleich 0 ist: er sitzt bei
`record + 0x30` und ging bei der Testrunde von `0` auf `1`.

### Besonderheiten

- **Die Anzeige aktualisiert nur bei einem Spielevent** (Gegner töten,
  Level-Ende). Nach dem Schreiben einfach kurz weiterspielen.
- **Anzeige bricht bei 5 Stellen um:** Münzen ab `100000` werden als zwei
  Blöcke dargestellt (`10000` + `09`). Der Wert im Speicher ist trotzdem
  korrekt; für eine saubere Anzeige z. B. `99999` setzen.
- **int32-Grenze:** maximal `2.147.483.647`.
- Nach einem Reload ändern sich die Adressen – Prozedur wiederholen.

### Linux (scanmem)

```bash
# automatisch: sucht den Record selbst und setzt alle Kopien
sudo python3 linux/claw_master_set.py --show
sudo python3 linux/claw_master_set.py --new-coins 99999 --new-yellow 8888 --new-red 7777
```

Das Skript braucht **keine** HUD-Werte: es erkennt die Records an einem
konstanten Pointer-Paar im Record und nimmt den Satz mit den meisten Münzen
(= aktiver Spielstand).

Manuell mit scanmem (z. B. für Windows/macOS-Nutzer ohne Python):

```
option region_scan_level 3
reset
lregions                 # ID der wasm-reserved-Region merken (hier 42)
option scan_data_type number
dregion !42
80                       # aktueller Münzstand
```

Münzen im Spiel ändern, dann mit dem neuen Wert erneut scannen, bis wenige
Treffer übrig sind. Die Treffer, bei denen `+0x18` der gelbe Stern-Wert ist,
gehören zum Record – alle gleichzeitig setzen:

```
set 0,1=99999            # Münzen (alle Kopien)
```

### Windows / macOS

Gleiches Vorgehen mit Cheat Engine bzw. Bit Slicer: **4 Bytes**, Münzstand
scannen, im Spiel ändern, neu filtern. Für die Sterne analog mit deren Werten
scannen. Die drei Werte liegen dicht beieinander (Abstand `0x18`), deshalb in
der Adressliste die Nachbar-Adressen prüfen.

---

## English

### Values found

| | |
| --- | --- |
| Process | Firefox content process (`-contentproc -isForBrowser …`) |
| Heap | `[anon:wasm-reserved]`, ~165–200 MB used |
| Region ID in scanmem | `42` |
| Heap base | `0x7f19e4cef000` |
| Coins | `0x7f19e7acfbc0` (+0x00 in the record) |
| Yellow stars | `0x7f19e7acfbd8` (+0x18) |
| Red stars | `0x7f19e7acfbf0` (+0x30) |
| Another copy | `0x7f19e7acfda0` (+0x60·3 in the heap) |

All three values live in **one** 0x60-byte record:

```
record + 0x00   coins
record + 0x18   yellow stars
record + 0x30   red stars
```

The game keeps several identical copies of that record, so **all copies** must
be written at once – otherwise a stale copy overwrites the new values.

### How it was found

1. HUD at the start: **0 red / 1 yellow / 20 coins**.
2. Took a snapshot of the WASM heap, played a round → **0 / 2 / 60**.
3. Played again → **0 / 3 / 80**.
4. Filtering on the coins (`60 → 80`) left 8 addresses. Four of them had the
   yellow star value `3` right next to them (`+0x18`) – that is the record.
5. Test write of `8888` into the coin addresses: after the next enemy kill the
   HUD showed **8918** (8888 + 30 earned). The addresses were right, the HUD
   just waits for an event.
6. Final values: coins `999999`, yellow `8888`, red `7777` → HUD showed
   `7777 / 8889 / 1000009` (plus whatever was earned in game).

The red star is only visible once it is not 0: it sits at `record + 0x30` and
went from `0` to `1` during the test round.

### Notes

- **The HUD only refreshes on an in-game event** (killing an enemy, level end).
  Just keep playing for a moment after writing.
- **The display wraps at 5 digits:** coins from `100000` on are drawn as two
  blocks (`10000` + `09`). The stored value is still correct; use e.g. `99999`
  for a clean display.
- **int32 limit:** `2,147,483,647`.
- After a reload the addresses change – repeat the procedure.

### Linux (scanmem)

```bash
# automatic: finds the record and writes every copy
sudo python3 linux/claw_master_set.py --show
sudo python3 linux/claw_master_set.py --new-coins 99999 --new-yellow 8888 --new-red 7777
```

The script needs **no** HUD values: it finds the records by a constant pointer
pair inside them and picks the set with the most coins (= active save).

Manual scanmem flow:

```
option region_scan_level 3
reset
lregions                 # note the wasm-reserved region ID (42 here)
option scan_data_type number
dregion !42
80                       # current coins
```

Change the coins in game, scan the new value, repeat until few hits remain. The
hits where `+0x18` equals the yellow star count belong to the record – write all
of them:

```
set 0,1=99999            # coins (all copies)
```

### Windows / macOS

Same approach with Cheat Engine or Bit Slicer: **4 bytes**, scan the coin count,
change it in game, filter again. Do the same for the star counts. The three
values sit close together (`0x18` apart), so check the neighbouring addresses in
the address list.
