`ifndef PARAM
	`include "Parametros.v"
`endif

module Pipeline (
	input logic clockCPU, clockMem,
	input logic reset,
	output logic [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0] regin,
	output logic [31:0] regout,
	output logic [3:0] estado
	);
	
	reg [31:0] IF_ID, ID_EX, EX_MEM, MEM_WB;
	
	initial
		begin
			PC<=32'h0040_0000;
			Instr<=32'b0;
			regout<=32'b0;
		end
		

		
//******************************************
// Aqui vai o seu código do seu processador
		wire [31:0] SaidaULA, Leitura2,B;
		wire EscreveMem;


always @(posedge clockCPU  or posedge reset)
	if(reset)
		begin
			PC <= 32'h0040_0000;
		end
	else
		PC <= PC+4;
		
wire [31:0] wIouD, MemData;
		
		
assign EscreveMem = 1'b0;
 

ramI MemC (.address(PC[11:2]), .clock(clockMem), .data(), .wren(1'b0), .q(Instr));
ramD MemD (.address(SaidaULA[11:2]), .clock(clockMem), .data(B), .wren(EscreveMem), .q(MemData));


	
//*****************************************
	
			
endmodule
