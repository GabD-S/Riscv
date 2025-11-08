

 `ifndef PARAM
	`include "Parametros.v"
`endif

module Control(
	input        [6:0] iOpcode,
	output logic       oALUSrc,
	output logic       oMemToReg,
	output logic       oRegWrite,
	output logic       oMemRead,
	output logic       oMemWrite,
	output logic       oBranch,
    
	output logic       oJump,
	output logic       oPcToReg,
	output logic       oBranchRs1,
    
	// novo sinal: seleciona escrever imediato U-type (lui) diretamente no writeback
	output logic       oSelImmU,

	output logic [1:0] oALUOp
);

//Isso e basicamente um match case enorme seguindo os slides. ele ve o tipo de instruçao
//e determina a saida com base nisso.

//Todo: add jal
//Add: pc to reg, branchrs1, jump (pra ser incondicional
always @ (*)
	case (iOpcode[6:0])
		OPC_RTYPE:
			begin
			oALUSrc   <= 1'b0;
			oMemToReg <= 1'b0;
			oRegWrite <= 1'b1;
			oSelImmU  <= 1'b0;
			oMemRead   <= 1'b0;
			oMemWrite  <= 1'b0;
			oBranch    <= 1'b0;
			oJump      <= 1'b0;
			oPcToReg   <= 1'b0;
			oBranchRs1 <= 1'b0;
			oALUOp     <= 2'b10;
			end
		//Esse caso e o addi. Posso ter errado.
		7'b0010011:
			begin
			oALUSrc    <= 1'b1;
			oMemToReg  <= 1'b0;
			oRegWrite  <= 1'b1;
			oSelImmU   <= 1'b0;
			oMemRead   <= 1'b0;
			oMemWrite  <= 1'b0;
			oBranch    <= 1'b0;
			oJump      <= 1'b0;
			oPcToReg   <= 1'b0;
			oBranchRs1 <= 1'b0;
			oALUOp     <= 2'b10;
			end
		OPC_LOAD:
			begin
			oALUSrc    <= 1'b1;
			oMemToReg  <= 1'b1;
			oRegWrite  <= 1'b1;
			oSelImmU   <= 1'b0;
			oMemRead   <= 1'b1;
			oMemWrite  <= 1'b0;
			oBranch    <= 1'b0;
			oJump      <= 1'b0;
			oPcToReg   <= 1'b0;
			oBranchRs1 <= 1'b0;
			oALUOp     <= 2'b00;
			end
		OPC_STORE:
			begin
			oALUSrc    <= 1'b1;
			oMemToReg  <= 1'b0;
			oRegWrite  <= 1'b0;
			oSelImmU   <= 1'b0;
			oMemRead   <= 1'b0;
			oMemWrite  <= 1'b1;
			oBranch    <= 1'b0;
			oJump      <= 1'b0;
			oPcToReg   <= 1'b0;
			oBranchRs1 <= 1'b0;
			oALUOp     <= 2'b00;
			end
		OPC_BRANCH:
			begin
			oALUSrc   <= 1'b0;
			oMemToReg <= 1'b0;
			oRegWrite <= 1'b0;
			oSelImmU  <= 1'b0;
			oMemRead  <= 1'b0;
			oMemWrite <= 1'b0;
			oBranch   <= 1'b1;
			oJump     <= 1'b0;
			oPcToReg  <= 1'b0;
			oBranchRs1<= 1'b0;
			oALUOp    <= 2'b01;
			end
			OPC_LUI:
				begin
				oALUSrc    <= 1'b1; // imediato será usado como dado de writeback; U-type não precisa ALU
				oMemToReg  <= 1'b0;
				oRegWrite  <= 1'b1;
				oSelImmU   <= 1'b1;
				oMemRead   <= 1'b0;
				oMemWrite  <= 1'b0;
				oBranch    <= 1'b0;
				oJump      <= 1'b0;
				oPcToReg   <= 1'b0;
				oBranchRs1 <= 1'b0;
				oALUOp     <= 2'b00;
				end
		7'b1100111: //jalr
			begin
			oALUSrc    <= 1'b1;
			oMemToReg  <= 1'b0;
			oRegWrite  <= 1'b1;
			oSelImmU   <= 1'b0;
			oMemRead   <= 1'b0;
			oMemWrite  <= 1'b0;
			oBranch    <= 1'b0;
			oJump      <= 1'b1;
			oPcToReg   <= 1'b1;
			oBranchRs1 <= 1'b1;
			oALUOp     <= 2'b00;
			end
		7'b1101111: //jal
			begin
			oALUSrc    <= 1'b1;
			oMemToReg  <= 1'b0;
			oRegWrite  <= 1'b1;
			oSelImmU   <= 1'b0;
			oMemRead   <= 1'b0;
			oMemWrite  <= 1'b0;
			oBranch    <= 1'b0;
			oJump      <= 1'b1;
			oPcToReg   <= 1'b1;
			oBranchRs1 <= 1'b0;
			oALUOp     <= 2'b00;
			end
		default:
			begin
			oALUSrc   <= 1'b0;
			oMemToReg <= 1'b0;
			oRegWrite <= 1'b0;
			oSelImmU  <= 1'b0;
			oMemRead  <= 1'b0;
			oMemWrite <= 1'b0;
			oBranch   <= 1'b0;
			oJump     <= 1'b0;
			oPcToReg  <= 1'b0;
			oBranchRs1<= 1'b0;
			oALUOp    <= 2'b00;
			end
	endcase
endmodule
