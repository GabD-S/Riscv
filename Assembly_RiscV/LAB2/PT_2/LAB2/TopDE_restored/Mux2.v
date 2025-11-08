module Mux2 (
	input 		        iChoice,
	input signed [31:0] iA, 
	input signed [31:0] iB,
	output logic [31:0] oResult
);

assign oResult = iChoice? iB: iA;
//Operador ternario. sem segredo.

endmodule