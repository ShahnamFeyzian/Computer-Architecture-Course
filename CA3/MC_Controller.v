
`define R_T  7'b0110011
`define I_T  7'b0010011
`define LW   7'b0000011
`define JALR 7'b1100111
`define SW   7'b0100011
`define JAL  7'b1101111
`define U_T  7'b0110111
`define B_T  7'b1100011

module MC_Controller(clk, op, f7, f3, z, s, PC_update, Adr_src, mem_wr, IR_wr,
imm_src, reg_wr, A_src, B_src, ALU_op, result_src);

input wire[0:0] clk, z, s;
input wire[2:0] f3;
input wire[6:0] f7, op;
output reg[0:0] PC_update, Adr_src, mem_wr, IR_wr, reg_wr;
output reg[1:0] A_src, B_src, result_src;
output reg[2:0] imm_src, ALU_op;


parameter[3:0]  IF=4'b0000, ID=4'b0001, B1=4'b0010, R1=4'b0011, I1=4'b0100,
		U1=4'b0101, sw1=4'b0110, lw1=4'b0111, jal=4'b1000, jalr=4'b1001,
		RegWrite=4'b1010, sw2=4'b1011, lw2=4'b1100, jump=4'b1101, lw3=4'b1110;	

reg [3:0] ps=IF, ns=IF;

always @(posedge clk) ps <= ns;

always @(ps, z, s, f3, f7, op) begin
case(ps)
  IF : ns = ID;
  ID : ns = (op==`R_T) ? R1 :
	    (op==`B_T) ? B1 :
	    (op==`I_T) ? I1 :
	    (op==`U_T) ? U1 :
	    (op==`SW) ? sw1 :
 	    (op==`LW) ? lw1 :
	    (op==`JAL) ? jal:
	    (op==`JALR) ? jalr : IF;
  R1   : ns = RegWrite;
  I1   : ns = RegWrite;
  U1   : ns = RegWrite;
  sw1  : ns = sw2;
  sw2  : ns = IF;
  lw1  : ns = lw2;
  lw2  : ns = lw3;
  lw3  : ns = IF;
  jal  : ns = jump;
  jalr : ns = jump;
  jump : ns = RegWrite;
endcase
end

always @(ps, z, s, f3, f7, op) begin

PC_update=1'b0; Adr_src=1'b0; mem_wr=1'b0; IR_wr=1'b0; reg_wr=1'b0;
A_src=2'b0; B_src=2'b0; result_src=2'b0;
imm_src=3'b0; ALU_op=3'b0;

if(ps == IF) begin 
  Adr_src = 1'b0; 
  IR_wr = 1'b1; 
  A_src = 2'b00; 
  B_src = 2'b10; 
  ALU_op = 3'b000;
  result_src = 2'b10; 
  PC_update = 1'b1; 
end
else if(ps == ID) begin
  A_src = 2'b01;
  B_src = 2'b01;
  ALU_op = 3'b000;
  imm_src = 3'b010; 
end
else if(ps == B1) begin
  A_src = 2'b10;
  B_src = 2'b00;
  ALU_op = 3'b001;
  result_src = 2'b00;
  PC_update = (f3==3'b000 && z==1'b1) || (f3==3'b001 && z==1'b0) ||
	      (f3==3'b100 && s==1'b1) || (f3==3'b101 && s==1'b0);
end
else if(ps == R1) begin
  A_src = 2'b10;
  B_src = 2'b00;
  ALU_op = (f7==7'b0100000) ? 3'b001 :
	   (f3==3'b000) ? 3'b000 :
	   (f3==3'b111) ? 3'b010 :
	   (f3==3'b110) ? 3'b011 :
	   (f3==3'b010) ? 3'b101 :
	   (f3==3'b100) ? 3'b100 : 3'bz;
end
else if(ps == I1) begin
  A_src = 2'b10;
  B_src = 2'b01;
  imm_src = 3'b000;
  ALU_op = (f3==3'b000) ? 3'b000 :
	   (f3==3'b111) ? 3'b010 :
	   (f3==3'b110) ? 3'b011 :
	   (f3==3'b010) ? 3'b101 :
	   (f3==3'b100) ? 3'b100 : 3'bz;
end
else if(ps == U1) begin
  A_src = 2'b11;
  B_src = 2'b01;
  imm_src = 3'b100;
  ALU_op = 3'b000;
end
else if(ps == RegWrite) begin 
  result_src = 2'b00;
  reg_wr = 1'b1;
end
else if(ps == sw1) begin
  A_src = 2'b11;
  B_src = 2'b01;
  imm_src = 3'b001;
  ALU_op = 3'b000;
end
else if(ps == sw2) begin
  result_src = 2'b00;
  Adr_src = 1'b1;
  mem_wr = 1'b1;
end
else if(ps == lw1) begin
  imm_src = 3'b000;
  A_src = 2'b10;
  B_src = 2'b01;
  ALU_op = 3'b000;
end
else if(ps == lw2) begin
  result_src = 2'b00;
  Adr_src = 1'b1;
end
else if(ps == lw3) begin
  result_src = 2'b01;
  reg_wr = 1'b1;
end
else if(ps == jal) begin
  A_src = 2'b01;
  B_src = 2'b01;
  imm_src = 3'b011;
  ALU_op = 3'b000;
end
else if(ps == jalr) begin
  A_src = 2'b10;
  B_src = 2'b01;
  imm_src = 3'b000;
  ALU_op = 3'b000;
end 
else if(ps == jump) begin
  result_src = 2'b00;
  PC_update = 1'b1;
  A_src = 2'b01;
  B_src = 2'b10;
  ALU_op = 3'b000;
end


end

endmodule
