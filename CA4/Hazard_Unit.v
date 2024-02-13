
module Hazard_Unit(rs1_D, rs2_D, rs1_E, rs2_E, rd_E, jump, res_src_E, rd_M, rd_W, reg_wr_M, reg_wr_W,
stall_F, stall_D, flush_D, flush_E, forwardA_src, forwardB_src, op_E);

input wire[0:0] jump, reg_wr_W, reg_wr_M;
input wire[1:0] res_src_E;
input wire[4:0] rs1_D, rs2_D, rs1_E, rs2_E, rd_E, rd_M, rd_W;
input wire[6:0] op_E;

output wire[0:0] stall_F, stall_D, flush_D, flush_E;
output wire[1:0] forwardA_src, forwardB_src;

wire [0:0] lw_stall;
assign lw_stall = ((rs1_D==rd_E || rs2_D==rd_E) && (res_src_E==2'b01)) ? 1'b1 : 1'b0;

assign stall_F = lw_stall;
assign stall_D = lw_stall;
assign flush_D = (jump == 1'b1) ? 1'b1 : 1'b0;
assign flush_E = (jump == 1'b1 || lw_stall == 1'b1) ? 1'b1 : 1'b0;
assign forwardA_src = (op_E==7'b0110111) ? 2'b11 : 
                      (rs1_E==rd_M && reg_wr_M==1'b1 && rs1_E!=5'b0) ? 2'b10 :
                      (rs1_E==rd_W && reg_wr_W==1'b1 && rs1_E!=5'b0) ? 2'b01 : 2'b00;
assign forwardB_src = (rs2_E==rd_M && reg_wr_M==1'b1 && rs2_E!=5'b0) ? 2'b10 :
                      (rs2_E==rd_W && reg_wr_W==1'b1 && rs2_E!=5'b0) ? 2'b01 : 2'b00;

endmodule
