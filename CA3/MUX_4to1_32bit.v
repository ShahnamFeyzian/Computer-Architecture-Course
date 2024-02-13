

module MUX_4to1_32bit(i1, i2, i3, i4, sel, out);

input wire[31:0] i1, i2, i3, i4;
input wire[1:0] sel;
output wire[31:0] out;

assign out =    (sel==2'b00) ? i1 :
		(sel==2'b01) ? i2 :
		(sel==2'b10) ? i3 :
		(sel==2'b11) ? i4 : 2'bz;
	

endmodule