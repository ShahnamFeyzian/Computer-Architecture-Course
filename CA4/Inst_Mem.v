
module Inst_Mem(address, inst);

input wire[31:0] address;
output wire[31:0] inst;

reg [0:31] memory [16000:0]; 

initial begin
    $readmemh("inst.dat" , memory) ;
end


assign inst = memory[address];

endmodule
