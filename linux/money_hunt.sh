#!/usr/bin/env bash
#
# money_hunt.sh - findet (und setzt) den Geldwert von "My Mini Mart"
#                 (YouTube Playables) mit scanmem unter Linux.
#
# money_hunt.sh - finds (and sets) the money value of "My Mini Mart"
#                 (YouTube Playables) with scanmem on Linux.
#
# Idee / Idea:
#   1. Scan nach dem aktuellen Geldwert (Typ "number": i16/i32/i64/f32).
#   2. Du aenderst das Geld im Spiel (kaufen/verkaufen).
#   3. Scan nach dem neuen Wert -> es bleibt (meist) genau eine Adresse.
#   4. Optional: Wert setzen und dauerhaft festhalten (freeze).
#
# Beispiele / Examples:
#   ./money_hunt.sh
#   ./money_hunt.sh --old 383 --new 463
#   ./money_hunt.sh --old 383 --new 463 --set 999999999 --freeze 2
#   ./money_hunt.sh --pid 12386 --old 383 --new 463 --set 1000000000
#
set -uo pipefail

OLD=""; NEW=""; PID=""; TARGET=""; FREEZE=""; ALLREG=0

usage() {
    sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --old)          OLD="$2"; shift 2 ;;
        --new)          NEW="$2"; shift 2 ;;
        --pid)          PID="$2"; shift 2 ;;
        --set)          TARGET="$2"; shift 2 ;;
        --freeze)       FREEZE="$2"; shift 2 ;;
        --all-regions)  ALLREG=1; shift ;;
        -h|--help)      usage 0 ;;
        *) echo "Unbekannte Option / unknown option: $1" >&2; usage 1 ;;
    esac
done

command -v scanmem >/dev/null || {
    echo "scanmem fehlt. Installieren / install: sudo pacman -S scanmem   (oder / or: sudo apt install scanmem)" >&2
    exit 1
}

# --- ptrace prüfen / check ptrace -------------------------------------------
if [[ $EUID -ne 0 ]]; then
    scope=$(cat /proc/sys/kernel/yama/ptrace_scope 2>/dev/null || echo 0)
    if [[ "$scope" != "0" ]]; then
        cat >&2 <<'EOF'
ptrace_scope ist nicht 0. Einmalig erlauben / allow once:
  sudo sh -c 'echo 0 > /proc/sys/kernel/yama/ptrace_scope'
(oder das Skript mit sudo starten / or run the script with sudo)
EOF
        exit 1
    fi
fi

