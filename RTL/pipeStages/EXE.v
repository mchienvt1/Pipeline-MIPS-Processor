`include "defines.v"

module EXEStage (
  input clk, rst,
  input regwrite_exe, memtoreg_exe, memwrite_exe, alusrc_exe, regdst_exe,
  input [3:0] alucontrol_exe,
  input [4:0] Rs_exe, Rt_exe, Rd_exe, shamt_exe,
  input [`WIDTH-1:0] data1_exe, data2_exe, signext_exe,
  input [`WIDTH-1:0] result_wb,
  input [`WIDTH-1:0] aluout_mem,
  input [1:0] forwardA_exe, forwardB_exe,

  output [4:0] regaddr_exe,
  output [`WIDTH-1:0] aluout_exe, writedata_exe
);

wire [`WIDTH-1:0] val1, val2;

mux2to1 #(5) mux_regaddr(Rt_exe, Rd_exe, regdst_exe, regaddr_exe); // MUX for register address

mux4to1 mux_val1(data1_exe, result_wb, aluout_mem, 32'b0, forwardA_exe, val1); // MUX for ALU input 1
mux4to1 mux_writeData(data2_exe, result_wb, aluout_mem, 32'b0, forwardB_exe, writedata_exe); 
mux2to1 mux_val2(writedata_exe, signext_exe, alusrc_exe, val2); // MUX for ALU input 2

ALU alu(val1, val2, alucontrol_exe, shamt_exe, aluout_exe);

endmodule