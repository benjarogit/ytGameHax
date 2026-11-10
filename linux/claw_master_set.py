#!/usr/bin/env python3
"""Set the three Claw Master currencies (coins, yellow stars, red stars).

Claw Master keeps all three values in one 0x60 record inside the WASM heap:

    record + 0x00   pointer-ish value (constant while the game data is loaded)
    ...
    record + 0x20   coins
    record + 0x38   yellow stars
    record + 0x50   red stars

Every record contains the constant pair `236588110, -1` at `coins + 0x08`, which
is used as an anchor: the script does not need to know the current values from
the HUD and also works while the coins keep ticking up.

It picks the record with the highest coin count (= the active save) and writes
the new values into every copy that shares its star counts.

Usage:
    sudo python3 claw_master_set.py --show
    sudo python3 claw_master_set.py --new-coins 99999 --new-yellow 8888 --new-red 7777
    sudo python3 claw_master_set.py --new-coins 99999 --dry-run

With --pid the script only looks at that process; otherwise it picks the Firefox
content process with the largest wasm-reserved heap.
"""
import argparse
import os
import struct
import sys

ANCHOR = struct.pack("<ii", 236588110, -1)  # at coins + 0x08
COINS = 0x00
YELLOW = 0x18
RED = 0x30


def find_heap(pid=None):
    """Return (pid, base, size) of the biggest rw wasm-reserved mapping."""
    pids = [pid] if pid else []
    if pid is None:
        for entry in os.listdir("/proc"):
            if not entry.isdigit():
                continue
            try:
                with open(f"/proc/{entry}/cmdline", "rb") as f:
                    cmd = f.read().replace(b"\0", b" ").decode(errors="replace")
            except OSError:
                continue
            if "contentproc" in cmd:
                pids.append(int(entry))

    best = None
    for p in pids:
        try:
            with open(f"/proc/{p}/maps") as f:
                for line in f:
                    if "wasm-reserved" not in line:
                        continue
                    parts = line.split()
                    if len(parts) < 2 or parts[1] != "rw-p":
                        continue
                    start, end = (int(x, 16) for x in parts[0].split("-"))
                    size = end - start
                    if best is None or size > best[2]:
                        best = (p, start, size)
        except OSError:
            continue
    if best is None:
        sys.exit("error: no Firefox content process with a wasm-reserved heap found")
    return best


def read_heap(pid, base, size):
    with open(f"/proc/{pid}/mem", "rb", 0) as f:
        f.seek(base)
        return f.read(size)


def find_records(data):
    """Return [(offset_of_coins, coins, yellow, red), ...]."""
    records = []
    pos = data.find(ANCHOR)
    while pos != -1:
        if pos % 4 == 0 and pos >= 8 and pos + 0x2C <= len(data):
            coins = struct.unpack_from("<i", data, pos - 8)[0]
            yellow = struct.unpack_from("<i", data, pos + 0x10)[0]
            red = struct.unpack_from("<i", data, pos + 0x28)[0]
            if 0 <= coins and 0 <= yellow < 1_000_000 and 0 <= red < 1_000_000:
                records.append((pos - 8, coins, yellow, red))
        pos = data.find(ANCHOR, pos + 1)
    return records


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pid", type=int)
    ap.add_argument("--show", action="store_true", help="list records and exit")
    ap.add_argument("--new-coins", type=int)
    ap.add_argument("--new-yellow", type=int)
    ap.add_argument("--new-red", type=int)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    pid, base, size = find_heap(args.pid)
    print(f"process {pid}, heap {base:#x} ({size / 1048576:.1f} MB)")

    records = find_records(read_heap(pid, base, size))
    if not records:
        sys.exit("error: no Claw Master currency record found")

    live = max(records, key=lambda rec: rec[1])
    group = [rec for rec in records if rec[2:] == live[2:]]
    print(f"active save: coins={live[1]} yellow={live[2]} red={live[3]} "
          f"({len(group)} of {len(records)} records)")
    for off, coins, yellow, red in group:
        print(f"  {base + off:#x}  (heap offset {off:#x})")

    if args.show:
        return
    if args.new_coins is None and args.new_yellow is None and args.new_red is None:
        sys.exit("error: give at least one of --new-coins/--new-yellow/--new-red")

    new = {COINS: args.new_coins, YELLOW: args.new_yellow, RED: args.new_red}
    if args.dry_run:
        print("dry run:", {k: v for k, v in new.items() if v is not None})
        return

    with open(f"/proc/{pid}/mem", "r+b", 0) as f:
        for off, _, _, _ in group:
            for field, value in new.items():
                if value is None:
                    continue
                f.seek(base + off + field)
                f.write(struct.pack("<i", value))
        f.flush()
    print("written. trigger an in-game event (kill an enemy) so the HUD refreshes.")


if __name__ == "__main__":
    main()
