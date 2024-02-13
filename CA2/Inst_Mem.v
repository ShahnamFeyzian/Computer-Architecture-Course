
module Inst_Mem(address, inst);

input wire[31:0] address;
output wire[31:0] inst;

reg [0:31] memory [1023:0]; 

initial begin
    $readmemh("Inst.data" , memory) ;
end


assign inst = memory[address];

endmodule
