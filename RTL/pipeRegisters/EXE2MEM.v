`include "defines.v"

module EXE2MEM (
  input clk, rst,
  input regwrite_exe, memtoreg_exe, memwrite_exe,
  input [`WIDTH-1:0] aluout_exe, writedata_exe,
  input [4:0] regaddr_exe,

  output reg regwrite_mem, memtoreg_mem, memwrite_mem,
  output reg [`WIDTH-1:0] aluout_mem, writedata_mem,
  output reg [4:0] regaddr_mem
);

always @(posedge clk) begin
  if(!rst) begin
    {regwrite_mem, memtoreg_mem, memwrite_mem} <= 0; // Reset the pipeline stage
    {aluout_mem, writedata_mem} <= 0; // Reset the pipeline stage
    regaddr_mem <= 0; // Reset the pipeline stage
  end
  else begin
    {regwrite_mem, memtoreg_mem, memwrite_mem} <= {regwrite_exe, memtoreg_exe, memwrite_exe}; // Pass control signals to the next stage
    {aluout_mem, writedata_mem} <= {aluout_exe, writedata_exe}; // Pass data to the next stage
    regaddr_mem <= regaddr_exe; // Pass register address to the next stage
  end
end

endmodule