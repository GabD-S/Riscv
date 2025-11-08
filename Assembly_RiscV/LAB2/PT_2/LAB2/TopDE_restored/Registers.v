`ifndef PARAM
	`include "Parametros.v"
`endif

module Registers (
    input wire 			iCLK, iRST, iRegWrite,
    input wire  [4:0] 	iReadRegister1, iReadRegister2, iWriteRegister,
    input wire  [31:0] 	iWriteData,
    output wire [31:0] 	oReadData1, oReadData2,

    input wire  [4:0] 	iRegDispSelect,
    output reg  [31:0] 	oRegDisp
    );

/* Register file */
reg [31:0] registers[31:0];

parameter  SPR=5'd2, GPR=5'd3;                    // SP e GP

reg [5:0] i;

initial
	begin
		for (i = 0; i <= 31; i = i + 1'b1)
			registers[i] = 32'd0;
		registers[SPR] <= STACK_ADDRESS;
		registers[GPR] <= DATA_ADDRESS;
	end


assign oReadData1 =	registers[iReadRegister1];
assign oReadData2 =	registers[iReadRegister2];

assign oRegDisp 	=	registers[iRegDispSelect];


always @(posedge iCLK or posedge iRST)
begin
    if (iRST)
    begin // reseta o banco de registradores e pilha
        for (i = 0; i <= 31; i = i + 1'b1)
            registers[i] = 32'b0;
		  registers[SPR] <= STACK_ADDRESS; 
		  registers[GPR] <= DATA_ADDRESS;
    end
    else
	 begin
		i<=6'b0; // para não dar warning
		if(iRegWrite && (iWriteRegister != 5'b0))
				registers[iWriteRegister] <= iWriteData;
	 end
end

endmodule
