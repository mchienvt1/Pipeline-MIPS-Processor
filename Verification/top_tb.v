`include "defines.v" 
 
`timescale 1ns/1ps 
 
module tb_top; 
 
  // Inputs 
  reg clk; 
  reg rst; 
 
  // Instantiate the Unit Under Test (UUT) 
  top uut ( 
    .clk(clk),  
    .rst(rst) 
  ); 
 
  // Clock generation: 10ns period (100MHz) 
  always #5 clk = ~clk; 
 
  // Giai đoạn trong pipeline để theo dõi 
  integer cycle_count = 0; 
   
  // Ghi lại giá trị sau mỗi chu kỳ đồng hồ 
  always @(posedge clk) begin 
    if (rst) begin 
      cycle_count <= cycle_count + 1; 
    end 
  end 
 
  // Initial block 
  initial begin
    $display("----- MIPS Pipeline Testbench Started -----"); 
 
    // Dump file cho GTKWave
    $dumpfile("top_wave.vcd");
    $dumpvars(0, tb_top);
    
    // Khởi tạo 
    clk = 0; 
    rst = 0; 
 
    // Giữ reset trong 2 chu kỳ 
    #20; 
    rst = 1; 
 
    // Chạy mô phỏng trong một khoảng thời gian 
    #500; 
 
    $display("----- MIPS Pipeline Testbench Finished -----"); 
    $finish;  // Sử dụng $finish thay vì $stop để kết thúc mô phỏng hoàn toàn
  end 
 
  // Monitor output signals 
  initial begin 
    $monitor("Time=%0t | Cycle=%0d | ===PIPELINE STATUS===", $time, cycle_count); 
  end 
   
  // Hiển thị trạng thái chi tiết sau mỗi chu kỳ đồng hồ dương 
  always @(posedge clk) begin 
    if (rst) begin 
      // Hiển thị thông tin IF Stage 
      $display("\n----- Cycle %0h -----", cycle_count); 
      $display("IF Stage: PC=%h, Instruction=%h", uut.pc_fetch, uut.instr_fetch); 
       
      // Hiển thị thông tin ID Stage 
      $display("ID Stage: PC=%h, Instruction=%h", uut.pc_decode, uut.instr_decode); 
      $display("         Data1=%h, Data2=%h, SignExt=%h", uut.data1_decode, uut.data2_decode, uut.signext_decode); 
      $display("         Jump=%h, PCSrc=%h, Branch=%h", uut.jump_decode, uut.pcsrc_decode, uut.branch_decode); 
       
      // Hiển thị thông tin EXE Stage 
      $display("EX Stage: RegWrite=%h, MemtoReg=%h, MemWrite=%h, ALUSrc=%h",  
               uut.regwrite_exe, uut.memtoreg_exe, uut.memwrite_exe, uut.alusrc_exe); 
      $display("         Rs=%h, Rt=%h, Rd=%h, ALUOut=%h",  
               uut.Rs_exe, uut.Rt_exe, uut.Rd_exe, uut.aluout_exe); 
      $display("         ForwardA=%h, ForwardB=%h", uut.forwardA_exe, uut.forwardB_exe); 
       
      // Hiển thị thông tin MEM Stage 
      $display("MEM Stage: RegWrite=%h, MemtoReg=%h, MemWrite=%h",  
               uut.regwrite_mem, uut.memtoreg_mem, uut.memwrite_mem); 
      $display("          ALUOut=%h, WriteData=%h, ReadData=%h",  
               uut.aluout_mem, uut.writedata_mem, uut.readdata_mem); 
       
      // Hiển thị thông tin WB Stage 
      $display("WB Stage: RegWrite=%h, MemtoReg=%h, RegAddr=%h",  
               uut.regwrite_wb, uut.memtoreg_wb, uut.regaddr_wb); 
      $display("         ReadData=%h, ALUOut=%h, Result=%h",  
               uut.readdata_wb, uut.aluout_wb, uut.result_wb); 
       
      // Hiển thị thông tin về Hazard 
      $display("Hazard Control: Stall_PC=%h, Stall_Decode=%h, Flush_Decode=%h, Flush_EXE=%h",  
               uut.stall_pc, uut.stall_decode, uut.flush_decode, uut.flush_exe); 
    end 
  end
endmodule