`include "defines.v"

module control(
  input [31:0] instr,              // thêm input instr
  input [5:0] opcode,
  input [5:0] funct,
  output memwrite, regwrite, memtoreg,
  output regdst, alusrc, branch, jump,
  output reg [1:0] branch_condition,
  output reg [3:0] alucontrol
);

reg [6:0] out_tmp;
assign {regwrite, memtoreg, memwrite, alusrc, regdst, jump, branch} = out_tmp;

always @(*) begin
  
  if (instr == 32'b0) begin
    // Trường hợp nop (instruction toàn số 0)
    out_tmp = 7'b0;
    alucontrol = `EXE_NO_OPERATION;
    branch_condition = 2'b0;

  end else begin
    // Reset all control signals
    out_tmp = 7'b0;
    alucontrol = 4'b0;
    branch_condition = 2'b0;

    case (opcode)
      `R_op: begin
        out_tmp = `R_control; 
        case (funct)
          `add_funct: alucontrol = `EXE_ADD; 
          `and_funct: alucontrol = `EXE_AND; 
          `sub_funct: alucontrol = `EXE_SUB; 
          `or_funct:  alucontrol = `EXE_OR;
          `slt_funct: alucontrol = `EXE_SLT;
          `nor_funct: alucontrol = `EXE_NOR;
          `sll_funct: alucontrol = `EXE_SLL;
          `srl_funct: alucontrol = `EXE_SRL;
          default:    alucontrol = `EXE_NO_OPERATION;
        endcase
      end

      `lw_op: begin
        out_tmp = `lw_control;
        alucontrol = `EXE_ADD;
      end

      `sw_op: begin
        out_tmp = `sw_control;
        alucontrol = `EXE_ADD;
      end

      `addi_op: begin
        out_tmp = `addi_control;
        alucontrol = `EXE_ADD;
      end

      `andi_op: begin
        out_tmp = `andi_control;
        alucontrol = `EXE_AND;
      end

      `ori_op: begin
        out_tmp = `ori_control;
        alucontrol = `EXE_OR;
      end

      `slti_op: begin
        out_tmp = `slti_control;
        alucontrol = `EXE_SLT;
      end

      `beq_op: begin
        out_tmp = `beq_control;
        alucontrol = `EXE_SUB;
        branch_condition = `beq;
      end

      `bne_op: begin
        out_tmp = `bne_control;
        alucontrol = `EXE_SUB;
        branch_condition = `bne;
      end

      `jump_op: begin
        out_tmp = `jump_control;
        alucontrol = `EXE_NO_OPERATION;
      end

      default: begin
        out_tmp = 7'b0;
        alucontrol = 4'b0;
        branch_condition = 2'b0;
      end
    endcase
  end
end

endmodule