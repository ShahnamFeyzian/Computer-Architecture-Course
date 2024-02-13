
module Reg_File(clk, wr_en, a1, a2, a3, wd, rd1, rd2);

input wire[0:0] clk, wr_en;
input wire[4:0] a1, a2, a3;
input wire[31:0] wd;
output wire[31:0] rd1, rd2;

reg [0:31] internal_registers [31:0]; 

initial internal_registers[0] = 32'b0 ;

always @(negedge clk) begin

if(wr_en) internal_registers[a3] = wd;
internal_registers[0] = 32'b0;

end

assign rd1 = internal_registers[a1];
assign rd2 = internal_registers[a2];

endmodule