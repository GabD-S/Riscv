`timescale 1ns/1ps
`include "TopDE_restored/Parametros.v"

module tb_lui;
    reg [31:0] instr;
    wire [31:0] imm;

    // Instantiate ImmGen
    ImmGen uut_imm (.iInstrucao(instr), .oImm(imm));

    // Instantiate Registers
    reg clk = 0;
    reg rst = 1;
    reg regwrite = 0;
    reg [4:0] read1 = 1, read2 = 2, write = 5'd1, regdisp = 5'd1;
    reg [31:0] write_data = 32'd0;
    wire [31:0] outdisp, r1, r2;

    Registers rf (.iCLK(clk), .iRST(rst), .iRegWrite(regwrite),
                  .iReadRegister1(read1), .iReadRegister2(read2),
                  .iWriteRegister(write), .iWriteData(write_data),
                  .iRegDispSelect(regdisp), .oRegDisp(outdisp),
                  .oReadData1(r1), .oReadData2(r2));

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        $display("Starting LUI testbench...");
        // release reset
        #2; rst = 1; #10; rst = 0;

        // Prepare a LUI instruction: opcode 7'b0110111, rd = x1 (bits 11:7)
        // imm[31:12] = 0x00012 -> full instruction = imm[31:12]<<12 | rd<<7 | opcode
        instr = (32'h00012 << 12) | (5'd1 << 7) | 7'b0110111;
        #2;
        $display("Instr=%08h, ImmGen output=%08h", instr, imm);

        // Write the immediate to register x1 via writeback
        write_data = imm;
        regwrite = 1;
        #10; // wait for posedge clock
        regwrite = 0;
        #10;

        $display("Register x1 (r1) = %08h, expected = %08h", r1, imm);
        if (r1 === imm) begin
            $display("TEST PASSED: LUI immediate written to x1 correctly.");
        end else begin
            $display("TEST FAILED: mismatch.");
        end
        $finish;
    end

endmodule
