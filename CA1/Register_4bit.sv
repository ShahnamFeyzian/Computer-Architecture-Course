
module Register_4bit(Din, ld, clk, rst, Dout);

input wire [3:0] Din;
input wire [0:0] ld, clk, rst;
output reg [3:0] Dout=0;


always @(posedge clk, posedge rst) begin

if(rst) Dout <= 4'b0000;
else if(ld) Dout <= Din;

end

endmodule





