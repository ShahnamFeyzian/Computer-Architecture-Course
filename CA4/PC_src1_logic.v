
module PC_src1_logic(clk, op, f3, zero, sign, pc_src1);

input wire[0:0] zero, sign, clk;
input wire[2:0] f3;
input wire[6:0] op;
output wire[0:0] pc_src1;


wire [0:0] internal_pc_src1;
reg [1:0] counter = 2'b0;

always @(posedge clk) counter <= (counter < 2'b10) ? counter+1 : counter;

assign internal_pc_src1 =    (op==7'b1101111) ? 1'b0  : //jal
		    (op==7'b1100011) ?  (f3==3'b000 && zero==1'b1) ? 1'b0 : //B_T
			  		(f3==3'b001 && zero==1'b0) ? 1'b0 :
					(f3==3'b100 && sign==1'b1) ? 1'b0 :
					(f3==3'b101 && sign==1'b0) ? 1'b0 : 1'b1
		    : 1'b1; 

assign pc_src1 = (counter > 2'b01) ? internal_pc_src1 : 1'b1;

endmodule
