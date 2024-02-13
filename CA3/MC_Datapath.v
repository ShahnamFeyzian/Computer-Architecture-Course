
module MC_Datapath(clk, PC_update, Adr_src, mem_wr, reg_wr, IR_wr, imm_src, 
A_src, B_src, ALU_op, result_src, op, f3, f7, z, s);

input wire[0:0] clk, PC_update, Adr_src, mem_wr, reg_wr, IR_wr;
input wire[1:0] A_src, B_src, result_src;
input wire[2:0] imm_src, ALU_op;
output wire[0:0] z, s;
output wire[6:0] op, f7;
output wire[2:0] f3;

reg [0:0] one = 1'b1;
reg [31:0] zero_32bit = 32'b0;
reg [31:0] four_32bit = 32'd4;


wire [31:0] result, PC_out, Adr_out, sh_Adr, RD2, mem_out, old_PC_out, inst_out, 
MDR_out, RD1, imm_out, AR_out, BR_out, A_mux_out, B_mux_out, ALU_out, ALU_out_reg_out;

Reg_32bit PC(.clk(clk), .wr_en(PC_update), .v_in(result), .v_out(PC_out));

MUX_2to1_32bit Adr_mux(.i1(PC_out), .i2(result), .sel(Adr_src), .out(Adr_out));

TwoBitRightShifter_32bit shifter(.in(Adr_out), .out(sh_Adr));

Memory mem(.clk(clk), .wr_en(me_wr), .wd(RD2), .address(sh_Adr), .v_out(mem_out));
assign op = mem_out[6:0];
assign f7 = mem_out[31:25];
assign f3 = mem_out[14:12];

Reg_32bit old_PC(.clk(clk), .wr_en(IR_wr), .v_in(PC_out), .v_out(old_PC_out));

Reg_32bit inst(.clk(clk), .wr_en(IR_wr), .v_in(mem_out), .v_out(inst_out));

Reg_32bit MDR(.clk(clk), .wr_en(one), .v_in(mem_out), .v_out(MDR_out));

Reg_File RF(.clk(clk), .wr_en(reg_wr), .a1(inst_out[19:15]), .a2(inst_out[24:20]), 
.a3(inst_out[11:7]), .wd(result), .rd1(RD1), .rd2(RD2));

Imm_Ext imm_ext(.v_in(inst_out), .imm_source(imm_src), .v_out(imm_out));

Reg_32bit AR(.clk(clk), .wr_en(one), .v_in(RD1), .v_out(AR_out));

Reg_32bit BR(.clk(clk), .wr_en(one), .v_in(RD2), .v_out(BR_out));

MUX_4to1_32bit A_mux(.i1(PC_out), .i2(old_PC_out), .i3(AR_out), 
.i4(zero_32bit), .sel(A_src), .out(A_mux_out));

MUX_4to1_32bit B_mux(.i1(BR_out), .i2(imm_out), .i3(four_32bit), 
.sel(B_src), .out(B_mux_out));

ALU alu(.A(A_mux_out), .B(B_mux_out) , .op(ALU_op), .v_out(ALU_out), .z(z));
assign s = ALU_out[31];

Reg_32bit ALU_out_reg(.clk(clk), .wr_en(one), .v_in(ALU_out), .v_out(ALU_out_reg_out));

MUX_4to1_32bit result_mux(.i1(ALU_out_reg_out), .i2(MDR_out), 
.i3(ALU_out), .sel(result_src), .out(result));

endmodule
