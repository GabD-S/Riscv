// tb_mini_cpu.v - testbench for mini_cpu + regfile_3read
`timescale 1ns/1ps
module tb_mini_cpu;
    reg clk = 0;
    always #5 clk = ~clk;

    // instantiate mini_cpu
    wire done;
    wire [31:0] result_out;

    mini_cpu uut (
        .clk(clk),
        .done(done),
        .result_out(result_out)
    );

    initial begin
        $display("Starting testbench...");
        // prepare: write the TRI instruction into imem[0]
        // encode opcode 0xAA, rd=4, rs1=1, rs2=2, rs3=3 -> 0xAA204430
        uut.imem[0] = 32'hAA204430;
        // ensure regfile initial regs are already set (regfile initial block sets r1=5,r2=7,r3=11)
        // run for a few cycles
        #20; // wait
        // wait until done
        wait(done == 1);
        #1;
        $display("Result_out = %0d (0x%08x)", result_out, result_out);
        if (result_out !== (32'd5 + 32'd7 + 32'd11)) begin
            $display("TEST FAILED: unexpected sum");
            $finish;
        end else begin
            $display("TEST PASSED: triple-read sum = %0d", result_out);
        end
        $finish;
    end
endmodule
