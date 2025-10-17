#!/usr/bin/env gnuplot
# Plota tempos de execucao de Python vs Assembly para os sinais x1..x4

set terminal pngcairo size 1000,600
set output 'Arquivos/fig_benchmarks.png'
set title 'DFT N=8 — Python (ref) vs Assembly (3.2.asm)'
set grid
set key outside
set xlabel 'Sinal'
set ylabel 'Tempo de execucao (ms)'

# Vamos construir dados intermediarios pegando apenas as linhas sem '#'
python_data = 'Arquivos/resultados_python.txt'
asm_data    = 'Arquivos/resultados_asm.txt'

set datafile commentschars '#'
set style data histograms
set style histogram cluster gap 1
set boxwidth 0.9
set style fill solid border -1

# Para facilitar, criamos um arquivo temporario com colunas: idx label py_ms asm_ms
tmp = 'Arquivos/bench_merged.dat'
system sprintf("awk 'NF==5 && $1!~/#/ {print NR, $1, $3}' %s > Arquivos/py.tmp", python_data)
system sprintf("awk 'NF==5 && $1!~/#/ {print NR, $1, $3}' %s > Arquivos/asm.tmp", asm_data)
system "sort -k1,1 Arquivos/py.tmp > Arquivos/py.s"
system "sort -k1,1 Arquivos/asm.tmp > Arquivos/asm.s"
system "join -1 1 -2 1 Arquivos/py.s Arquivos/asm.s | awk '{print $1, $2, $3, $6}' > Arquivos/bench_merged.dat"

plot tmp using 3:xtic(2) title 'Python (ms)', \
     '' using 4 title 'Assembly (ms)'

unset output
print 'Figura gerada: Arquivos/fig_benchmarks.png'
