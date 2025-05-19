`include "defines.v"

module IMEM (
  input [`WIDTH-1:0] pc,
  output [`WIDTH-1:0] instr
);

  // Memory
  reg [`WIDTH-1:0] instr_memory [31:0];

  initial begin
    $readmemh("Verification/instrMem.txt", instr_memory);;
  end

  assign instr = instr_memory[pc[`WIDTH-1:2]]; // 4 byte aligned

endmodule