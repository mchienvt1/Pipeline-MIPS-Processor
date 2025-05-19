`include "defines.v"

module IF2ID (
  input clk, rst,
  input stall_decode, flush_decode,
  input [`WIDTH-1:0] instr_fetch,
  input [`WIDTH-1:0] pc_fetch,
  output reg [`WIDTH-1:0] instr_decode,
  output reg [`WIDTH-1:0] pc_decode
);

  always @(posedge clk) begin
    if(!rst || flush_decode) begin
      {pc_decode, instr_decode} <= 0; // Reset or flush the pipeline stage
    end
    else if (stall_decode) begin
      {pc_decode, instr_decode} <= {pc_decode, instr_decode}; // Pass the values to the next stage  
    end
    else begin
      {pc_decode, instr_decode} <= {pc_fetch, instr_fetch}; // Hold the values if stalled
    end
  end

endmodule