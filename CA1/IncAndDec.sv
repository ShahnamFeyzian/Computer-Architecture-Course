
module IncAndDec(Din, incSignal, decSignal, Dout, overflow);

input wire [3:0] Din;
input wire [0:0] incSignal, decSignal;
output wire [3:0] Dout;
output wire [0:0] overflow;

assign Dout = (incSignal) ? Din + 1 :
			  (decSignal) ? Din - 1 : Din;

assign overflow = (Din == 4'b1111 && incSignal) || (Din == 4'b0000 && decSignal);

endmodule
