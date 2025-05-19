`include "defines.v"

module IDStage(
  input clk, rst,
  input [`WIDTH-1:0] instr_decode, pc_decode, result_wb,
  input [4:0] regaddr_wb,
  input forwardA_decode, forwardB_decode,stall_compare,
  input regwrite_wb,
  input [`WIDTH-1:0] aluout_mem,

  output regwrite_decode, memtoreg_decode, memwrite_decode, alusrc_decode, regdst_decode, branch_decode, jump_decode,
  output [`WIDTH-1:0] data1_decode, data2_decode, signext_decode,
  output [`WIDTH-1:0] pc_branch, pc_jump,
  output [3:0] alucontrol_decode,
  output flush_decode, pcsrc_decode
);

wire [`WIDTH-1:0] data_in1, data_in2;
wire branch_taken;
wire [1:0] branch_condition;

assign flush_decode = pcsrc_decode | jump_decode; // Flush the pipeline if a branch or jump is taken
assign pcsrc_decode = branch_taken & branch_decode; // Determine if the branch is taken


control c(instr_decode, instr_decode[31:26], instr_decode[5:0], memwrite_decode, regwrite_decode, memtoreg_decode, regdst_decode, alusrc_decode, branch_decode, jump_decode, branch_condition, alucontrol_decode);

condition_check compare(data_in1, data_in2, stall_compare, branch_condition, branch_taken); // Check if the branch is taken

REG registerfile(clk, rst, regwrite_wb, instr_decode[25:21], instr_decode[20:16], regaddr_wb, result_wb, data1_decode, data2_decode);

mux2to1 mux_data1(data1_decode, aluout_mem, forwardA_decode, data_in1); // Forwarding for data1
mux2to1 mux_data2(data2_decode, aluout_mem, forwardB_decode, data_in2); // Forwarding for data2

assign signext_decode = {{16{instr_decode[15]}}, instr_decode[15:0]}; // Sign extend the immediate value
adder adder_branch(pc_decode, {signext_decode[`WIDTH-3:0],2'b0}, pc_branch); // Calculate the branch address

assign pc_jump = {pc_decode[`WIDTH-1:28], instr_decode[25:0], 2'b00}; // Calculate the jump address

endmodule