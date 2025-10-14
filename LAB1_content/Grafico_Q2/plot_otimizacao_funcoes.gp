#!/usr/bin/gnuplot

# Configuração do terminal e saída
set terminal pngcairo size 1200,700 enhanced font 'Arial,12'
set output 'figures/grafico_otimizacao_funcoes.png'

# Configuração do gráfico
set style data histograms
set style histogram clustered gap 1
set style fill solid 0.8 border -1
set boxwidth 0.9

# Configuração dos eixos
set ylabel "Número de Instruções" font "Arial,14"
set xlabel "Função" font "Arial,14"

set yrange [0:8]
set ytics 1

# Grid
set grid ytics linetype 0 linewidth 1 linecolor rgb "#cccccc"

# Legenda
set key top right font "Arial,11"

# Título
set title "Comparação de Instruções: -O0 vs -O1" font "Arial,16"

# Cores personalizadas
set linetype 1 lc rgb "#0072BD"
set linetype 2 lc rgb "#77AC30"

# Dados
set datafile separator whitespace

# Plot
plot '-' using 2:xtic(1) title '-O0 (Sem otimização)' lc rgb "#0072BD", \
     '-' using 2:xtic(1) title '-O1 (Otimização básica)' lc rgb "#77AC30"

f1 5
f2 5
f3 6
f4 7
f5 7
f6 6
e

f1 3
f2 3
f3 4
f4 5
f5 5
f6 4
e
