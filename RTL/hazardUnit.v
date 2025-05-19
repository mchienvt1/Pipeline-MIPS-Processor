`include "defines.v"

module hazardUnit (
  input branch_decode,
  input [4:0] Rs_decode, Rt_decode, Rs_exe, Rt_exe,
  input [4:0] regaddr_wb,
  input [4:0] regaddr_mem,
  input [4:0] regaddr_exe,
  input regwrite_wb, regwrite_mem,
  input memtoreg_exe,
  input memtoreg_mem,
  input regwrite_exe,
  output flush_exe,
  output stall_pc, stall_decode, stall_compare,
  output reg forwardA_decode,
  output reg forwardB_decode,
  output reg [1:0] forwardA_exe,
  output reg [1:0] forwardB_exe
);
  reg lwstall, branchstall;

  wire tmp = lwstall || branchstall;
  assign stall_pc = tmp;
  assign stall_decode = tmp;
  assign stall_compare = tmp;
  assign flush_exe = tmp;


  // Forwarding Unit for Rs_EXE
  always @(*) begin
    if((Rs_exe != 0) && (Rs_exe == regaddr_mem) && (regwrite_mem == 1)) begin
      forwardA_exe = 2'b10;
    end
    else if ((Rs_exe != 0) && (Rs_exe == regaddr_wb) && (regwrite_wb == 1)) begin
      forwardA_exe = 2'b01;
    end
    else begin
      forwardA_exe = 2'b00;
    end
  end

  // Forwarding Unit for Rt_EXE
  always @(*) begin
    if((Rt_exe != 0) && (Rt_exe == regaddr_mem) && (regwrite_mem == 1)) begin
      forwardB_exe = 2'b10;
    end
    else if ((Rt_exe != 0) && (Rt_exe == regaddr_wb) && (regwrite_wb == 1)) begin
      forwardB_exe = 2'b01;
    end
    else begin
      forwardB_exe = 2'b00;
    end
  end

  // Forward Unit for Condition Check
  always @(*) begin
    forwardA_decode = ((Rs_decode != 0) && (Rs_decode == regaddr_mem) && (regwrite_mem == 1));
    forwardB_decode = ((Rt_decode != 0) && (Rt_decode == regaddr_mem) && (regwrite_mem == 1));
  end

  //LW Hazard Detection
  always @(*) begin
    if(((Rs_decode == Rt_exe) || (Rt_decode == Rt_exe)) && memtoreg_exe) begin
      lwstall = 1;
    end
    else begin
      lwstall = 0;
    end
  end

  // BRANCH Hazard Detection
  always  @(*) begin
    if(branch_decode && regwrite_exe && ((regaddr_exe == Rs_decode) || (regaddr_exe == Rt_decode))) begin
      branchstall = 1;
    end
    else if(branch_decode && memtoreg_mem && (regaddr_mem == Rs_decode || regaddr_mem == Rt_decode)) begin
      branchstall = 1;
    end
    else begin
      branchstall = 0;
    end
  end

endmodule

