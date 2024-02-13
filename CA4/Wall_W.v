
module Wall_W(clk, reg_wr_in, reg_wr_out, res_src_in, res_src_out, alu_res_in, alu_res_out, 
data_in, data_out, rd_in, rd_out, pc_plus4_in, pc_plus4_out, imm_in, imm_out);

input wire[0:0] clk, reg_wr_in;
output wire[0:0] reg_wr_out;
input wire[1:0] res_src_in;
output wire[1:0] res_src_out;
input wire[4:0] rd_in;
output wire[4:0] rd_out;
input wire[31:0] alu_res_in, data_in, pc_plus4_in, imm_in;
output wire[31:0] alu_res_out, data_out, pc_plus4_out, imm_out;

reg[0:0] reg_wr;
reg[1:0] res_src;
reg[4:0] rd=5'b0;
reg[31:0] alu_res, data, pc_plus4, imm;

always @(posedge clk) begin

reg_wr <= reg_wr_in;
res_src <= res_src_in;
rd <= rd_in;
alu_res <= alu_res_in;
data <= data_in;
pc_plus4 <= pc_plus4_in;
imm <= imm_in;

end

assign reg_wr_out = reg_wr;
assign res_src_out = res_src;
assign rd_out = rd;
assign alu_res_out = alu_res;
assign data_out = data;
assign pc_plus4_out = pc_plus4;
assign imm_out = imm; 

endmodule
