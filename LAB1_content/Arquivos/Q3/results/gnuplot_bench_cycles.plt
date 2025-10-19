# gnuplot script: N vs cycles_per_call
set terminal pngcairo size 1200,800 enhanced font 'Helvetica,12'
set output 'Arquivos/Q3/results/figures/fig_n_vs_cycles_call.png'
set title 'Ciclos por chamada da DFT vs N'
set grid lw 1 lc rgb '#cccccc'
set border lw 1
set key top left box opaque
set xlabel 'N'
set ylabel 'Ciclos por chamada'
set xtics nomirror out
set ytics nomirror out
set tics font ',10'
set style line 1 lc rgb '#2ca02c' lw 3 pt 7 ps 1.5
set style line 2 lc rgb '#d62728' lw 2 dt 2
set datafile separator comma
# Fit quadrático para refletir O(N^2)
g(x) = p*x*x + q*x + r
fit g(x) 'Arquivos/Q3/results/bench_dft.csv' using 1:6 via p,q,r
plot \
  'Arquivos/Q3/results/bench_dft.csv' using 1:6 with linespoints ls 1 title 'cycles/call', \
  g(x) with lines ls 2 title sprintf('ajuste: %.2e N^2 %+ .2e N %+ .2e', p,q,r)
