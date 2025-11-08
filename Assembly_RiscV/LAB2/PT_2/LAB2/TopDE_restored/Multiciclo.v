`ifndef PARAM
	`include "Parametros.v"
`endif

module Multiciclo (
	input logic clockCPU, clockMem,
	input logic reset,
	output logic [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0] regin,
	output logic [31:0] regout,
	output logic [3:0] estado
	);
	
	reg [31:0] PCBack;
	
	initial
		begin
			PC<=32'h0040_0000;
			PCBack<=32'h0040_0000;
			Instr<=32'b0;
			regout<=32'b0;
		end
		
		wire [31:0] SaidaULA, Leitura2,B;
		wire EscreveMem;
		
		wire [3:0] proximo;
		
//******************************************
// Aqui vai o seu código do seu processador

always @(posedge clockCPU or posedge reset)
	if(reset)
		begin
			PC <= 32'h0040_0000;
			PCBack <= 32'h0040_0000;
			estado <= 4'b0000;
		end
	else
			estado <= proximo;

		
wire [31:0] wIouD, MemData, rmem;
		
		
assign EscreveMem = 1'b0;
 

ramI MemC (.address(wIouD[11:2]), .clock(clockMem), .data(B), .wren(EscreveMem & ~wIouD[28]), .q(Instr));
ramD MemD (.address(wIouD[11:2]), .clock(clockMem), .data(B), .wren(EscreveMem & wIouD[28]), .q(MemData));

assign rmem = wIouD[28]? MemData : Instr;

	
//*****************************************
	
			
endmodule
