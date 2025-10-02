# RISC-V Lab 1

Este repositório contém arquivos de laboratório (LAB1) para estudo de Assembly RISC-V.

## Estrutura

```
Arquivos/
  riscv1.asm        # Código assembly principal / exemplo
  sort.s            # Rotina de ordenação em assembly
  sortc.c           # Implementação C de ordenação (baseline)
  sortc_mod.c       # Versão modificada/otimizada em C
  teste0.c .. teste13.c # Casos de teste/geradores/exercícios em C
  Rars16_Custom1.jar # Ferramenta RARS (simulador RISC-V)
  desktop.ini       # Arquivo de sistema (ignorado)
OAC_LAB1.pdf        # Enunciado/descrição do laboratório
```

## Dependências e Ferramentas

- RARS (incluído: `Rars16_Custom1.jar`)
- GCC / Clang (para compilar os códigos C) 
- `make` (opcional, se desejar criar um Makefile no futuro)

## Como executar o assembly com RARS

Exemplo (GUI):
1. Abra o RARS: `java -jar Arquivos/Rars16_Custom1.jar` (ajuste o nome se necessário)
2. File > Open > selecione `Arquivos/riscv1.asm`
3. Assemble > Run

Modo CLI (exemplo - se a versão suportar):
```
java -jar Arquivos/Rars16_Custom1.jar mc CompactDataAtZero a dump .text HexText riscv1.asm
```

## Compilando os códigos C (exemplo)

```
# Exemplo de compilação para um teste específico
cc Arquivos/sortc.c -O2 -o bin_sortc
./bin_sortc
```

Você pode compilar os arquivos de teste:
```
cc Arquivos/teste0.c -O2 -o teste0
./teste0
```
(Ajuste conforme a dependência entre arquivos, se algum teste incluir cabeçalhos ou outras units.)

## Próximos Passos Sugeridos
- Adicionar Makefile automatizando build e execução de testes.
- Criar scripts para comparar saída de `sort.s` vs `sortc.c`.
- Escrever comentários detalhando registradores usados nas rotinas assembly.

## Licença
Defina uma licença (ex: MIT) conforme sua preferência.

---
Mantido por Gabriel. Contributions bem-vindas.
