`include "defines.v"

module ALU(
  input [`WIDTH-1:0] val1,val2,
  input [3:0] alucontrol_exe,
  input [4:0] shamt_exe,
  output reg [`WIDTH-1:0] aluout_exe
);

always @(*) begin
  case(alucontrol_exe)
    `EXE_ADD: aluout_exe = val1 + val2; // ADD
    `EXE_AND: aluout_exe = val1 & val2; // SUB
    `EXE_SUB: aluout_exe = val1 - val2; // AND
    `EXE_OR: aluout_exe = val1 | val2; // OR
    `EXE_SLT: aluout_exe = val1 < val2; //SLT
    `EXE_NOR: aluout_exe = ~(val1 | val2); // NOR
    `EXE_SLL: aluout_exe = (val2 << shamt_exe); // SLL
    `EXE_SRL: aluout_exe = (val2 >> shamt_exe); // SRL
    `EXE_NO_OPERATION: aluout_exe = 0;
    default: aluout_exe = 0; // Default case
  endcase
end
endmodule