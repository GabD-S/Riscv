// mini_cpu.v
// Minimal CPU that recognizes a custom TRI instruction (opcode 0xAA in top byte)
// Encoding (32 bits): [31:24] opcode (0xAA)
//                      [23:19] rd (5)
//                      [18:14] rs1 (5)
//                      [13:9]  rs2 (5)
//                      [8:4]   rs3 (5)
//                      [3:0]   reserved

module mini_cpu(
    input wire clk,
    output reg done,
    output reg [31:0] result_out // result stored for TB observation
);

    // Instruction memory (small)
    reg [31:0] imem [0:15];
    reg [31:0] dmem [0:15];

    reg [7:0] opcode;
    reg [4:0] rd, rs1, rs2, rs3;
    reg [31:0] instr;
    integer pc;

    // Instantiate regfile
    wire [31:0] rdata0, rdata1, rdata2;
    regfile_3read rf(
        .clk(clk),
        .we(1'b0),
        .waddr(5'd0),
        .wdata(32'd0),
        .raddr0(rs1),
        .raddr1(rs2),
        .raddr2(rs3),
        .rdata0(rdata0),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // initialize instruction memory with a single TRI instruction at address 0
    initial begin
        // default zero
        imem[0] = 32'h00000000;
        imem[1] = 32'h00000000;
        imem[2] = 32'h00000000;
        imem[3] = 32'h00000000;

        // Example encoded instruction placed by default is left as zero; TB will write it via force or by reading a .mem
        // We'll allow TB to overwrite imem[0] with the desired TRI instruction via hierarchical reference if needed.

        // clear data memory
        dmem[0] = 32'd0;
        dmem[1] = 32'd0;

        pc = 0;
        done = 0;
        result_out = 32'd0;
    end

    // Simple fetch-decode-execute in one sequential always block
    always @(posedge clk) begin
        if (!done) begin
            instr = imem[pc];
            opcode = instr[31:24];
            rd = instr[23:19];
            rs1 = instr[18:14];
            rs2 = instr[13:9];
            rs3 = instr[8:4];

            if (opcode == 8'hAA) begin
                // read ports are combinational; rdataX updated immediately based on rsX
                // compute sum and store to dmem[0]
                dmem[0] = rdata0 + rdata1 + rdata2;
                result_out = dmem[0];
                done = 1'b1;
            end else begin
                // NOP / or advance
                pc = pc + 1;
            end
        end
    end

endmodule
