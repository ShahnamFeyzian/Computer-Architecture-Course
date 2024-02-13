
module Wall_D(clk, clr, en, inst_in, pc_in, pc_plus4_in, inst_out, pc_out, pc_plus4_out);

input wire [0:0] clk, clr, en;
input wire [31:0] inst_in, pc_in, pc_plus4_in;
output wire [31:0] inst_out, pc_out, pc_plus4_out; 

reg [31:0] internal_inst, internal_pc, internal_pc_plus4;

always @(posedge clk) begin

if(clr) internal_inst = 32'b0;
else if(en == 1'b0) begin 
  internal_inst <= inst_in;
  internal_pc <= pc_in;
  internal_pc_plus4 <= pc_plus4_in;
end

end

assign inst_out = internal_inst;
assign pc_out = internal_pc;
assign pc_plus4_out = internal_pc_plus4;

endmodule
