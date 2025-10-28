// imm_gen.v
module immgen (
    input  logic [31:0] iinstrucao,
    output logic [31:0] oimm
);

    localparam logic [31:0] sp_init = 32'h1001_03fc;

    localparam [6:0] opc_load   = 7'b0000011; // 0x03
    localparam [6:0] opc_opimm  = 7'b0010011; // 0x13
    localparam [6:0] opc_jalr   = 7'b1100111; // 0x67
    localparam [6:0] opc_store  = 7'b0100011; // 0x23
    localparam [6:0] opc_branch = 7'b1100011; // 0x63
    localparam [6:0] opc_jal    = 7'b1101111; // 0x6f
    localparam [6:0] opc_lui    = 7'b0110111; // 0x37

    always @(*) begin
        unique case (iinstrucao[6:0])
            opc_load,
            opc_opimm,
            opc_jalr: begin
                oimm <= {{20{iinstrucao[31]}}, iinstrucao[31:20]}; // i-type
            end

            opc_store: begin
                oimm <= {{20{iinstrucao[31]}}, iinstrucao[31:25], iinstrucao[11:7]}; // s-type
            end

            opc_branch: begin
                oimm <= {{19{iinstrucao[31]}}, iinstrucao[31], iinstrucao[7], iinstrucao[30:25], iinstrucao[11:8], 1'b0}; // b-type
            end

            opc_jal: begin
                oimm <= {{11{iinstrucao[31]}}, iinstrucao[31], iinstrucao[19:12], iinstrucao[20], iinstrucao[30:21], 1'b0}; // j-type
            end

            opc_lui: begin
                oimm <= {iinstrucao[31:12], 12'b0}; // u-type (lui)
            end

            default: begin
                oimm <= 32'd0;
            end
        endcase
    end

endmodule
