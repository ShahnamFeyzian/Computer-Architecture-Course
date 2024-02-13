`timescale 1ns/1ns

module Toplevel_TB();

reg [0:0]clk = 1'b0;

MC_Toplevel top(clk);

always #5 clk = ~clk;

initial begin



#1000 $stop;

end

endmodule
