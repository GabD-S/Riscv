# Makefile for tri_instr simulation
VFILES = regfile_3read.v mini_cpu.v tb_mini_cpu.v

all: sim

sim:
	iverilog -o sim.vvp $(VFILES)
	vvp sim.vvp

clean:
	rm -f sim.vvp *.vcd
