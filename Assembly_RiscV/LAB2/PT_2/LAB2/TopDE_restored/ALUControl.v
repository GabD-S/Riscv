 `ifndef PARAM
	`include "Parametros.v"
`endif

module ALUControl(
	input        [1:0] iALUOp,
	input              iInstr30,
	input        [2:0] iFunct3,
	output logic [4:0] oALUControl
);


//O case maior verifica o ALUOp recebido do bloco de controle.
//O case menor verifica o funct3
//O operador ternario do primeiro caso do funct3 verifica o bit 30 da instruçao
// (que tambem e o penultimo do funct7!)
always @ (*)
	case (iALUOp[1:0])
		2'b00:
			oALUControl <= OPADD;
		2'b01:
			oALUControl <= OPSUB;
		2'b10:
			case (iFunct3[2:0])
				3'b000:
					oALUControl <= iInstr30 ? OPSUB : OPADD;
				3'b111:
					oALUControl <= OPAND;
				3'b110:
					oALUControl <= OPOR;
				3'b010:
					oALUControl <= OPSLT;
				default:
					oALUControl <= 5'b0;
			endcase
		default:
			oALUControl <= 5'b0;
	endcase

endmodule
		
	