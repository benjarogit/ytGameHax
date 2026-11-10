# ytGameHax

**Geld, Münzen und Sterne in YouTube-Playables-Spielen ändern – ohne Vorkenntnisse.**

[Deutsch](README.md) · [English](README.en.md)

![Plattformen](https://img.shields.io/badge/Plattformen-Linux%20%7C%20Windows%20%7C%20macOS-3b82f6?style=flat-square)
![Spiele](https://img.shields.io/badge/Spiele-3-22c55e?style=flat-square)
![Lizenz](https://img.shields.io/badge/Lizenz-MIT-6b7280?style=flat-square)

> **Das Wichtigste in einem Satz**
> Das Spiel merkt sich dein Geld als Zahl im Arbeitsspeicher. Wir suchen diese
> Zahl, ändern sie im Spiel und schreiben dann eine größere Zahl an dieselbe
> Stelle.

Kein Mod, keine Installation im Spiel, nichts wird an YouTube geschickt.
Pro Spiel dauert es ein bis zwei Minuten.

---

## 1. Spiel auswählen

| Spiel | Das kannst du ändern | Zeit | Anleitung |
| :--- | :--- | :---: | :--- |
| **Claw Master** | Münzen, gelbe & rote Sterne | ~1 Min | **[Anleitung →](games/claw-master.md)** |
| **Pizza Inc.** | Geld | ~2 Min | **[Anleitung →](games/pizza-inc.md)** |
| **My Mini Mart** | Geld | ~2 Min | **[Anleitung →](games/my-mini-mart.md)** |

Jede Spielseite enthält: Screenshot vom Ergebnis (anklickbar), Kurzanleitung,
die gefundenen Werte und eine Fehlerhilfe.

---

## 2. Das Prinzip – bei jedem Spiel gleich

1. **Suchen** – nach dem aktuellen Wert scannen (z. B. `750`).
2. **Ändern** – im Spiel kaufen oder verkaufen (z. B. `650`).
3. **Ersetzen** – nach dem neuen Wert scannen. Übrig bleibt die richtige
   Adresse – dort einen hohen Wert eintragen.

> 💡 **Warum das funktioniert:** Ein einzelner Scan findet tausende Zahlen
> (Preise, Zähler, Grafikwerte). Erst die **Änderung** ist der Filter: Nur die
> echte Geld-Zahl hat sich genauso verändert wie die Anzeige.

---

## 3. Dein Betriebssystem

| System | Werkzeug | Weg |
| :--- | :--- | :--- |
| **Linux** | [scanmem](https://github.com/scanmem/scanmem) + Skripte | 1 Befehl im Terminal |
| **Windows** | [Cheat Engine](https://www.cheatengine.org/) | [Klickanleitung](windows/README.md) |
| **macOS** | [Bit Slicer](https://github.com/zorgiepoo/Bit-Slicer) | [Klickanleitung](macos/README.md) |

### Linux – der kürzeste Weg

**Einmalig vorbereiten** (Terminal):

```bash
# scanmem installieren
sudo pacman -S scanmem        # Arch / CachyOS / Manjaro
sudo apt install scanmem      # Debian / Ubuntu / Mint

# scanmem darf in andere Programme schauen (gilt bis zum Neustart)
sudo sh -c 'echo 0 > /proc/sys/kernel/yama/ptrace_scope'
```

**Repo holen und Skripte freischalten:**

```bash
git clone https://github.com/benjarogit/ytGameHax.git
cd ytGameHax
chmod +x linux/*.sh linux/*.py
```

**Spiel im Browser öffnen, dann:**

```bash
# Claw Master: setzt Münzen + beide Sterne, ohne weitere Angaben
sudo python3 linux/claw_master_set.py --easy

# Geld-Spiele (Pizza Inc., My Mini Mart): fragt nach den Werten
sudo ./linux/money_hunt.sh --set 999999999 --freeze 2          # eine Adresse
sudo ./linux/money_hunt.sh --set 999999999 --freeze 2 --all    # alle Kopien
```

Danach im Spiel **kurz weiterspielen** (z. B. einen Gegner besiegen), damit die
Anzeige die neuen Werte übernimmt.

<details>
<summary><b>Was macht das Skript genau?</b></summary>

`claw_master_set.py` sucht im Arbeitsspeicher des richtigen Browser-Prozesses
nach dem Datensatz, in dem Münzen und Sterne zusammen liegen, und schreibt alle
Kopien dieses Datensatzes neu. Du musst dafür nichts ablesen oder eintippen.

`money_hunt.sh` fragt dich nach dem aktuellen und dem neuen Wert, scannt,
filtert und setzt am Ende den Zielwert. Ohne Argumente läuft es im
Gesprächsmodus; mit Argumenten geht es schneller:

```bash
# My Mini Mart (eine Adresse)
sudo ./linux/money_hunt.sh --set 999999999 --freeze 2

# Pizza Inc. (vier Kopien, deshalb --all)
sudo ./linux/money_hunt.sh --set 999999999 --freeze 2 --all
```

`--all` schreibt alle übrigen Kopien (höchstens 8) gleichzeitig.

</details>

### Windows und macOS

Dort übernimmt ein Programm mit Fenster die Arbeit. Die Klickanleitung ist
identisch für alle Spiele – nur die Zahlen, die du eingibst, kommen von der
jeweiligen Spielseite:

- **[Windows → Cheat Engine](windows/README.md)**
- **[macOS → Bit Slicer](macos/README.md)**

---

## 4. Wenn etwas nicht klappt

| Problem | Lösung |
| :--- | :--- |
| „Kein Prozess gefunden“ | Der Spiel-Tab muss offen und fertig geladen sein. Einmal neu laden und Skript erneut starten. |
| `scanmem: command not found` | scanmem installieren (siehe oben). |
| Der Wert springt zurück | Bei Geld-Spielen den **Freeze** benutzen – das Spiel zieht laufend Kosten ab. |
| Anzeige bleibt alt | Ein Spielevent auslösen (kaufen, verkaufen, Gegner besiegen). Manche Spiele zeichnen nur dann neu. |
| Nach einem Reload ist alles weg | Normal: Die Adresse ändert sich. Anleitung einmal wiederholen (~1 Minute). |
| `ptrace_scope`-Fehler unter Linux | `sudo sh -c 'echo 0 > /proc/sys/kernel/yama/ptrace_scope'` ausführen oder das Skript mit `sudo` starten. |

---

## 5. Grenzen & Hinweise

- **Adressen sind nicht dauerhaft.** Nach einem Reload oder Browser-Neustart
  bekommt der Tab neuen Speicher – dann die Prozedur wiederholen.
- **32-Bit-Grenze:** maximal `2.147.483.647`. Darüber läuft der Wert über.
  `999999999` ist ein sicherer Wert, bei Claw Master sind `99999` Münzen
  sinnvoll (die Anzeige hat nur 5 Stellen).
- **Nie hunderte Treffer gleichzeitig beschreiben.** Erst filtern, bis wenige
  Adressen übrig sind – ein Massen-Schreibversuch hat schon einen Tab zum
  Absturz gebracht.
- **Rein clientseitig:** Es wird nichts an YouTube geschickt, andere Spieler
  sind nicht betroffen.
- **Cheat Engine gibt es nur für Windows.** Unter Linux macht scanmem denselben
  Job nativ.

---

<details>
<summary><b>Technik für Neugierige: warum der WASM-Heap besonders ist</b></summary>

Die Spiele laufen als WebAssembly (Unity) im Browser. Den kompletten Spielstand
hält Firefox in einem großen Speicherblock namens `[anon:wasm-reserved]` – und
zwar in einem eigenen **Content-Process**, nicht im Hauptprozess:

```
/usr/lib/firefox/firefox -contentproc -isForBrowser … -parentPid 7080 …
```

scanmem durchsucht standardmäßig nur `heap`, `stack`, `exe` und `bss`. Der
WASM-Block hat einen Namen und fällt deshalb heraus. Deshalb zuerst:

```
option region_scan_level 3
reset
lregions          # ID der wasm-reserved-Zeile merken (z. B. 42)
```

Dann nur in diesem Block suchen:

```
option scan_data_type number
dregion !42       # alle Regionen außer 42 löschen
```

`scan_data_type number` deckt `i16`, `i32`, `i64` und `f32` gleichzeitig ab.
Nach zwei Wertänderungen bleibt meist genau eine Adresse übrig:

```
set 0=999999999      # einmalig setzen
set 0=999999999/2    # alle 2 Sekunden neu setzen (Freeze)
```

Freeze beenden: `kill <scanmem-PID>`.

</details>

<details>
<summary><b>Glossar</b></summary>

| Begriff | Bedeutung |
| :--- | :--- |
| **Prozess** | Ein laufendes Programm. Firefox startet für jeden Tab einen eigenen. |
| **Arbeitsspeicher / Heap** | Der Bereich, in dem das Spiel seine Zahlen ablegt. |
| **Scannen** | Den Speicher nach einer bestimmten Zahl durchsuchen. |
| **Adresse** | Die genaue Stelle im Speicher, an der eine Zahl liegt. |
| **Freeze** | Einen Wert dauerhaft neu setzen, damit das Spiel ihn nicht zurückschreibt. |
| **int32** | Ganzzahl mit 32 Bit – der übliche Zahlentyp in diesen Spielen. |

</details>

---

## Disclaimer

Reverse-Engineering-Lernprojekt für kostenlose Einzelspieler-Browserspiele.
Es werden keine Server manipuliert und keine anderen Spieler beeinflusst.
Die Nutzung kann gegen die Nutzungsbedingungen von YouTube verstoßen –
Benutzung auf eigene Gefahr, ohne Gewähr.

## Lizenz

[MIT](LICENSE)
