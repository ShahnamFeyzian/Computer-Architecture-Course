
module SC_Toplevel(clk);

input wire [0:0] clk;

wire [0:0] reg_wr, mem_wr, pc_src, alu_src, pc_inp_src, zero, alu_sign;
wire [1:0] reg_src;
wire [2:0] imm_src, alu_control, f3;
wire [6:0] op, f7;

SC_Datapath DP(.clk(clk), .imm_src(imm_src), .reg_wr(reg_wr), .alu_control(alu_control), 
.mem_wr(mem_wr), .pc_src(pc_src), .alu_src(alu_src), .pc_inp_src(pc_inp_src), 
.reg_src(reg_src), .zero(zero) , .func7(f7), .func3(f3), .op(op) , .alu_sign(alu_sign));

SC_Controller CU(.op(op), .f3(f3), .f7(f7), .z(zero), .s(alu_sign), 
.reg_wr(reg_wr), .imm_source(imm_src), .ALU_source(alu_src), 
.ALU_control(alu_control), .mem_wr(mem_wr), .reg_source(reg_src), 
.pc_source1(pc_src), .pc_source2(pc_inp_src));

endmodule
