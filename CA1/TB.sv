`timescale 1ns/1ns

module TB();

reg [0:0] clk=0, rst=0, start=0, run=0;
wire [0:0] mapOutput, mapRead, mapWrite, mapInput, Fail, Done;
wire [1:0] Move;
wire [3:0] poseX, poseY;

IntelligentMouse IM(.CLK(clk), .RST(rst), .Start(start), .Run(run), .Din(mapOutput),
.poseX(poseX), .poseY(poseY), .RD(mapRead), .WR(mapWrite), .Dout(mapInput),
.Fail(Fail), .Done(Done), .Move(Move));

MazeMemory MM(.clk(clk), .rst(rst), .data_out(mapOutput), 
.x(poseX), .y(poseY), .rd(mapRead), .wr(mapWrite), .data_in(mapInput));


always #5 clk = ~clk;

initial begin
#52 start = 1;
#10 start = 0;


#40000 run = 1;
#20 run = 0;
#15000 $stop;
end

endmodule
