`ifndef PARAM
	`include "Parametros.v"
`endif

module Uniciclo (
	input logic clockCPU, clockMem,
	input logic reset,
	output reg [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0] regin,
	output logic [31:0] regout
	);
    
    
	initial
		begin
			PC<=TEXT_ADDRESS;
			Instr<=32'b0;
			regout<=32'b0;
		end
        
		wire [31:0] SaidaULA, Leitura2, MemData;
		//wire EscreveMem, LeMem;
        
//******************************************
// Aqui vai o seu código do seu processador

	//Declaraçao dos fios de output em cima da declaraçao das unidades.
	//Uma descriçao da unidade em baixo. 
	//Veja o dapath do slide 14 dos slides de controle do uniciclo do lamar por referencia.
	//Classe do bloco em ingles e começando com maiusculo, instancias em
	//camel case e em portugues.

	//LeMem e EscreveMem ja instanciados.
	wire ALUSrc, MemToReg, RegWrite, Branch, Jump, PcToReg, BranchRs1;
	wire [1:0] ALUOp;
	wire selImmU;
	Control controle (.iOpcode(Instr[6:0]),
							.oALUSrc(ALUSrc),
							.oMemToReg(MemToReg),
							.oRegWrite(RegWrite),
							.oMemRead(LeMem),
							.oMemWrite(EscreveMem),
							.oBranch(Branch),
							.oJump(Jump),
							.oPcToReg(PcToReg),
							.oBranchRs1(BranchRs1),
							.oSelImmU(selImmU),
							.oALUOp(ALUOp));
	//Unidade de controle
    
    
	wire [3:0] ALUControl;
	ALUControl controleULA(.iALUOp(ALUOp),
								  .iInstr30(Instr[30]),
								  .iFunct3(Instr[14:12]),
								  .oALUControl(ALUControl));
	//O controle da ULA.
    
    
    
	wire [31:0] RegisterRead1, RegisterRead2;
	Registers registradores (.iCLK(clockMem),
									 .iRST(reset),
									 .iRegWrite(RegWrite), 
									 .iReadRegister1(Instr[19:15]), 
									 .iReadRegister2(Instr[24:20]), 
									 .iWriteRegister(Instr[11:7]), 
									 .iWriteData(regWriteData), 
									 .iRegDispSelect(regin),
									 .oRegDisp(regout),
									 .oReadData1(RegisterRead1), 
									 .oReadData2(RegisterRead2));
	//Banco de registradores.
	//RegDispSelect sao 5 bits que selecionam o registrador.
	//RegDisp sao 32 bits que mostram o valor do registrador
    
    
	wire [31:0] imediatoGerado;
	ImmGen geradorDeImediato(.iInstrucao(Instr[31:0]),
							 .oImm(imediatoGerado));
	//Gerador de imediatos.
    
    
	wire [31:0] inputBALU;
	Mux2 muxALURegistrador(.iChoice(ALUSrc),
								  .iA(RegisterRead2),
								  .iB(imediatoGerado),
								  .oResult(inputBALU));
	//O mux da alu que vai fazer as operaçoes principais.
	//Nos slides esta bem entre o banco de regs e a ALU.
    
    
	wire [31:0] muxRegWriteA;
	Mux2 muxRegWrite(.iChoice(MemToReg),
						  .iA(SaidaULA),
						  .iB(MemData),
						  .oResult(muxRegWriteA));
	//O mux que escolhe o que vai ser armazenado nos registradores.
    
	// Seleção do dado de writeback: permite escrever imediato U-type (lui)
	wire [31:0] muxRegWriteB;
	Mux2 muxRegLui(.iChoice(selImmU),
			  .iA(muxRegWriteA),
			  .iB(imediatoGerado),
			  .oResult(muxRegWriteB));

	wire [31:0] regWriteData;
	Mux2 muxRegJal(.iChoice(PcToReg),
					.iA(muxRegWriteB),
					.iB(PC),
					.oResult(regWriteData));
	//Mux que decide entre o de cima ou escrever PC (em casos de jalr ou jal)
    
    
	//A saida vai para SaidaULA
	wire zero;
	ALUMin aluPrincipal(.iControl(ALUControl),
							  .iA(RegisterRead1),
							  .iB(inputBALU),
							  .oResult(SaidaULA),
							  .oZero(zero));
	//A ULA principal.
    
    
    
    

always @(posedge clockCPU  or posedge reset)
	if(reset)
		PC <= TEXT_ADDRESS;
	else
		PC <= ((Branch && zero)||Jump)? ((BranchRs1? RegisterRead1: PC)+ imediatoGerado) : PC+4'd4;
        
		//Aqui verifica os dois tipos de branch, o beq ou o jal/jalr
		//Ele vai dar branch se for branch e o registrador 1 == registrador 2 OU se for uma operaçao de branch
		//Caso a prox instruçao nao seja pc+4, vai depender de branchrs1
		//Se branchrs1 for verdadeiro, a proxima instruçao vai ser registrador 1 + imediato, se nao,
		//vai ser pc + imediato

//assign EscreveMem = 1'b0;
//assign LeMem = 1'b1;
//assign SaidaULA = 32'b0;


// Instanciação das memórias
ramI MemC (.address(PC[11:2]), .clock(clockMem), .data(), .wren(1'b0), .rden(1'b1), .q(Instr));
ramD MemD (.address(SaidaULA[11:2]), .clock(clockMem), .data(RegisterRead2), .wren(EscreveMem), .rden(LeMem),.q(MemData));


		
    
		
//*****************************************    
			
endmodule
