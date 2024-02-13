
module TriStateBuffer_2bit(Din, selSignal, Dout);

input wire [1:0] Din;
input wire [0:0] selSignal;
output wire [1:0] Dout;

assign Dout = (selSignal) ? Din : 2'bz; 

endmodule
