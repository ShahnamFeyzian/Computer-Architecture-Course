
module IM_Datapath(rst, clk, ldX, ldY, IncX, IncY, DecX, DecY, pushSQ, popSQ, SQ_Input, SQ_Read, selMove,
poseX, poseY, topValueSQ, SQ_Empty, SQ_Done, overflow, Move);

input wire [0:0] rst, clk, ldX, ldY, IncX, IncY, DecX, DecY, pushSQ, popSQ, SQ_Read, selMove;
input wire [1:0] SQ_Input;
output wire[0:0] SQ_Empty, SQ_Done, overflow;
output wire[1:0] topValueSQ, Move;
output wire[3:0] poseX, poseY;


wire [3:0] Xout, Yout;
wire [1:0] move;
wire [0:0] ofX, ofY;

Register_4bit CurrentX (.clk(clk), .ld(ldX), .rst(rst), .Dout(Xout), .Din(poseX));
Register_4bit CurrentY (.clk(clk), .ld(ldY), .rst(rst), .Dout(Yout), .Din(poseY));

IncAndDec IncDecX (.incSignal(IncX), .decSignal(DecX), .Din(Xout), .Dout(poseX), .overflow(ofX));
IncAndDec IncDecY (.incSignal(IncY), .decSignal(DecY), .Din(Yout), .Dout(poseY), .overflow(ofY));
or Overflow (overflow, ofX, ofY);

SQ_Component stackAndQueue(.clk(clk), .rst(rst), .pushSignal(pushSQ), .popSignal(popSQ), .readSignal(SQ_Read), .Din(SQ_Input),
.isEmpty(SQ_Empty), .done(SQ_Done), .stackData(topValueSQ), .qeueuData(move));

TriStateBuffer_2bit MoveTriState(.Din(move), .selSignal(selMove), .Dout(Move));

endmodule