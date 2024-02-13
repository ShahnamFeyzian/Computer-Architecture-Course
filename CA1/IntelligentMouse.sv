
module IntelligentMouse(CLK, RST, Start, Run, Din, poseX, poseY, RD, WR, Dout, Fail, Done, Move);

input wire [0:0] CLK, RST, Start, Run, Din;
output wire[0:0] RD, WR, Dout, Fail, Done;
output wire[1:0] Move;
output wire[3:0] poseX, poseY;


wire [0:0] rst, ldX, ldY, IncX, IncY, DecX, DecY, pushSQ, popSQ, SQ_Read,
selMove, SQ_Empty, SQ_Done, overflow;
wire [1:0] SQ_Input, topValueSQ;
wire[3:0] x, y;


IM_Datapath DP(.rst(rst), .clk(CLK), .ldX(ldX), .ldY(ldY), .IncX(IncX), .IncY(IncY), .DecX(decX), .DecY(DecY),
.pushSQ(pushSQ), .popSQ(popSQ), .SQ_Input(SQ_Input), .SQ_Read(SQ_Read), .selMove(selMove), .overflow(overflow),
.poseX(x), .poseY(y), .topValueSQ(topValueSQ), .SQ_Empty(SQ_Empty), .SQ_Done(SQ_Done), .Move(Move));

IM_Controller CU(.rstDP(rst), .ldX(ldX), .ldY(ldY), .IncX(IncX), .IncY(IncY), .DecX(decX), .DecY(DecY),
.pushSQ(pushSQ), .popSQ(popSQ), .SQ_Read(SQ_Read), .SQ_Input(SQ_Input), .selMove(selMove), .overflow(overflow),
.topValueSQ(topValueSQ), .SQ_Empty(SQ_Empty), .SQ_Done(SQ_Done),
.Start(Start), .Rst(RST), .Run(Run), .CLK(CLK), .target(Din), .RD(RD), .WR(WR), .mapInput(Dout),
.Fail(Fail), .Done(Done), .poseX(x), .poseY(y));


assign poseX = x;
assign poseY = y;

endmodule
