`timescale 1ns/1ps
`include "defines.v"

module tb_imem;

  // Inputs
  reg [`WIDTH-1:0] pc;

  // Outputs
  wire [`WIDTH-1:0] instr;

  // Instantiate the Unit Under Test (UUT)
  IMEM uut (
    .pc(pc),
    .instr(instr)
  );

  // Dump waveforms
  initial begin
    $dumpfile("imem_test.vcd");
    $dumpvars(0, tb_imem);
  end

  // Test logic
  initial begin
    $display("===== BẮT ĐẦU TEST IMEM =====");

    // Khởi tạo PC
    pc = 0;

    // Đợi 10ns để nạp instrMem.txt
    #10;

    // In thử các lệnh đã nạp
    repeat (10) begin
      $display("PC = %0h | instr = %0h", pc, instr);
      pc = pc + 4;   // Mỗi lệnh cách nhau 4 byte
      #10;
    end

    $display("===== KẾT THÚC TEST =====");
    $finish;
  end

endmodule
