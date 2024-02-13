

module Reg_32bit(clk, wr_en, v_in, v_out);

input wire [0:0] clk, wr_en;
input wire [31:0] v_in;
output wire[31:0] v_out;

reg [31:0] internal_reg = 32'b0;


always @(posedge clk) begin

if(wr_en) internal_reg = v_in;

end

assign v_out = internal_reg;

endmodule