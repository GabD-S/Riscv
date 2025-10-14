set terminal pngcairo size 1200,800 enhanced font 'Arial,12'
set output 'grafico_tempo_execucao.png'

# Configurações do gráfico
set title "Análise do Tempo de Execução do Algoritmo SORT\nProcessador RISC-V (50 MHz, CPI=1)" font "Arial Bold,16"
set xlabel "Tamanho do vetor (n)" font "Arial Bold,14"
set ylabel "Tempo de execução (μs)" font "Arial Bold,14"

# Grid com estilo personalizado
set grid xtics ytics mxtics mytics linetype 0 linewidth 1 linecolor rgb "#e0e0e0"
set grid back

# Configuração dos tics
set xtics font "Arial,11" nomirror
set ytics font "Arial,11" nomirror
set mxtics 2
set mytics 2

# Margem e posicionamento
set lmargin 12
set rmargin 5
set tmargin 3
set bmargin 4

# Define a legenda com estilo aprimorado
set key top left font "Arial,12" box linewidth 1.5 spacing 1.3 samplen 3
set key opaque

# Cores de fundo
set object 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgb "#ffffff" behind

# Configuração das bordas
set border linewidth 1.5

# Dados inline. As colunas são: n, t_o(n), t_i(n)
$data << EOD
10 2.48 12.16
20 4.68 46.26
30 6.88 102.36
40 9.08 180.46
50 11.28 280.56
60 13.48 402.66
70 15.68 546.76
80 17.88 712.86
90 20.08 900.96
100 22.28 1111.06
EOD

# Configuração de estilos de linha
set style line 1 linecolor rgb '#0072BD' linewidth 3 pointtype 7 pointsize 1.5  # Azul - Melhor caso
set style line 2 linecolor rgb '#D95319' linewidth 3 pointtype 9 pointsize 1.5  # Laranja/Vermelho - Pior caso
set style line 3 linecolor rgb '#0072BD' linewidth 1 pointtype 7 pointsize 1.0 dashtype 2  # Linha auxiliar azul
set style line 4 linecolor rgb '#D95319' linewidth 1 pointtype 9 pointsize 1.0 dashtype 2  # Linha auxiliar vermelha

# Comando para plotar os dados com estilo aprimorado
plot $data using 1:2 with linespoints linestyle 1 title "t_{o}(n): Melhor Caso (Linear: O(n))", \
     '' using 1:3 with linespoints linestyle 2 title "t_{i}(n): Pior Caso (Quadrático: O(n²))"

# Limpa o nome do arquivo de saída para que não fique bloqueado
unset output
