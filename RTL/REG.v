`include "defines.v"

module REG (
  input clk, rst,
  input regwrite,
  input [4:0] address1,
  input [4:0] address2,
  input [4:0] address_wb,
  input [`WIDTH-1:0] data_wb,
  output [`WIDTH-1:0] data1,
  output [`WIDTH-1:0] data2
);

reg [`WIDTH-1:0] REGISTER [31:0]; // Register file with 32 registers, each `WIDTH` bits wide

always @(negedge clk) begin
  if(!rst) begin
    for(integer i = 0; i < 32; i = i +1) begin
      REGISTER[i] <= 0; // Initialize all registers to 0
    end
  end
  else if (regwrite) begin
    REGISTER[address_wb] <= data_wb; // Write data to the register file
  end
end

assign data1 = (address1 != 0) ? REGISTER[address1] : 0; // Read data from register 1
assign data2 = (address2 != 0) ? REGISTER[address2] : 0; // Read data from register 2

endmodule