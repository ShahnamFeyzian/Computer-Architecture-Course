`timescale 1ns/1ns

module PL_TOP_TB();

reg [0:0] clk=0;

PL_toplevel pipe_line(clk);


always #5 clk = ~clk;

initial begin

#10000 $stop;

end



endmodule
