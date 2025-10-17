# Gnuplot: compara DFT ASM x Python para x1
set terminal pngcairo size 900,500
set output 'Arquivos/fig_compare_asm_python.png'
set datafile separator ','
set key outside right
set grid
set title 'DFT x1: Python vs Assembly'
set xlabel 'k'
set ylabel 'Valor'

# We'll plot real and imag separately in two panels
set multiplot layout 1,2 title 'DFT x1 - Comparacao por componente'

# Painel esquerdo: parte real
set title 'Parte Real'
plot 'Arquivos/comparacao_dft.csv' using 1:2 with linespoints title 'Python Re', \
     'Arquivos/comparacao_dft.csv' using 1:4 with linespoints title 'ASM Re', \
     'Arquivos/comparacao_dft.csv' using 1:6 with impulses title 'Erro Re (ASM-Py)'

# Painel direito: parte imaginaria
set title 'Parte Imaginaria'
plot 'Arquivos/comparacao_dft.csv' using 1:3 with linespoints title 'Python Im', \
     'Arquivos/comparacao_dft.csv' using 1:5 with linespoints title 'ASM Im', \
     'Arquivos/comparacao_dft.csv' using 1:7 with impulses title 'Erro Im (ASM-Py)'

unset multiplot
print 'Figura gerada: Arquivos/fig_compare_asm_python.png'
