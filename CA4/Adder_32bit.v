

module Adder_32bit(A , B , out);

input wire [31:0] A, B;
output wire [31:0] out;

assign out = A + B;

endmodule 
