
module ALU(A, B , op, v_out, z);

input wire [2:0] op;
input wire [31:0] A, B;
output wire [31:0] v_out;
output wire [0:0] z; 

assign v_out =  (op==3'b000) ? A + B :
		(op==3'b001) ? A + ~B + 32'd1 : //sub
		(op==3'b010) ? A & B :
		(op==3'b011) ? A | B :
		(op==3'b100) ? A ^ B :
		(op==3'b101) ? (A < B)?32'd1:32'b0 : 32'bz;

assign z = ~(|{v_out});

endmodule