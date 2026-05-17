#!/usr/bin/env bash
# run_experiments.sh
# Runs all four schedulers across several patron counts and random seeds,
# producing one results/CSV per combination for later analysis.
#
# Usage:  ./run_experiments.sh
#
# Output: results/<SCHEDULER>_<patrons>_<seed>.csv  (appended per run)

set -euo pipefail

# ── Configuration ────────────────────────────────────────────────────────────
PATRONS=(20 40 60 80 100)           # range of patron counts to test
SEEDS=(42 123 456 789 1024)     # five different seeds → five workload replicas
SCHEDULERS=(0 1 2 3)            # 0=FCFS 1=SJF 2=Priority 3=MLFQ
SWITCH_TIME=0                   # context-switch overhead in ms (keep 0 for fair comparison)
BIN_DIR=bin
MAIN=barScheduling.SchedulingSimulation
LOG_DIR=logs
# ─────────────────────────────────────────────────────────────────────────────

mkdir -p results "$LOG_DIR"

# Compile once before the loop
echo "=== Compiling ==="
mkdir -p "$BIN_DIR"
javac -d "$BIN_DIR" barScheduling/*.java
echo "=== Compilation OK ==="

total=$(( ${#PATRONS[@]} * ${#SEEDS[@]} * ${#SCHEDULERS[@]} ))
run=0

for n in "${PATRONS[@]}"; do
    for seed in "${SEEDS[@]}"; do
        for sched in "${SCHEDULERS[@]}"; do
            run=$(( run + 1 ))
            echo "[${run}/${total}]  patrons=${n}  seed=${seed}  scheduler=${sched}"

            log="${LOG_DIR}/run_${sched}_${n}_${seed}.log"

            java -cp "$BIN_DIR" "$MAIN" \
                "$n" "$sched" "$SWITCH_TIME" "$seed" \
                > "$log" 2>&1

        done
    done
done

echo ""
echo "=== All ${total} runs complete ==="