# --- Prozess finden / find process ------------------------------------------
find_pid() {
    local best="" bestsize=0
    for p in $(pgrep -f contentproc 2>/dev/null); do
        [[ -r "/proc/$p/maps" ]] || continue
        while read -r range perms _; do
            [[ "$perms" == "rw-p" ]] || continue
            local start=${range%-*} end=${range#*-}
            local sz=$((16#$end - 16#$start))
            if (( sz > bestsize )); then best="$p"; bestsize="$sz"; fi
        done < <(grep 'wasm-reserved' "/proc/$p/maps" 2>/dev/null)
    done
    [[ -n "$best" ]] && printf '%s' "$best"
}

if [[ -z "$PID" ]]; then
    PID=$(find_pid)
    [[ -n "$PID" ]] || {
        echo "Kein WASM-Heap gefunden - laeuft das Spiel? / No WASM heap found - is the game running?" >&2
        exit 1
    }
fi
echo "Ziel-Prozess / target process: $PID"

# --- scanmem-Session ---------------------------------------------------------
tmpdir=$(mktemp -d /tmp/mmoney.XXXXXX)
fifo="$tmpdir/in"
out="$tmpdir/out"
mkfifo "$fifo"

scanmem "$PID" < "$fifo" > "$out" 2>&1 &
SM_PID=$!
exec 3>"$fifo"

send() { printf '%s\n' "$*" >&3; }

wait_for() { # pattern start_line timeout_s
    local pat="$1" start="$2" tmo="${3:-60}" i
    for ((i = 0; i < tmo * 10; i++)); do
        tail -n "+$((start + 1))" "$out" 2>/dev/null | grep -qE "$pat" && return 0
        sleep 0.1
    done
    return 1
}

cleanup() {
    exec 3>&- 2>/dev/null
    kill "$SM_PID" 2>/dev/null
    rm -rf "$tmpdir"
}

wait_for "Please enter current value" 0 15 || { echo "scanmem startet nicht / did not start:"; cat "$out"; exit 1; }

# --- WASM-Heap isolieren / isolate the WASM heap ----------------------------
send "option region_scan_level 3"
send "reset"
send "lregions"
sleep 2

wasm_line=$(awk '/wasm-reserved/' "$out" | tail -1)
rid=$(sed -E 's/^\[ *([0-9]+)\].*/\1/' <<<"$wasm_line")
base=$(awk '{print $2}' <<<"$wasm_line" | tr -d ',')

if [[ -n "$rid" && "$ALLREG" -eq 0 ]]; then
    echo "WASM-Heap / heap: 0x$base (Region $rid)"
    send "dregion !$rid"
else
    echo "Kein WASM-Heap gefunden, scanne alle Regionen / no WASM heap, scanning all regions"
fi
send "option scan_data_type number"

# --- 1. Scan ----------------------------------------------------------------
if [[ -z "$OLD" ]]; then
    read -r -p "Aktueller Geldwert im Spiel / current money in game: " OLD
fi

mark=$(wc -l < "$out")
send "$OLD"
if ! wait_for "currently have" "$mark" 180; then
    echo "Scan-Timeout. / scan timed out." >&2; cat "$out"; cleanup; exit 1
fi
n1=$(tail -n "+$((mark + 1))" "$out" | grep -oE 'currently have [0-9]+' | tail -1 | grep -oE '[0-9]+')
echo "Treffer nach 1. Scan / matches after 1st scan: $n1"

if [[ "$n1" == "0" ]]; then
    echo "Wert nicht gefunden - stimmt der Betrag? / value not found - correct amount?" >&2
    cleanup; exit 1
fi

# --- 2. Scan ----------------------------------------------------------------
if [[ -z "$NEW" ]]; then
    echo
    echo "Jetzt im Spiel Geld aendern (kaufen/verkaufen) - danach neuen Wert eingeben."
    echo "Now change the money in game (buy/sell) - then enter the new amount."
    read -r -p "Neuer Geldwert / new money: " NEW
fi

mark=$(wc -l < "$out")
send "$NEW"
wait_for "currently have" "$mark" 60
n2=$(tail -n "+$((mark + 1))" "$out" | grep -oE 'currently have [0-9]+' | tail -1 | grep -oE '[0-9]+')
echo "Treffer nach 2. Scan / matches after 2nd scan: $n2"

mark=$(wc -l < "$out")
send "list 200"
sleep 1

mapfile -t addrs < <(tail -n "+$((mark + 1))" "$out" | sed -n 's/^\[ *[0-9]*\] *\([0-9a-f]*\),.*/\1/p')

if [[ ${#addrs[@]} -eq 0 ]]; then
    echo "Keine Treffer. / no matches. Meist wurde der Wert zwischen den Scans mehrfach geaendert." >&2
    cleanup; exit 1
fi

printf 'Kandidaten / candidates (%d):\n' "${#addrs[@]}"
for a in "${addrs[@]}"; do
    if [[ -n "$base" ]]; then
        printf '  0x%s   (Offset / offset 0x%x)\n' "$a" $((16#$a - 16#$base))
    else
        printf '  0x%s\n' "$a"
    fi
done

if [[ ${#addrs[@]} -ne 1 ]]; then
    cat <<'EOF'

Es sind noch mehrere Kandidaten. Noch eine Runde:
  - Geld erneut aendern
  - Skript mit dem letzten Wert als --old und dem neuen als --new starten

Several candidates left. Do another round:
  - change money again
  - rerun with the last value as --old and the new one as --new
EOF
    cleanup
    exit 0
fi

addr=${addrs[0]}
echo
echo "Geld-Adresse / money address: 0x$addr"

if [[ -n "$TARGET" ]]; then
    if [[ -n "$FREEZE" ]]; then
        send "set 0=$TARGET/$FREEZE"
        sleep 1
        echo "Gesetzt / set: 0x$addr = $TARGET, alle ${FREEZE}s neu (freeze)."
        echo "scanmem PID: $SM_PID"
        echo "Stop: kill $SM_PID"
        exit 0   # Session absichtlich weiterlaufen lassen / keep session alive
    else
        send "set 0=$TARGET"
        sleep 1
        echo "Gesetzt / set: 0x$addr = $TARGET"
    fi
fi

cleanup
