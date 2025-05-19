`include "defines.v"

module condition_check(
  input [`WIDTH-1:0] a,
  input [`WIDTH-1:0] b,
  input stall_compare,
  input [1:0] branch_condition,
  output reg branch_taken
);

always @(*) begin
  if (stall_compare) begin
    branch_taken = 1'b0;
  end
  else begin
    case (branch_condition)
      `beq: branch_taken = (a == b); 
      `bne: branch_taken = (a != b); 
      `not_branch: branch_taken = 0;  
      default: branch_taken = 0;   
    endcase
  end
end

endmodule