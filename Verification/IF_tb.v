`timescale 1ns/1ps
`include "defines.v"

module IF_tb;

  // Inputs
  reg clk, rst;
  reg jump_decode, pcsrc_decode, stall_pc;
  reg [`WIDTH-1:0] pc_branch, pc_jump;

  // Outputs
  wire [`WIDTH-1:0] pc_fetch, instr_fetch;

  // Instantiate the IFStage module
  IFStage dut (
    .clk(clk),
    .rst(rst),
    .jump_decode(jump_decode),
    .pcsrc_decode(pcsrc_decode),
    .stall_pc(stall_pc),
    .pc_branch(pc_branch),
    .pc_jump(pc_jump),
    .pc_fetch(pc_fetch),
    .instr_fetch(instr_fetch)
  );

  // Clock generation: 10ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Monitor output
  always @(posedge clk) begin
    $display("Time %0t: pc_fetch = %h, instr_fetch = %h, jump = %b, branch = %b, stall = %b", 
              $time, pc_fetch, instr_fetch, jump_decode, pcsrc_decode, stall_pc);
  end

  // Stimulus
  initial begin
    $dumpfile("IF.vcd");
    $dumpvars(0, IF_tb);

    // Initial values
    rst = 1;
    jump_decode = 0;
    pcsrc_decode = 0;
    stall_pc = 0;
    pc_branch = 32'h00000000;
    pc_jump = 32'h00000000;

    // Apply reset
    #3 rst = 0;     // Reset active
    #10 rst = 1;    // Reset de-asserted

    // Normal PC increment
    #10;
    #10;

    // Stall PC
    stall_pc = 1;
    #10;
    stall_pc = 0;

    // Branch
    pcsrc_decode = 1;
    pc_branch = 32'h00000020;
    #10;
    pcsrc_decode = 0;

    // Jump
    jump_decode = 1;
    pc_jump = 32'h00000080;
    #10;
    jump_decode = 0;

    // End simulation
    #20;
    $finish;
  end

endmodule
