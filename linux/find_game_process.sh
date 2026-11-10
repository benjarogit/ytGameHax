#!/usr/bin/env bash
#
# find_game_process.sh
# Findet den Firefox-Content-Process, der den WASM-Heap eines
# YouTube-Playables-Spiels (z. B. "My Mini Mart") haelt.
#
# Finds the Firefox content process that hosts the WASM heap of a
# YouTube Playables game (e.g. "My Mini Mart").
#
# Ausgabe / Output:
#   PID  <pid>  HEAP <base-hex>  SIZE <bytes>
#
set -uo pipefail

best_pid=""
best_size=0
best_base=""

for p in $(pgrep -f contentproc 2>/dev/null); do
    [[ -r "/proc/$p/maps" ]] || continue

    while read -r range perms _rest; do
        [[ "$perms" == "rw-p" ]] || continue
        start=${range%-*}
        end=${range#*-}
        size=$((16#$end - 16#$start))
        if (( size > best_size )); then
            best_pid="$p"
            best_size="$size"
            best_base="$start"
        fi
    done < <(grep 'wasm-reserved' "/proc/$p/maps" 2>/dev/null)
done

if [[ -z "$best_pid" ]]; then
    echo "Kein WASM-Heap gefunden. Laeuft das Spiel? / No WASM heap found. Is the game running?" >&2
    exit 1
fi

printf 'PID  %s\nHEAP %s\nSIZE %s\n' "$best_pid" "$best_base" "$best_size"
