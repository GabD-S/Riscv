# gnuplot script: N vs ms_per_call
set terminal pngcairo size 1200,800 enhanced font 'Helvetica,12'
set output 'Arquivos/Q3/results/figures/fig_n_vs_ms_call.png'
set title 'Tempo por chamada da DFT (ms) vs N'
set grid lw 1 lc rgb '#cccccc'
set border lw 1
set key top left box opaque
set xlabel 'N'
set ylabel 'Tempo por chamada (ms/call)'
set xtics nomirror out
set ytics nomirror out
set tics font ',10'
set style line 1 lc rgb '#1f77b4' lw 3 pt 7 ps 1.5
set style line 2 lc rgb '#ff7f0e' lw 2 dt 2
set datafile separator comma
# Fit quadrático (opcional) para tendência O(N^2)
f(x) = a*x*x + b*x + c
fit f(x) 'Arquivos/Q3/results/bench_dft.csv' using 1:7 via a,b,c
plot \
  'Arquivos/Q3/results/bench_dft.csv' using 1:7 with linespoints ls 1 title 'ms/call', \
  f(x) with lines ls 2 title sprintf('ajuste: %.2e N^2 %+ .2e N %+ .2e', a,b,c)
