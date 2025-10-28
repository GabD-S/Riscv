// regfile_3read.v
// 32 x 32-bit registers
// 1 write port (synchronous), 3 read ports (combinational)

module regfile_3read(
    input wire clk,
    input wire we,
    input wire [4:0] waddr,
    input wire [31:0] wdata,
    input wire [4:0] raddr0,
    input wire [4:0] raddr1,
    input wire [4:0] raddr2,
    output wire [31:0] rdata0,
    output wire [31:0] rdata1,
    output wire [31:0] rdata2
);

    reg [31:0] regs [0:31];
    integer i;

    // Initialize registers for test: r1=5, r2=7, r3=11 (example)
    initial begin
        for (i=0; i<32; i=i+1) regs[i] = 32'h0;
        regs[1] = 32'd5;
        regs[2] = 32'd7;
        regs[3] = 32'd11;
    end

    // write port (synchronous)
    always @(posedge clk) begin
        if (we && waddr != 5'd0) begin
            regs[waddr] <= wdata;
        end
    end

    // read ports (combinational)
    assign rdata0 = regs[raddr0];
    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];

endmodule
