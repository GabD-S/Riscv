#!/usr/bin/env python3
import math
import time
import resource
from typing import List, Tuple

TWO_PI = 2.0 * math.pi

def dft_ref(x: List[float]) -> List[Tuple[float, float]]:
    N = len(x)
    X = []
    for k in range(N):
        sumR = 0.0
        sumI = 0.0
        for n in range(N):
            theta = TWO_PI * k * n / N
            c = math.cos(theta)
            s = -math.sin(theta)  # e^{-j theta}
            sumR += x[n] * c
            sumI += x[n] * s
        X.append((sumR, sumI))
    return X

def ru_maxrss_mib() -> float:
    # On Linux, ru_maxrss is in kilobytes
    kb = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    return kb / 1024.0

def main():
    t0 = time.perf_counter()
    # "Compilação" em Python é apenas a definição das funções e carga do dataset
    dataset = [
        ("x1", [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]),
        ("x2", [1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071, 0.0, 0.7071]),
        ("x3", [0.0, 0.7071, 1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071]),
        ("x4", [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]),
    ]
    t1 = time.perf_counter()
    compile_ms = (t1 - t0) * 1000.0

    lines = []
    lines.append("# resultados_python.txt\n")
    lines.append("# Método: Python (double, referência)\n")
    lines.append("# Colunas (tabela resumo): sinal N exec_ms max_rss_MiB instr\n")

    # Tabela resumo
    for name, x in dataset:
        start = time.perf_counter()
        X = dft_ref(x)
        end = time.perf_counter()
        exec_ms = (end - start) * 1000.0
        mem_mib = ru_maxrss_mib()
        instr = "NA"  # Não coletado aqui
        lines.append(f"{name} {len(x)} {exec_ms:.6f} {mem_mib:.3f} {instr}\n")

    lines.append("\n# Compilacao (aprox.) em ms\n")
    lines.append(f"compile_ms {compile_ms:.6f}\n")

    # Blocos com resultados DFT por sinal
    for name, x in dataset:
        X = dft_ref(x)
        lines.append(f"\n# DFT resultados para {name} (k Re Im)\n")
        for k, (re, im) in enumerate(X):
            lines.append(f"{k} {re:.6f} {im:.6f}\n")

    with open("Arquivos/resultados_python.txt", "w", encoding="utf-8") as f:
        f.writelines(lines)

if __name__ == "__main__":
    main()
