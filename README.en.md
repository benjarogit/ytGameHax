# ytGameHax

**Change money, coins and stars in YouTube Playables games – no experience needed.**

[Deutsch](README.md) · [English](README.en.md)

![Platforms](https://img.shields.io/badge/platforms-Linux%20%7C%20Windows%20%7C%20macOS-3b82f6?style=flat-square)
![Games](https://img.shields.io/badge/games-3-22c55e?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-6b7280?style=flat-square)

> **The whole idea in one sentence**
> The game stores your money as a number in memory. We find that number, change
> it in game, and then write a bigger number to the same spot.

No mod, nothing installed into the game, nothing is sent to YouTube.
It takes one to two minutes per game.

---

## 1. Pick a game

| Game | What you can change | Time | Guide |
| :--- | :--- | :---: | :--- |
| **Claw Master** | coins, yellow & red stars | ~1 min | **[Guide →](games/claw-master.md)** |
| **Pizza Inc.** | money | ~2 min | **[Guide →](games/pizza-inc.md)** |
| **My Mini Mart** | money | ~2 min | **[Guide →](games/my-mini-mart.md)** |

Every game page contains: a clickable screenshot of the result, step-by-step
instructions, the values that were found, and troubleshooting.

---

## 2. The principle – the same in every game

1. **Search** – scan for the current value (e.g. `750`).
2. **Change** – buy or sell in game (e.g. `650`).
3. **Replace** – scan for the new value. The right address is what's left –
   write a big number into it.

> 💡 **Why this works:** a single scan finds thousands of numbers (prices,
> counters, graphics data). The **change** is the filter: only the real money
> value changed exactly like the display did.

---

## 3. Your operating system

| System | Tool | How |
| :--- | :--- | :--- |
| **Linux** | [scanmem](https://github.com/scanmem/scanmem) + scripts | one terminal command |
| **Windows** | [Cheat Engine](https://www.cheatengine.org/) | [click guide](windows/README.md) |
| **macOS** | [Bit Slicer](https://github.com/zorgiepoo/Bit-Slicer) | [click guide](macos/README.md) |

### Linux – the shortest path

**Prepare once** (terminal):

```bash
# install scanmem
sudo pacman -S scanmem        # Arch / CachyOS / Manjaro
sudo apt install scanmem      # Debian / Ubuntu / Mint

# let scanmem look into other programs (valid until reboot)
sudo sh -c 'echo 0 > /proc/sys/kernel/yama/ptrace_scope'
```

**Get the repo and make the scripts executable:**

```bash
git clone https://github.com/benjarogit/ytGameHax.git
cd ytGameHax
chmod +x linux/*.sh linux/*.py
```

**Open the game in your browser, then:**

```bash
# Claw Master: sets coins + both star counts, no further input needed
sudo python3 linux/claw_master_set.py --easy

# money games (Pizza Inc., My Mini Mart): asks for the values
sudo ./linux/money_hunt.sh --set 999999999 --freeze 2          # one address
sudo ./linux/money_hunt.sh --set 999999999 --freeze 2 --all    # all copies
```

Afterwards **keep playing for a moment** in game (e.g. defeat an enemy) so the
display picks up the new values.

<details>
<summary><b>What exactly does the script do?</b></summary>

`claw_master_set.py` searches the memory of the correct browser process for the
record that holds coins and stars together, then rewrites every copy of that
record. You don't have to read or type any values.

`money_hunt.sh` asks for the current and the new value, scans, filters, and
finally writes the target value. Without arguments it runs in a guided mode;
with arguments it is faster:

```bash
sudo ./linux/money_hunt.sh --old 750 --new 650 --set 999999999 --freeze 2
sudo ./linux/money_hunt.sh --old 750 --new 650 --set 999999999 --freeze 2 --all
```

`--all` writes all remaining copies (at most 8) at once – needed for Pizza Inc.,
which keeps the money value in four places.

</details>

### Windows and macOS

There, a program with a window does the work. The click guide is the same for
all games – only the numbers you type come from the game page:

- **[Windows → Cheat Engine](windows/README.md)**
- **[macOS → Bit Slicer](macos/README.md)**

---

## 4. If something doesn't work

| Problem | Fix |
| :--- | :--- |
| "No process found" | The game tab must be open and fully loaded. Reload it and run the script again. |
| `scanmem: command not found` | Install scanmem (see above). |
| The value drops back | For money games use the **freeze** – the game keeps deducting expenses. |
| Display stays old | Trigger an in-game event (buy, sell, defeat an enemy). Some games only redraw then. |
| Everything is gone after a reload | Normal: the address changes. Repeat the guide once (~1 minute). |
| `ptrace_scope` error on Linux | Run `sudo sh -c 'echo 0 > /proc/sys/kernel/yama/ptrace_scope'` or start the script with `sudo`. |

---

## 5. Limits & notes

- **Addresses are not permanent.** After a reload or browser restart the tab
  gets new memory – repeat the procedure.
- **32-bit limit:** maximum `2,147,483,647`. Above that the value overflows.
  `999999999` is safe; in Claw Master use `99999` coins (the display has only
  five digits).
- **Never write to hundreds of hits at once.** Filter down to a few addresses
  first – a mass write has crashed a tab before.
- **Client-side only:** nothing is sent to YouTube, other players are not
  affected.
- **Cheat Engine is Windows only.** On Linux, scanmem does the same job natively.

---

<details>
<summary><b>How it works: why the WASM heap is special</b></summary>

The games run as WebAssembly (Unity) in the browser. Firefox keeps the whole
game state in one big memory block called `[anon:wasm-reserved]` – and in a
separate **content process**, not in the main process:

```
/usr/lib/firefox/firefox -contentproc -isForBrowser … -parentPid 7080 …
```

By default scanmem only searches `heap`, `stack`, `exe` and `bss`. The WASM
block has a name and is therefore skipped. So first:

```
option region_scan_level 3
reset
lregions          # note the ID of the wasm-reserved line (e.g. 42)
```

Then search only in that block:

```
option scan_data_type number
dregion !42       # delete all regions except 42
```

`scan_data_type number` covers `i16`, `i32`, `i64` and `f32` at once.
After two value changes usually exactly one address remains:

```
set 0=999999999      # set once
set 0=999999999/2    # re-set every 2 seconds (freeze)
```

Stop the freeze: `kill <scanmem PID>`.

</details>

<details>
<summary><b>Glossary</b></summary>

| Term | Meaning |
| :--- | :--- |
| **Process** | A running program. Firefox starts one per tab. |
| **Memory / heap** | The area where the game keeps its numbers. |
| **Scan** | Searching memory for a specific number. |
| **Address** | The exact spot in memory where a number lives. |
| **Freeze** | Re-writing a value continuously so the game can't overwrite it. |
| **int32** | 32-bit integer – the usual number type in these games. |

</details>

---

## Disclaimer

Reverse-engineering learning project for free single-player browser games. No
servers are manipulated and no other players are affected. Using it may violate
YouTube's terms of service – use at your own risk, no warranty.

## License

[MIT](LICENSE)
