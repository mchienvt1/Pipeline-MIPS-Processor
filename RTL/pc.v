`include "defines.v"

module pc(
  input clk, rst,
  input stall_pc,
  input [`WIDTH-1:0] pc_in,
  output reg [`WIDTH-1:0] pc_out
);

  always @(posedge clk) begin
    if(!rst) begin
      pc_out <= 0; // Reset the PC to 0
    end
    else if (stall_pc) begin
      pc_out <= pc_out; // Hold the value if stalled
    end
    else begin
      pc_out <= pc_in; // Update the PC with the new value
    end
  end

endmodule