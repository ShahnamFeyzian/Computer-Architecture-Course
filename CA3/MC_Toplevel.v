
module MC_Toplevel(clk);

input wire[0:0] clk;

wire [0:0] z, s, PC_update, Adr_src, mem_wr, IR_wr, reg_wr;
wire [1:0] A_src, B_src, result_src;
wire [2:0] f3, imm_src, ALU_op;
wire [6:0] op, f7;

MC_Controller controller(.clk(clk), .op(op), .f7(f7), .f3(f3), .z(z), .s(s), 
.PC_update(PC_update), .Adr_src(Adr_src), .mem_wr(mem_wr), .IR_wr(IR_src),.imm_src(imm_src), 
.reg_wr(reg_wr), .A_src(A_src), .B_src(B_src), .ALU_op(ALU_op), .result_src(result_src));

MC_Datapath datapath(.clk(clk), .PC_update(PC_update), .Adr_src(Adr_src), .mem_wr(mem_wr), 
.reg_wr(reg_wr), .IR_wr(IR_wr), .imm_src(imm_src), .A_src(A_src), .B_src(B_src), 
.ALU_op(ALU_op), .result_src(result_src), .op(op), .f3(f3), .f7(f7), .z(z), .s(s));

endmodule
