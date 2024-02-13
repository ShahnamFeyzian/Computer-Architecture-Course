
module Memory(clk, wr_en, wd, address, v_out);

input wire[0:0] clk, wr_en;
input wire[31:0] address, wd;
output wire[31:0] v_out;

reg [0:31] memory [1023:0]; 

initial begin
    $readmemh("Inst.data" , memory) ;
end

always @(posedge clk) begin

if(wr_en) memory[address] = wd;

end

assign v_out = memory[address];

endmodule