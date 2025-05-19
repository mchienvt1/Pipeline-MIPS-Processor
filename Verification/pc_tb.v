`timescale 1ns/1ps

module pc_tb;

  reg clk, rst, stall_pc;
  reg [31:0] pc_in;
  wire [31:0] pc_out;

  // Instantiate the PC module
  pc dut (
    .clk(clk),
    .rst(rst),
    .stall_pc(stall_pc),
    .pc_in(pc_in),
    .pc_out(pc_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period
  end

  // Print values to console at every positive clock edge
  always @(posedge clk) begin
    $display("Time %0t ns: pc_in = %h, pc_out = %h, stall_pc = %b, rst = %b", $time, pc_in, pc_out, stall_pc, rst);
  end

  // Stimulus
  initial begin
    // Dump waveform
    $dumpfile("pc.vcd");
    $dumpvars(0, pc_tb);

    // Initialize signals
    rst = 1;
    stall_pc = 0;
    pc_in = 0;

    // Apply reset
    #3 rst = 0;
    #10 rst = 1;

    // Test 1: Normal increment
    #10 pc_in = 32'h00000004;
    #10 pc_in = 32'h00000008;
    #10 pc_in = 32'h0000000C;

    // Test 2: Stall the PC
    stall_pc = 1;
    pc_in = 32'h00000010;
    #10; // PC should not change
    #10;

    // Remove stall
    stall_pc = 0;
    pc_in = 32'h00000014;
    #10;
    
    #20;

    // Finish simulation
    $finish;
  end

endmodule