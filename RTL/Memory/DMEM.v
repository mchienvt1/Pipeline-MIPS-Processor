`include "defines.v"

module DMEM (
  input clk,
  input memwrite,
  input [`WIDTH-1:0] addr,
  input [`WIDTH-1:0] writedata,
  output [`WIDTH-1:0] readdata
);

  reg [`WIDTH-1:0] mem [32:0]; // Memory array

  always @(posedge clk) begin
    if (memwrite) begin
      mem[addr[`WIDTH-1:2]] <= writedata; // Write data to memory
    end
  end

  assign readdata = mem[addr[`WIDTH-1:2]]; // Read data from memory

endmodule