
module MUX_2to1_32bit(i1, i2, sel, out);

input wire[0:0] sel;
input wire[31:0] i1, i2;
output wire[31:0] out;

assign out = (sel==1'b0) ? i1 : i2;


endmodule
