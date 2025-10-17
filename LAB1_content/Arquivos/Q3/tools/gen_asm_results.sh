#!/usr/bin/env bash
# Gera um placeholder de resultados do Assembly (3.2.asm).
# Substitua as linhas da tabela resumo com seus dados reais medidos no RARS.

OUT="Arquivos/resultados_asm.txt"
{
  echo "# resultados_asm.txt"
  echo "# Método: Assembly (RV32IMF) — DFT 3.2.asm"
  echo "# Colunas (tabela resumo): sinal N exec_ms max_rss_MiB instr"
  echo "x1 8 0.000000 NA 0"
  echo "x2 8 0.000000 NA 0"
  echo "x3 8 0.000000 NA 0"
  echo "x4 8 0.000000 NA 0"
  echo ""
  echo "# DFT resultados por k (opcional) — linhas: k Re Im"
  echo "# 0 0.000000 0.000000"
} > "$OUT"

echo "Arquivo criado: $OUT"
