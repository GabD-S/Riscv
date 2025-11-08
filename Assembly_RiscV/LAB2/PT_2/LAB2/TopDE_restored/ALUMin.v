
 `ifndef PARAM
	`include "Parametros.v"
`endif

//`define RV32I;
`define RV32IM;
 
module ALUMin (
	input 		 [4:0]  iControl,
	input signed [31:0] iA, 
	input signed [31:0] iB,
	output logic [31:0] oResult,
	output logic        oZero
	);

//	wire [4:0] iControl=OPDIV;		// Usado para as analises

assign zero = (iA == iB);

always @(*)
begin
    case (iControl)
		OPAND:
			oResult  <= iA & iB;
		OPOR:
			oResult  <= iA | iB;
		OPADD:
			oResult  <= iA + iB;
		OPSUB:
			oResult  <= iA - iB;
		OPSLT:
			oResult  <= iA < iB;
		OPNULL:
			oResult  <= ZERO;
			
		default:
			oResult  <= ZERO;
    endcase
end

endmodule
