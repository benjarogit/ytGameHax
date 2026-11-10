# YouTube Playables – Memory Hacks

[Deutsch](README.md) · **English**

Notes and tools for finding and changing values like **money** in YouTube
Playables games via process memory:

- **Linux** → [scanmem](https://github.com/scanmem/scanmem)
- **Windows** → [Cheat Engine](https://www.cheatengine.org/)
- **macOS** → [Bit Slicer](https://github.com/zorgiepoo/Bit-Slicer)

All games run as WebAssembly (Unity) in the browser. The values live in the
WASM heap of a **Firefox content process** – not in the main process and not on
a server.

---

## Games

| Game | What | Guide |
| --- | --- | --- |
| **My Mini Mart** | money | [games/my-mini-mart.md](games/my-mini-mart.md) |
| **Pizza Inc.** | money | [games/pizza-inc.md](games/pizza-inc.md) |
| **Claw Master** | coins, yellow & red stars | [games/claw-master.md](games/claw-master.md) |

Each game page has a screenshot of the result, the addresses that were found
and the specifics of that game.

---

## Why this works

### 1. The browser is not the process you are looking for

Firefox puts every website into its own **content process**. The game keeps its
whole state in a large `[anon:wasm-reserved]` block.

Visible in `ps` as:

```
/usr/lib/firefox/firefox -contentproc -isForBrowser … -parentPid 7080 …
```

### 2. Why scanmem does not see the heap at first

By default scanmem only scans `heap`, `stack`, `exe` and `bss`. The WASM heap
has a **name** (`[anon:wasm-reserved]`) and is therefore skipped. So first:

```
option region_scan_level 3
reset
lregions
```

Look for the line containing `[anon:wasm-reserved]` – you need the region ID in
front of it (e.g. `43`).

### 3. Scan only inside the WASM heap

```
option scan_data_type number
dregion !43
```

- `region_scan_level 3` → scan named/anonymous regions too
- `dregion !43` → delete all regions **except** 43 (`!` inverts the set)
- `scan_data_type number` → covers `i16/i32/i64/f32` at once

### 4. The real trick: use the change as a filter

A single scan often returns thousands of hits (prices, counters, textures …).
The filter is the **change**:

1. Scan for the current value (e.g. `750`)
2. Buy/sell in game so the value changes (e.g. `650`)
3. Scan for the new value → only a few candidates remain
4. One more change → usually exactly one address

### 5. Filter first, write later

> **Important:** never write to hundreds of candidates at once. A mass write
> test crashed a tab once. Filter down to a few addresses first – then write.

```
set 0=999999999      # set once
set 0=999999999/2    # re-set every 2 seconds (freeze)
```

---

## Usage

### Linux (scanmem)

**Install**

```bash
# Arch / CachyOS / Manjaro
sudo pacman -S scanmem

# Debian / Ubuntu / Mint
sudo apt install scanmem
```

**Allow ptrace** (once, until reboot):

```bash
sudo sh -c 'echo 0 > /proc/sys/kernel/yama/ptrace_scope'
```

**Quick start with the script**

```bash
git clone https://github.com/benjarogit/ytGameHax.git
cd ytGameHax
chmod +x linux/*.sh

./linux/find_game_process.sh        # PID + heap base
./linux/money_hunt.sh --old 750 --new 650 --set 999999999 --freeze 2
```

The script scans the old value, waits while you buy/sell in game, you enter the
new value – then it sets the target value and keeps it frozen. Run without
arguments for an interactive flow.

**Manual**

```bash
scanmem <PID>
```

Then inside the scanmem console:

```
option region_scan_level 3
reset
lregions                      # note the wasm-reserved region ID
option scan_data_type number
dregion !<ID>
750                           # current value
```

Change the value in game, then:

```
650                           # new value
list                          # show candidates
set 0=999999999/2             # set + freeze
```

Stop the freeze: `kill <scanmem-pid>`.

### Windows (Cheat Engine)

Details: [`windows/README.md`](windows/README.md)

1. Open the game, note the value (e.g. `750`).
2. Task Manager → Details → pick the **`firefox.exe` with the highest memory
   usage** (the content process of the tab).
3. Cheat Engine → "Open Process" → that process.
4. Value Type **4 Bytes**, First Scan: `750`.
5. Buy/sell in game (e.g. `650`) → **Next Scan**: `650`.
6. One address remains → double-click → change value, tick the freeze box.

### macOS (Bit Slicer)

Details: [`macos/README.md`](macos/README.md)

1. Open the game, note the value.
2. Bit Slicer → Target: the Firefox process with the big WASM heap.
3. Search: **4-byte integer**, `750` → Search.
4. Change the value in game (e.g. `650`) → Search.
5. Edit the remaining address or enable "Lock".

---

## Files

```
games/my-mini-mart.md        game page incl. screenshot and values
games/pizza-inc.md           game page incl. screenshot and values
games/claw-master.md         game page incl. screenshot and values
linux/find_game_process.sh   auto-detect process + WASM heap
linux/money_hunt.sh          two-scan hunt incl. set/freeze
linux/claw_master_set.py     set coins + both star counts in Claw Master
windows/README.md            Cheat Engine guide (DE/EN)
macos/README.md              Bit Slicer guide (DE/EN)
docs/img/                    game screenshots
```

---

## Limits & notes

- **The address is not permanent:** after a reload the tab gets a new process
  and usually a new heap offset. Repeat the procedure.
- **int32 limit:** values above `2,147,483,647` overflow. `999999999` is safe.
- **Freeze writes periodically:** intended, because the game constantly deducts
  expenses. Stop it with `kill`.
- **Client-side only:** nothing is sent to YouTube servers.
- **No Cheat Engine on Linux:** Cheat Engine is Windows software; scanmem does
  the same job natively.

---

## Disclaimer

Reverse-engineering learning project for free single-player browser games.
No servers are manipulated and no other players are affected. Using it may
violate YouTube's terms of service – use at your own risk, no warranty.

## License

[MIT](LICENSE)
