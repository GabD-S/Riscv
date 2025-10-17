#!/usr/bin/env bash
set -euo pipefail

PY=Arquivos/resultados_python.txt
ASM=Arquivos/resultados_asm.txt
OUT=Arquivos/bench_merged.dat

awk 'NF==5 && $1!~/#/ {print NR, $1, $3}' "$PY" > Arquivos/py.tmp
awk 'NF==5 && $1!~/#/ {print NR, $1, $3}' "$ASM" > Arquivos/asm.tmp
sort -k1,1 Arquivos/py.tmp > Arquivos/py.s
sort -k1,1 Arquivos/asm.tmp > Arquivos/asm.s
join -1 1 -2 1 Arquivos/py.s Arquivos/asm.s | awk '{asm=($6==""?0:$6); print $1, $2, $3, asm}' > "$OUT"
echo "Merged -> $OUT"
