`include "defines.v"

module MEM2WB (
  input clk, rst,
  input regwrite_mem, memtoreg_mem,
  input [`WIDTH-1:0] readdata_mem, aluout_mem,
  input [4:0] regaddr_mem,

  output reg regwrite_wb, memtoreg_wb,
  output reg [`WIDTH-1:0] readdata_wb, aluout_wb,
  output reg [4:0] regaddr_wb
);

  always @(posedge clk) begin
    if(!rst) begin
      {regwrite_wb, memtoreg_wb} <= 0; // Reset the pipeline stage
      {readdata_wb, aluout_wb} <= 0; // Reset the pipeline stage
      regaddr_wb <= 0; // Reset the pipeline stage
    end
    else begin
      {regwrite_wb, memtoreg_wb} <= {regwrite_mem, memtoreg_mem}; // Pass control signals to the next stage
      {readdata_wb, aluout_wb} <= {readdata_mem, aluout_mem}; // Pass data to the next stage
      regaddr_wb <= regaddr_mem; // Pass register address to the next stage
    end
  end



endmodule