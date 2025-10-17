#!/usr/bin/env python3
import re
from pathlib import Path

PY_FILE = Path("Arquivos/resultados_python.txt")
ASM_FILE = Path("Arquivos/saida_dft_asm.txt")
OUT_CSV = Path("Arquivos/comparacao_dft.csv")

# We'll compare against Python's x1 (1,0,0,0,...) of length 8
TARGET_LABEL = "x1"

num_pat = re.compile(r"[-+]?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?")

def parse_asm_lines(lines):
    # Expect header then up to 8 lines like: "1.0    Re + Im i"
    values = []
    for line in lines:
        line = line.strip()
        if not line:
            continue
        if 'x[n]' in line or 'X[k]' in line:
            continue
        nums = num_pat.findall(line)
        # debug: print line and found numbers
        # print(f"ASM LINE: {line} -> {nums}")
        if len(nums) >= 3:
            x_val = float(nums[0])
            re_val = float(nums[1])
            im_val = float(nums[2])
            values.append((x_val, re_val, im_val))
            if len(values) == 8:
                break
    return values

def parse_python_block(text, label):
    # find block "# DFT resultados para x1 (k Re Im)" then 8 lines of k re im
    lines = text.splitlines()
    start = None
    for i, ln in enumerate(lines):
        if ln.strip().startswith(f"# DFT resultados para {label}"):
            start = i + 1
            break
    out = []
    if start is None:
        return out
    for ln in lines[start:]:
        ln = ln.strip()
        if not ln or ln.startswith('#'):
            if len(out) >= 8:
                break
            continue
        parts = ln.split()
        if len(parts) >= 3:
            try:
                k = int(parts[0]); re_val = float(parts[1]); im_val = float(parts[2])
                out.append((k, re_val, im_val))
                if len(out) == 8:
                    break
            except:
                continue
    return out


def main():
    if not PY_FILE.exists():
        # tenta gerar
        import subprocess
        subprocess.run(["python3", "Arquivos/gen_python_results.py"], check=False)
    py_text = PY_FILE.read_text(encoding='utf-8')
    asm_text = ASM_FILE.read_text(encoding='utf-8')

    py_vals = parse_python_block(py_text, TARGET_LABEL)
    asm_vals = parse_asm_lines(asm_text.splitlines())

    if len(py_vals) != 8 or len(asm_vals) != 8:
        print(f"Aviso: contagens -> python={len(py_vals)} asm={len(asm_vals)} (esperado 8)")
        if len(py_vals) == 0 or len(asm_vals) == 0:
            raise SystemExit("Dados insuficientes: gere resultados de Python e verifique o arquivo ASM.")

    # Write CSV with columns: k, py_re, py_im, asm_re, asm_im, err_re, err_im
    lines = ["k,py_re,py_im,asm_re,asm_im,err_re,err_im\n"]
    rows = min(8, len(py_vals), len(asm_vals))
    for k in range(rows):
        _, py_re, py_im = py_vals[k]
        _, asm_re, asm_im = asm_vals[k]
        err_re = asm_re - py_re
        err_im = asm_im - py_im
        lines.append(f"{k},{py_re},{py_im},{asm_re},{asm_im},{err_re},{err_im}\n")

    OUT_CSV.write_text(''.join(lines), encoding='utf-8')
    print(f"Gerado {OUT_CSV}")

if __name__ == "__main__":
    main()
