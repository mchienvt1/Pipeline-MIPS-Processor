`include "defines.v"

module IFStage(
  input clk,
  input rst,
  input jump_decode, pcsrc_decode, stall_pc,
  input [`WIDTH-1:0] pc_branch, pc_jump,
  output [`WIDTH-1:0] pc_fetch, instr_fetch
);

  wire [`WIDTH-1:0] pc_in;
  wire [`WIDTH-1:0] pc_out_0, pc_out;

  // Select MUX
  mux2to1 select_branch(pc_fetch, pc_branch, pcsrc_decode, pc_out_0);
  mux2to1 select_jump(pc_out_0, pc_jump, jump_decode, pc_in);

  // PC
  pc pc(clk, rst, stall_pc, pc_in, pc_out);

  // Adder
  adder adder(pc_out, `WIDTH'b100, pc_fetch);

  IMEM imem (pc_out, instr_fetch);
 


endmodule