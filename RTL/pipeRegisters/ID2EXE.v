`include "defines.v"

module ID2EXE (
  input clk, rst,
  input flush_exe,
  input regwrite_decode, memtoreg_decode, memwrite_decode, alusrc_decode, regdst_decode,
  input [3:0] alucontrol_decode,
  input [4:0] Rs_decode, Rt_decode, Rd_decode,
  input [`WIDTH-1:0] data1_decode, data2_decode, signext_decode,
  input [4:0] shamt_decode,
  
  output reg regwrite_exe, memtoreg_exe, memwrite_exe, alusrc_exe, regdst_exe,
  output reg [3:0] alucontrol_exe,
  output reg[4:0] Rs_exe, Rt_exe, Rd_exe,
  output reg [`WIDTH-1:0] data1_exe, data2_exe, signext_exe,
  output reg [4:0] shamt_exe
);

  always @(posedge clk) begin
    if(!rst || flush_exe) begin
      regwrite_exe   <= 0;
      memtoreg_exe   <= 0;
      memwrite_exe   <= 0;
      alusrc_exe     <= 0;
      regdst_exe     <= 0;
      alucontrol_exe <= 0;
      data1_exe      <= 0;
      data2_exe      <= 0;
      Rs_exe         <= 0;
      Rt_exe         <= 0;
      Rd_exe         <= 0;
      signext_exe    <= 0;
      shamt_exe      <= 0;
    end
    else begin
      regwrite_exe   <= regwrite_decode;
      memtoreg_exe   <= memtoreg_decode;
      memwrite_exe   <= memwrite_decode;
      alusrc_exe     <= alusrc_decode;
      regdst_exe     <= regdst_decode;
      alucontrol_exe <= alucontrol_decode;
      data1_exe      <= data1_decode;
      data2_exe      <= data2_decode;
      Rs_exe         <= Rs_decode;
      Rt_exe         <= Rt_decode;
      Rd_exe         <= Rd_decode;
      signext_exe    <= signext_decode;
      shamt_exe      <= shamt_decode;
    end
  end

endmodule