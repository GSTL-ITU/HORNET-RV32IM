`timescale 1ns/1ps

module barebones_top_axi4l_tb();

reg         rst_ni, clk_i;
wire        irq_ack_o;
reg         meip_i;
reg [15:0]  fast_irq_i;
integer     i;

barebones_axi4l_top uut (
    .rst_ni    (rst_ni),
    .clk_i     (clk_i),
    .meip_i    (meip_i),
    .fast_irq_i(fast_irq_i),
    .irq_ack_o (irq_ack_o)
);

// 40 MHz clock (25 ns period)
// Change delays if you really want 100 MHz.
always begin
    clk_i = 1'b0; #12.5;
    clk_i = 1'b1; #12.5;
end

initial begin
    // Uncomment the program you want to simulate.
    // Remove "../../test/memory_contents/" if using Vivado.
    //
    // $readmemh("../../test/memory_contents/bubble_sort_irq.data", uut.memory.mem);
    // $readmemh("../../test/memory_contents/bubble_sort.data",     uut.memory.mem);
    // $readmemh("../../test/memory_contents/aes_test.data",        uut.memory.mem);
    // $readmemh("soft_float.data",                                 uut.memory.mem);

    rst_ni     = 1'b0;
    fast_irq_i = 16'b0;
    meip_i     = 1'b0;

//    for (i = 0; i < uut.memory.ADDR_W; i = i + 1) begin
//        uut.memory.mem[i] = {uut.memory.DATA_W{1'b0}};
//    end

    #200;
    // Read program after reset-side initialization
    // $readmemh("instruction.data", uut.memory.mem);

    #25;
    rst_ni = 1'b1; // Wait a cycle so instruction memory is ready

    #100000000;
    $finish;

    // Interrupt signals, arbitrarily generated. Uncomment if needed.
    /*
    #2100; meip_i = 1'b1;
    #400;  meip_i = 1'b1;
    #400;  meip_i = 1'b1;
    #400;  meip_i = 1'b1;
    #850;  meip_i = 1'b1;
    #316;  meip_i = 1'b1;
    #763;  meip_i = 1'b1;
    #152;  meip_i = 1'b1;
    #761;  meip_i = 1'b1;
    #252;  meip_i = 1'b1;
    */
end

always @(posedge clk_i) begin
    if (uut.core0.core0.CSR_UNIT.mcause == 32'h0000_000b) begin
        #100; // wait so instruction after ecall is executed
        $display("Simulation finished successfully!");
        $finish;
    end
end

// This always block imitates an interrupt controller.
// Uncomment if using machine external interrupt.
/*
always @(posedge clk_i) begin
    if (irq_ack_o)
        meip_i <= 1'b0;
end
*/

endmodule