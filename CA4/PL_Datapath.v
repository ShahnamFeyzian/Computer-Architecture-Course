
module PL_Datapath(clk, imm_src, reg_wr, alu_control, mem_wr, alu_src, pc_src2, 
res_src, stall_F, stall_D, flush_D, flush_E, forward_A_src, forward_B_src , func7, func3, op,
rs1_D_out, rs2_D_out, rs1_E_out, rs2_E_out, rd_E_out, jump, res_src_E_out, rd_M_out, reg_wr_M_out, 
rd_W_out, reg_wr_W_out, op_E_out);


input wire [0:0] clk, reg_wr, mem_wr, alu_src, pc_src2, stall_F, stall_D, flush_D, flush_E;
input wire [1:0] res_src, forward_A_src, forward_B_src;
input wire [2:0] alu_control, imm_src ;

output wire [0:0] jump, reg_wr_W_out, reg_wr_M_out;
output wire [1:0] res_src_E_out;
output wire [6:0] func7, op , op_E_out; 
output wire [2:0] func3 ;
output wire [4:0] rs1_D_out, rs2_D_out, rs1_E_out, rs2_E_out, rd_E_out, rd_M_out, rd_W_out;


wire [31:0] const_4 = 32'd4;

wire [0:0] reg_wr_W, pc_src2_E, pc_src1_E;
wire [4:0] rd_W;
wire [31:0] pc_plus4_F, pc_src1_out_F, pc_src2_out_F, pc_out_F, inst_out_F,
inst_D, pc_D, pc_plus4_D, rd1_D, rd2_D, imm_D,
pc_target_E, alu_res_E,
alu_res_M,
result_W;


