`timescale 1ns/1ns

module Common_TB();

reg[0:0] clk=0;
reg[31:0] v_in=32'd10;

wire[31:0] v_out;

Program_Counter r32(.clk(clk), .in(v_in), .out(v_out));

always #5 clk = ~clk;

initial begin

#20 v_in = 32'd100000;
#20 v_in = 32'd6637379238;

#20 $stop;

end

endmodule
