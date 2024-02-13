
module Data_Mem(clk, wr_en, address, data_in, data_out);

input wire[0:0] clk, wr_en;
input wire[31:0] address, data_in;
output wire[31:0] data_out;

reg [0:31] memory [1600:0]; 

initial begin
    $readmemh ("data.dat" , memory) ;
end

always @(posedge clk) begin

if(wr_en) memory[address] = data_in;

end

assign data_out = memory[address];

endmodule
