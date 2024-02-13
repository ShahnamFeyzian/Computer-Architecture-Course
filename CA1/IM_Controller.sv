
`define GetReady 0

`define CheckMoveU 1
`define CheckMoveR 2
`define CheckMoveL 3
`define CheckMoveD 4
`define MarkU 5
`define MarkR 6
`define MarkL 7
`define MarkD 8
`define MoveU 9
`define MoveR 10
`define MoveL 11
`define MoveD 12

`define CheckEnd 13

`define MoveBack 14
`define BackU 15
`define BackR 16
`define BackL 17
`define BackD 18

`define Fail 19
`define End 20

`define Running 21

`define UP 2'b00
`define RIGHT 2'b01
`define LEFT 2'b10
`define DOWN 2'b11

module IM_Controller(Start, Rst, Run, CLK, target, poseX, poseY, topValueSQ, 
SQ_Empty, SQ_Done, overflow,
ldX, ldY, IncX, IncY, DecX, DecY, RD, WR, mapInput, pushSQ, popSQ, SQ_Input, Fail, 
Done, SQ_Read, selMove, rstDP);

input wire [0:0] Start, Rst, Run, CLK, target, SQ_Empty, SQ_Done, overflow; 
input wire [3:0] poseX, poseY;
input wire [1:0] topValueSQ; 

output reg [0:0] ldX, ldY, IncX, IncY, DecX, DecY, RD, WR, mapInput,
			pushSQ, popSQ, Fail, Done, SQ_Read, selMove, rstDP;
output reg [1:0] SQ_Input;

reg [4:0]ps = `GetReady, ns = `GetReady;


always @(posedge CLK, posedge Rst) 
begin
  if(Rst) begin ps <= `GetReady; ns <= `GetReady; end
  else ps <= ns; 
end


always @(ps, Start, Run, target, SQ_Empty, SQ_Done, poseX, poseY, topValueSQ)
begin
  case (ps)
    `GetReady : ns = (Start) ? `CheckMoveU : `GetReady;
    `CheckMoveU : ns = (target || overflow) ? `CheckMoveR : `MarkU;
    `CheckMoveR : ns = (target || overflow) ? `CheckMoveL : `MarkR;
    `CheckMoveL : ns = (target || overflow) ? `CheckMoveD : `MarkL;
    `CheckMoveD : ns = (target || overflow) ? `MoveBack : `MarkD;
    `MarkU : ns = `MoveU;
    `MarkR : ns = `MoveR;
    `MarkL : ns = `MoveL;
    `MarkD : ns = `MoveD;
    `MoveU : ns = `CheckEnd;
    `MoveR : ns = `CheckEnd;
    `MoveL : ns = `CheckEnd;
    `MoveD : ns = `CheckEnd;
    `MoveBack : ns = (SQ_Empty) ? `Fail : 
		     (topValueSQ == `UP) ? `BackU :
		     (topValueSQ == `RIGHT) ? `BackR :
		     (topValueSQ == `LEFT) ? `BackL :
		     (topValueSQ == `DOWN) ? `BackD : `GetReady;
    `BackU : ns = `CheckMoveR;
    `BackR : ns = `CheckMoveL;
    `BackL : ns = `CheckMoveD;
    `BackD : ns = `MoveBack;
    `CheckEnd : ns = (poseX == 4'b1111 && poseY == 4'b1111) ? `End : `CheckMoveU;
    `Fail : ns = `Fail;
    `End : ns = (Run) ? `Running : `End;   
    `Running : ns = (SQ_Done) ? `End : `Running;
    default : ns = `GetReady;
  endcase
end


always @(ps)
begin
  ldX=0; ldY=0; IncX=0; IncY=0; DecX=0; DecY=0; RD=0; WR=0; mapInput=0;
  pushSQ=0; popSQ=0; SQ_Input=0; Fail=0; Done=0; SQ_Read=0; selMove=0; rstDP=0;
	
  case (ps)
    `GetReady : begin rstDP=1; end
    `CheckMoveU : begin DecX=1; RD=1; end
    `CheckMoveR : begin IncY=1; RD=1; end
    `CheckMoveL : begin DecY=1; RD=1; end
    `CheckMoveD : begin IncX=1; RD=1; end
    `MarkU : begin WR=1; mapInput=1; end
    `MarkR : begin WR=1; mapInput=1; end
    `MarkL : begin WR=1; mapInput=1; end
    `MarkD : begin WR=1; mapInput=1; end
    `MoveU : begin DecX=1; ldX=1; SQ_Input=`UP; pushSQ=1; end
    `MoveR : begin IncY=1; ldY=1; SQ_Input=`RIGHT; pushSQ=1; end
    `MoveL : begin DecY=1; ldY=1; SQ_Input=`LEFT; pushSQ=1; end
    `MoveD : begin IncX=1; ldX=1; SQ_Input=`DOWN; pushSQ=1; end
    `CheckEnd : ;
    `MoveBack : ;
    `BackU : begin IncX=1; ldX=1; popSQ=1; end
    `BackR : begin DecY=1; ldY=1; popSQ=1; end
    `BackL : begin IncY=1; ldY=1; popSQ=1; end
    `BackD : begin DecX=1; ldX=1; popSQ=1; end
    `Fail : Fail=1;
    `End : Done=1;
    `Running : begin SQ_Read=1; selMove=1; end
  endcase
end

endmodule




