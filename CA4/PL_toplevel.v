
module PL_toplevel(clk);

input wire[0:0] clk;


wire [0:0] reg_wr, mem_wr, alu_src, pc_src2, stall_f, stall_D, flush_D, flush_E, jump, reg_wr_M, reg_wr_W;
wire [1:0] res_src, forwardA_src, forwardB_src, res_src_E;
wire [2:0] imm_src, alu_control, f3;
wire [4:0] rs1_D, rs2_D, rs1_E, rs2_E, rd_E, rd_M, rd_W;
wire [6:0] f7, op, op_E;

PL_Datapath data_path(.clk(clk), .imm_src(imm_src), .reg_wr(reg_wr), .alu_control(alu_control), .mem_wr(mem_wr), 
                     .alu_src(alu_src), .pc_src2(pc_src2), .res_src(res_src), .stall_F(stall_F), .stall_D(stall_D), 
                     .flush_D(flush_D), .flush_E(flush_E), .forward_A_src(forwardA_src), .forward_B_src(forwardB_src), 
                     .func7(f7), .func3(f3), .op(op), .rs1_D_out(rs1_D), .rs2_D_out(rs2_D), .rs1_E_out(rs1_E), 
                     .rs2_E_out(rs2_E), .rd_E_out(rd_E), .jump(jump), .res_src_E_out(res_src_E), .rd_M_out(rd_M), 
                     .reg_wr_M_out(reg_wr_M), .rd_W_out(rd_W), .reg_wr_W_out(reg_wr_W), .op_E_out(op_E));


PL_Controller control_unit(.op(op), .f3(f3), .f7(f7), .reg_wr(reg_wr), .imm_source(imm_src), .ALU_source(alu_src), 
			   .ALU_control(alu_control), .mem_wr(mem_wr), .reg_source(res_src), .pc_source2(pc_src2));

Hazard_Unit hazard_unit(.rs1_D(rs1_D), .rs2_D(rs2_D), .rs1_E(rs1_E), .rs2_E(rs2_E), .rd_E(rd_E), .jump(jump), 
                        .res_src_E(res_src_E), .rd_M(rd_M), .rd_W(rd_W), .reg_wr_M(reg_wr_M), .reg_wr_W(reg_wr_W),
                        .stall_F(stall_F), .stall_D(stall_D), .flush_D(flush_D), .flush_E(flush_E), 
                        .forwardA_src(forwardA_src), .forwardB_src(forwardB_src), .op_E(op_E));

endmodule
