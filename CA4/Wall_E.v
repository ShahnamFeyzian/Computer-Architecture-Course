
module Wall_E(clk, clr, reg_wr_in, reg_wr_out, res_src_in, res_src_out, mem_wr_in, mem_wr_out,
pc_src2_in, pc_src2_out, alu_control_in, alu_control_out, alu_src_in, alu_src_out,
rd1_in, rd1_out, rd2_in, rd2_out, pc_in, pc_out, rs1_in, rs1_out, rs2_in, rs2_out, rd_in, rd_out, imm_in, imm_out,
pc_plus4_in, pc_plus4_out, op_in, op_out, f3_in, f3_out);

input wire[0:0] clk, clr, reg_wr_in, mem_wr_in, pc_src2_in, alu_src_in;
output wire[0:0] reg_wr_out, mem_wr_out, pc_src2_out, alu_src_out;
input wire[1:0] res_src_in;
output wire[1:0] res_src_out;
input wire[2:0] alu_control_in, f3_in;
output wire[2:0] alu_control_out, f3_out;
input wire[4:0] rs1_in, rs2_in, rd_in;
output wire[4:0] rs1_out, rs2_out, rd_out;
input wire[6:0] op_in;
output wire[6:0] op_out;
input wire[31:0] rd1_in, rd2_in, pc_in, imm_in, pc_plus4_in;
output wire[31:0] rd1_out, rd2_out, pc_out, imm_out, pc_plus4_out;

reg[0:0] reg_wr, mem_wr, pc_src2=1'b0, alu_src;
reg[1:0] res_src=2'b0;
reg[2:0] alu_control, f3;
reg[4:0] rs1=5'b0, rs2=5'b0, rd=5'b0;
reg[6:0] op;
reg[31:0] rd1, rd2, pc, imm, pc_plus4;

reg[1:0] counter =2'b0;

always @(posedge clk) begin 

if(clr) begin 
  reg_wr <= 1'b0; 
  mem_wr <= 1'b0; 
  res_src <= 2'b0;
  op <= 7'b0; 
end
else begin
  counter <= (counter < 2'b10) ? counter+1 : counter;
  reg_wr <= reg_wr_in;
  mem_wr <= mem_wr_in;
  pc_src2 <= (counter > 2'b00) ? pc_src2_in : 1'b0;
  alu_src <= alu_src_in;
  res_src <= (counter > 2'b00)? res_src_in : 2'b0;
  alu_control <= alu_control_in;
  rs1 <= (counter > 2'b00)? rs1_in : 5'b0;
  rs2 <= (counter > 2'b00)? rs2_in : 5'b0;
  rd <= (counter > 2'b00)? rd_in : 5'b0;
  rd1 <= rd1_in;
  rd2 <= rd2_in;
  pc <= pc_in;
  imm <= imm_in;
  pc_plus4 <= pc_plus4_in;
  f3 <= f3_in;
  op <= op_in;
end

end

assign reg_wr_out = reg_wr;
assign mem_wr_out = mem_wr;
assign pc_src2_out = pc_src2;
assign alu_src_out = alu_src;
assign res_src_out = res_src;
assign alu_control_out = alu_control;
assign rs1_out = rs1;
assign rs2_out = rs2;
assign rd_out = rd;
assign rd1_out = rd1;
assign rd2_out = rd2;
assign pc_out = pc;
assign imm_out = imm;
assign pc_plus4_out = pc_plus4;
assign f3_out = f3;
assign op_out = op;

endmodule
