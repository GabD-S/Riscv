`ifndef PARAM
	`include "Parametros.v"
`endif

module TopDE (
	input logic CLOCK, Reset,
	input logic [4:0] Regin,
	output logic ClockDIV, ClockDIV4,
	output logic [31:0] PC,Instr,Regout,
	output logic [3:0] Estado
	);
	
		
	initial
		begin
		ClockDIV <= 1'b1;
		ClockDIV4 <= 1'b1;
		end

	always @(posedge CLOCK) 
		begin 		
				ClockDIV <= ~ClockDIV;  //clockDIV metade da frequência do Clock
		end
	always @(posedge ClockDIV)
		begin
				ClockDIV4 <= ~ClockDIV4;
		end
	

	
	Uniciclo UNI1 (.clockCPU(ClockDIV4), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout)); 

					
/*	Multiciclo MULT1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout), .estado(Estado);	*/
						
/* Pipeline PIP1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout)); */
		
	
endmodule