MUX_2to1_32bit PC_src1_mux(.i1(pc_target_E), .i2(pc_plus4_F), .sel(pc_src1_E), .out(pc_src1_out_F));
MUX_2to1_32bit PC_src2_mux(.i1(pc_src1_out_F), .i2(alu_res_E), .sel(pc_src2_E), .out(pc_src2_out_F));
Program_Counter PC(.clk(clk), .en(stall_F), .in(pc_src2_out_F), .out(pc_out_F));
Inst_Mem inst_memory(.address({2'b0, pc_out_F[31:2]}), .inst(inst_out_F));
Adder_32bit pc_plus4_adder(.A(pc_out_F) , .B(const_4) , .out(pc_plus4_F));

Wall_D wall_D(.clk(clk), .clr(flush_D), .en(stall_D), .inst_in(inst_out_F), .pc_in(pc_out_F), 
              .pc_plus4_in(pc_plus4_F), .inst_out(inst_D), .pc_out(pc_D), .pc_plus4_out(pc_plus4_D));

assign func7 = inst_D[31:25] ;
assign func3 = inst_D[14:12] ;
assign op = inst_D[6:0] ;
wire [4:0] rs1_D=inst_D[19:15], rs2_D=inst_D[24:20], rd_D=inst_D[11:7];
Reg_File RF(.clk(clk), .wr_en(reg_wr_W), .a1(rs1_D), .a2(rs2_D),
            .a3(rd_W), .wd(result_W), .rd1(rd1_D), .rd2(rd2_D));
Imm_Ext imm_ext(.v_in(inst_D), .imm_source(imm_src), .v_out(imm_D));
assign rs1_D_out = rs1_D;
assign rs2_D_out = rs2_D;


wire [0:0] reg_wr_E, mem_wr_E, alu_src_E;
wire [1:0] res_src_E;
wire [2:0] alu_control_E, f3_E;
wire [4:0] rs1_E, rs2_E, rd_E;
wire [6:0] op_E;
wire [31:0] rd1_E, rd2_E, pc_E, imm_E, pc_plus4_E;
Wall_E wall_E(.clk(clk), .clr(flush_E), .reg_wr_in(reg_wr), .reg_wr_out(reg_wr_E), .res_src_in(res_src), 
              .res_src_out(res_src_E), .mem_wr_in(mem_wr), .mem_wr_out(mem_wr_E), 
              .pc_src2_in(pc_src2), .pc_src2_out(pc_src2_E), 
              .alu_control_in(alu_control), .alu_control_out(alu_control_E), .alu_src_in(alu_src), 
              .alu_src_out(alu_src_E), .rd1_in(rd1_D), .rd1_out(rd1_E), .rd2_in(rd2_D), .rd2_out(rd2_E), 
              .pc_in(pc_D), .pc_out(pc_E), .rs1_in(rs1_D), .rs1_out(rs1_E), .rs2_in(rs2_D), .rs2_out(rs2_E), 
              .rd_in(rd_D), .rd_out(rd_E), .imm_in(imm_D), .imm_out(imm_E),
              .pc_plus4_in(pc_plus4_D), .pc_plus4_out(pc_plus4_E), .op_in(inst_D[6:0]), .op_out(op_E),
              .f3_in(inst_D[14:12]), .f3_out(f3_E));

wire [0:0] zero_E;
wire [31:0] alu_srcA_E, alu_srcB_E, forward_B_out, imm_M;
MUX_4to1_32bit forward_A(.i1(rd1_E), .i2(result_W), .i3(alu_res_M), .i4(32'b0), .sel(forward_A_src), .out(alu_srcA_E));
MUX_4to1_32bit forward_B(.i1(rd2_E), .i2(result_W), .i3(alu_res_M), .sel(forward_B_src), .out(forward_B_out));
MUX_2to1_32bit alu_srcB_mux(.i1(forward_B_out), .i2(imm_E), .sel(alu_src_E), .out(alu_srcB_E));
ALU alu(.A(alu_srcA_E), .B(alu_srcB_E) , .op(alu_control_E), .v_out(alu_res_E), .z(zero_E)); 
PC_src1_logic pc_src1_logic(.clk(clk), .op(op_E), .f3(f3_E), .zero(zero_E), .sign(alu_res_E[31]), .pc_src1(pc_src1_E));
Adder_32bit PC_target_adder(.A(pc_E) , .B(imm_E) , .out(pc_target_E));
assign rs1_E_out = rs1_E;
assign rs2_E_out = rs2_E;
assign rd_E_out = rd_E;
assign jump = (pc_src2_E==1'b1 || pc_src1_E==1'b0) ? 1'b1 : 1'b0;
assign res_src_E_out = res_src_E;
assign op_E_out = op_E;


wire [0:0] reg_wr_M, mem_wr_M;
wire [1:0] res_src_M;
wire [4:0] rd_M;
wire [31:0] wd_M, pc_plus4_M;
Wall_M wall_M(.clk(clk), .reg_wr_in(reg_wr_E), .reg_wr_out(reg_wr_M), .res_src_in(res_src_E), .res_src_out(res_src_M), 
              .mem_wr_in(mem_wr_E), .mem_wr_out(mem_wr_M), .alu_res_in(alu_res_E), .alu_res_out(alu_res_M),
              .wd_in(forward_B_out), .wd_out(wd_M), .rd_in(rd_E), .rd_out(rd_M), .pc_plus4_in(pc_plus4_E), 
              .pc_plus4_out(pc_plus4_M), .imm_in(imm_E), .imm_out(imm_M));

wire [31:0] data_mem_out_M;
Data_Mem data_memory(.clk(clk), .wr_en(mem_wr_M), .address({2'b0, alu_res_M[31:2]}), .data_in(wd_M), .data_out(data_mem_out_M));
assign rd_M_out = rd_M;
assign reg_wr_M_out = reg_wr_M;



wire[1:0] res_src_W;
wire[31:0] alu_res_W, data_mem_out_W, pc_plus4_W, imm_W;
Wall_W wall_W(.clk(clk), .reg_wr_in(reg_wr_M), .reg_wr_out(reg_wr_W), .res_src_in(res_src_M), .res_src_out(res_src_W), 
              .alu_res_in(alu_res_M), .alu_res_out(alu_res_W), .data_in(data_mem_out_M), 
              .data_out(data_mem_out_W), .rd_in(rd_M), .rd_out(rd_W), .pc_plus4_in(pc_plus4_M), 
              .pc_plus4_out(pc_plus4_W), .imm_in(imm_M), .imm_out(imm_W));

MUX_4to1_32bit Result_mux(.i1(alu_res_W), .i2(data_mem_out_W), .i3(pc_plus4_W), .i4(imm_W), .sel(res_src_W), .out(result_W));
assign rd_W_out = rd_W;
assign reg_wr_W_out = reg_wr_W;

endmodule
