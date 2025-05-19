`include "defines.v"

module top(
  input clk,rst
);

  wire [`WIDTH-1:0] pc_fetch, instr_fetch, pc_decode, instr_decode, pc_branch, pc_jump;
  wire [`WIDTH-1:0] data1_decode, data2_decode, signext_decode, pc_in;
  wire [`WIDTH-1:0] aluout_exe, writedata_exe, aluout_mem, writedata_mem, readdata_mem;
  wire [`WIDTH-1:0] result_wb, readdata_wb, aluout_wb;
  wire [`WIDTH-1:0] pc_out_0;

  wire [4:0] Rs_exe, Rt_exe, Rd_exe;
  wire [4:0] regaddr_exe, regaddr_mem, regaddr_wb;

  wire stall_pc, stall_decode, stall_compare;
  wire flush_decode, flush_exe;

  wire jump_decode, pcsrc_decode;
  wire regwrite_exe, memtoreg_exe, memwrite_exe;
  wire regwrite_mem, memtoreg_mem;
  wire regwrite_wb, memtoreg_wb;

  wire alusrc_decode, regdst_decode;
  wire branch_decode;
  wire forwardA_decode, forwardB_decode;
  wire [1:0] forwardA_exe, forwardB_exe;

  wire [`WIDTH-1:0] data1_exe, data2_exe, signext_exe;
  wire [4:0] shamt_exe;

  wire regwrite_decode, memtoreg_decode, memwrite_decode;
  wire alusrc_exe, regdst_exe;
  wire [3:0] alucontrol_exe, alucontrol_decode;

// IF STAGE
  IFStage ifstage(clk, rst, jump_decode, pcsrc_decode, stall_pc, pc_branch, pc_jump, pc_fetch, instr_fetch);
  IF2ID if2id(clk, rst, stall_decode, flush_decode, instr_fetch, pc_fetch, instr_decode, pc_decode);

// ID STAGE

  IDStage idstage(clk, rst, instr_decode, pc_decode, result_wb, regaddr_wb, forwardA_decode, forwardB_decode, stall_compare, regwrite_wb, aluout_mem, regwrite_decode, memtoreg_decode, memwrite_decode, alusrc_decode, regdst_decode, branch_decode, jump_decode, data1_decode, data2_decode, signext_decode, pc_branch, pc_jump, alucontrol_decode, flush_decode, pcsrc_decode);

  ID2EXE id2exe(clk, rst, flush_exe, regwrite_decode, memtoreg_decode, memwrite_decode, alusrc_decode, regdst_decode, alucontrol_decode, instr_decode[25:21], instr_decode[20:16], instr_decode[15:11], data1_decode, data2_decode, signext_decode, instr_decode[10:6], regwrite_exe, memtoreg_exe, memwrite_exe, alusrc_exe, regdst_exe, alucontrol_exe, Rs_exe, Rt_exe, Rd_exe, data1_exe, data2_exe, signext_exe, shamt_exe);

// EX STAGE

  EXEStage exestage(clk, rst, regwrite_exe, memtoreg_exe, memwrite_exe, alusrc_exe, regdst_exe, alucontrol_exe, Rs_exe, Rt_exe, Rd_exe, shamt_exe, data1_exe, data2_exe, signext_exe, result_wb, aluout_mem, forwardA_exe, forwardB_exe, regaddr_exe, aluout_exe, writedata_exe);

  EXE2MEM exe2mem(clk, rst, regwrite_exe, memtoreg_exe, memwrite_exe, aluout_exe, writedata_exe, regaddr_exe, regwrite_mem, memtoreg_mem, memwrite_mem, aluout_mem, writedata_mem, regaddr_mem);

// MEM STAGE

  MEMStage memstage(clk, memwrite_mem, aluout_mem, writedata_mem, readdata_mem);

  MEM2WB mem2wb(clk, rst, regwrite_mem, memtoreg_mem, readdata_mem, aluout_mem, regaddr_mem, regwrite_wb, memtoreg_wb, readdata_wb, aluout_wb, regaddr_wb);

// WB STAGE

  WBStage wbstage(memtoreg_wb, readdata_wb, aluout_wb, result_wb);

// Hazard Unit

  hazardUnit hazardunit (branch_decode, instr_decode[25:21], instr_decode[20:16], Rs_exe, Rt_exe, regaddr_wb, regaddr_mem, regaddr_exe, regwrite_wb, regwrite_mem, memtoreg_exe, memtoreg_mem, regwrite_exe,flush_exe, stall_pc, stall_decode, stall_compare, forwardA_decode, forwardB_decode, forwardA_exe, forwardB_exe);


endmodule