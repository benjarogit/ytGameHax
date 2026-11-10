# YouTube Playables – Memory Hacks

**Deutsch** · [English](README.en.md)

Notizen und Werkzeuge, um in YouTube-Playables-Spielen Werte wie **Geld**
im Arbeitsspeicher zu finden und zu setzen:

- **Linux** → [scanmem](https://github.com/scanmem/scanmem)
- **Windows** → [Cheat Engine](https://www.cheatengine.org/)
- **macOS** → [Bit Slicer](https://github.com/zorgiepoo/Bit-Slicer)

Alle Spiele laufen als WebAssembly (Unity) im Browser. Die Werte liegen im
WASM-Heap eines **Firefox-Content-Processes** – nicht im Hauptprozess und
nicht auf einem Server.

---

## Spiele

| Spiel | Was | Anleitung |
| --- | --- | --- |
| **My Mini Mart** | Geld | [games/my-mini-mart.md](games/my-mini-mart.md) |
| **Pizza Inc.** | Geld | [games/pizza-inc.md](games/pizza-inc.md) |

Jede Spielseite enthält einen Screenshot des Ergebnisses, die gefundenen
Adressen und die Besonderheiten des jeweiligen Spiels.

---

## Warum das funktioniert

### 1. Der Browser ist nicht der Prozess, den du suchst

Firefox lagert jede Webseite in einen eigenen **Content Process** aus. Das Spiel
legt seinen kompletten Zustand in einen großen `[anon:wasm-reserved]`-Block.

Im `ps`-Output erkennbar an:

```
/usr/lib/firefox/firefox -contentproc -isForBrowser … -parentPid 7080 …
```

### 2. Warum scanmem den Heap zuerst nicht sieht

scanmem scannt standardmäßig nur `heap`, `stack`, `exe` und `bss`. Der
WASM-Heap hat einen **Namen** (`[anon:wasm-reserved]`) und fällt dadurch aus dem
Raster. Deshalb zuerst:

```
option region_scan_level 3
reset
lregions
```

In der Regionsliste die Zeile mit `[anon:wasm-reserved]` suchen – die ID davor
(z. B. `43`) braucht man für den nächsten Schritt.

### 3. Nur im WASM-Heap suchen

```
option scan_data_type number
dregion !43
```

- `region_scan_level 3` → auch benannte/anonyme Regionen scannen
- `dregion !43` → alle Regionen **außer** 43 löschen (Set-Notation mit `!`)
- `scan_data_type number` → deckt `i16/i32/i64/f32` gleichzeitig ab

### 4. Der eigentliche Trick: Wertänderung als Filter

Ein einzelner Scan liefert oft tausende Treffer (Preise, Zähler, Texturen …).
Der Filter ist die **Änderung**:

1. Scan nach dem aktuellen Wert (z. B. `750`)
2. Im Spiel kaufen/verkaufen, sodass sich der Wert ändert (z. B. `650`)
3. Scan nach dem neuen Wert → es bleiben nur noch wenige Kandidaten
4. Noch eine Änderung → meist genau eine Adresse

### 5. Erst filtern, dann schreiben

> **Wichtig:** Nie hunderte Kandidaten gleichzeitig beschreiben. Ein
> Massen-Schreibtest hat einen Tab zum Absturz gebracht. Erst bis auf wenige
> Adressen filtern – dann setzen.

```
set 0=999999999      # einmalig setzen
set 0=999999999/2    # alle 2 Sekunden neu setzen (Freeze)
```

---

## Anleitung

### Linux (scanmem)

**Installieren**

```bash
# Arch / CachyOS / Manjaro
sudo pacman -S scanmem

# Debian / Ubuntu / Mint
sudo apt install scanmem
```

**ptrace erlauben** (einmalig, bis zum Neustart):

```bash
sudo sh -c 'echo 0 > /proc/sys/kernel/yama/ptrace_scope'
```

**Schnellweg mit Skript**

```bash
git clone https://github.com/benjarogit/ytGameHax.git
cd ytGameHax
chmod +x linux/*.sh

./linux/find_game_process.sh        # zeigt PID + Heap-Basis
./linux/money_hunt.sh --old 750 --new 650 --set 999999999 --freeze 2
```

Das Skript scannt den alten Wert, wartet, während du im Spiel etwas kaufst oder
verkaufst, du gibst den neuen Wert ein – danach setzt es den Zielwert und hält
ihn fest. Ohne Argumente läuft es interaktiv.

**Manuell**

```bash
scanmem <PID>
```

Dann in der scanmem-Konsole:

```
option region_scan_level 3
reset
lregions                      # ID der wasm-reserved-Region merken
option scan_data_type number
dregion !<ID>
750                           # aktueller Wert
```

Wert im Spiel ändern, dann:

```
650                           # neuer Wert
list                          # Kandidaten anzeigen
set 0=999999999/2             # setzen + freezen
```

Freeze beenden: `kill <scanmem-PID>`.

### Windows (Cheat Engine)

Details: [`windows/README.md`](windows/README.md)

1. Spiel öffnen, Wert notieren (z. B. `750`).
2. Task-Manager → Details → **den `firefox.exe` mit dem größten
   Arbeitsspeicher** nehmen (Content-Process des Tabs).
3. Cheat Engine → „Open Process" → diesen Prozess.
4. Value Type **4 Bytes**, First Scan: `750`.
5. Im Spiel kaufen/verkaufen (z. B. `650`) → **Next Scan**: `650`.
6. Übrig bleibt die Adresse → Doppelklick → Wert ändern, Häkchen für Freeze.

### macOS (Bit Slicer)

Details: [`macos/README.md`](macos/README.md)

1. Spiel öffnen, Wert notieren.
2. Bit Slicer → Target: Firefox-Prozess mit dem großen WASM-Heap.
3. Suche: **4-Byte Integer**, `750` → Search.
4. Im Spiel Wert ändern (z. B. `650`) → Search.
5. Verbleibende Adresse editieren oder „Lock" aktivieren.

---

## Dateien

```
games/my-mini-mart.md        Spielseite inkl. Screenshot und Werten
games/pizza-inc.md           Spielseite inkl. Screenshot und Werten
linux/find_game_process.sh   Prozess + WASM-Heap automatisch finden
linux/money_hunt.sh          Zwei-Scan-Hunt inkl. Setzen/Freeze
windows/README.md            Cheat-Engine-Anleitung (DE/EN)
macos/README.md              Bit-Slicer-Anleitung (DE/EN)
docs/img/                    Screenshots der Spiele
```

---

## Grenzen & Hinweise

- **Adresse ist nicht dauerhaft:** Nach einem Reload bekommt der Tab einen neuen
  Prozess und meist einen neuen Heap-Offset. Prozedur dann wiederholen.
- **int32-Grenze:** Werte über `2.147.483.647` laufen über. `999999999` ist sicher.
- **Freeze schreibt periodisch:** gewollt, weil das Spiel laufend Ausgaben
  abzieht. Beenden mit `kill`.
- **Rein clientseitig:** Es wird nichts an YouTube-Server geschickt.
- **Kein Cheat Engine auf Linux:** Cheat Engine ist Windows-Software; scanmem
  macht denselben Job nativ.

---

## Disclaimer

Reverse-Engineering-Lernprojekt für kostenlose Einzelspieler-Browserspiele.
Es werden keine Server manipuliert und keine anderen Spieler beeinflusst.
Die Nutzung kann gegen die Nutzungsbedingungen von YouTube verstoßen –
Benutzung auf eigene Gefahr, ohne Gewähr.

## Lizenz

[MIT](LICENSE)
