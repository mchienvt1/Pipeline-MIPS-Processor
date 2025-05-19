`include "defines.v"

module WBStage (
  input memtoreg_wb,
  input [`WIDTH-1:0] readdata_wb, aluout_wb,
  output [`WIDTH-1:0] result_wb
);

  mux2to1 mux_result (aluout_wb, readdata_wb, memtoreg_wb, result_wb); // MUX for writeback data

endmodule