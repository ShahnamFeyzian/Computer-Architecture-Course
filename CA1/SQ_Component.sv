

module SQ_Component(Din, pushSignal, popSignal, readSignal, rst, clk, isEmpty, isFull, stackData,
		    done, qeueuData);

input wire [1:0] Din;
input wire [0:0] pushSignal, popSignal, readSignal, rst, clk;
output reg [0:0] isEmpty=1, isFull=0, done;
output reg [1:0] stackData, qeueuData;

reg [1:0] mems [0:255];
reg [7:0] ptrS = 8'b0, ptrQ = 8'b0;


always @(posedge clk, posedge rst) begin

if(rst) begin ptrS<=8'b0; isEmpty<=1; isFull<=0; ptrQ<=8'b0; end

else begin

  if(pushSignal && !isFull) 
    begin
      if(isEmpty) begin mems[0] = Din; isEmpty = 0; end
      else begin ptrS = ptrS+1; mems[ptrS] = Din; isFull = (ptrS==8'd255) ? 1 : 0; end
    end  
  else if(popSignal && !isEmpty)
    begin
      isFull = 0;
      if(ptrS == 8'b0) isEmpty = 1;
      else ptrS = ptrS-1;
    end
  if(readSignal)
    begin
      if(done) begin ptrQ<=8'b0; end
      else ptrQ <= ptrQ + 1;
    end
end
 
end

assign done = (ptrQ == ptrS) ? 1 : 0;
assign stackData = mems[ptrS];
assign qeueuData = mems[ptrQ];

endmodule