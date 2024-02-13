
module TwoBitRightShifter_32bit(in, out);

input wire[31:0] in;
output wire[31:0] out;

assign out = {2'b0, in[31:2]};

endmodule
