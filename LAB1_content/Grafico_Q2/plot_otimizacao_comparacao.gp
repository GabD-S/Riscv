#!/usr/bin/gnuplot

# Configuração do terminal e saída
set terminal pngcairo size 1200,600 enhanced font 'Arial,12'
set output 'figures/grafico_otimizacao_comparacao.png'

# Configuração do gráfico
set style data histograms
set style histogram clustered gap 1
set style fill solid 0.8 border -1
set boxwidth 0.9

# Configuração dos eixos
set ylabel "Instruções Executadas" font "Arial,14"
set y2label "Tamanho (bytes)" font "Arial,14"
set xlabel "Nível de Otimização" font "Arial,14"

set ytics nomirror
set y2tics

set yrange [0:11000]
set y2range [0:4000]

# Grid
set grid ytics linetype 0 linewidth 1 linecolor rgb "#cccccc"

# Legenda
set key top right font "Arial,11"

# Título
set title "Comparação entre Níveis de Otimização" font "Arial,16"

# Cores personalizadas
set linetype 1 lc rgb "#0072BD"
set linetype 2 lc rgb "#D95319"

# Dados
set datafile separator whitespace

# Plot com dois eixos Y
plot '-' using 2:xtic(1) title 'Instruções Executadas' axes x1y1 lc rgb "#0072BD", \
     '-' using 2:xtic(1) title 'Tamanho (bytes)' axes x1y2 lc rgb "#D95319"

-O0 10103
-O3 2484
-Os 4406
e

-O0 3817
-O3 2152
-Os 2543
e
