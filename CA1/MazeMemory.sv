
module MazeMemory (x , y , wr , rd , rst , clk , data_in , data_out);
    
input wire [3:0] x, y;
input wire [0:0] wr, rd, rst, clk, data_in;
output wire[0:0] data_out;

reg [0:15] mem [15:0] ; 

initial begin
    $readmemh("Mem.data" , mem) ;
end

always @(posedge rst) begin 
    $readmemh("Mem.data" , mem) ; 
end

always @(posedge clk) begin 
    if (wr)begin 
       mem[x][y] <= data_in ;
    end 
end

assign data_out = (rd) ? mem[x][y] : 1'bz;

endmodule
