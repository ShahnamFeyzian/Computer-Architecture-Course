
module PL_Controller(op, f3, f7, reg_wr, imm_source, ALU_source, 
			ALU_control, mem_wr, reg_source, pc_source2);

input wire[2:0] f3;
input wire[6:0] f7, op;

output wire[0:0] reg_wr, ALU_source, mem_wr, pc_source2;
output wire[1:0] reg_source;
output wire[2:0] ALU_control, imm_source;


//reg_wr => sw and B_Types is zero else one
assign reg_wr = (op==7'b0100011 || op==7'b1100011 || op==7'b0) ? 1'b0 : 1'b1; 


//imm_source => looking at instraction type
assign imm_source = (op==7'b0000011 || op==7'b0010011 || op==7'b1100111) ? 3'b000 : //I_T
		    (op==7'b0100011) ? 3'b001 : //S_T
		    (op==7'b1100011) ? 3'b010 : //B_T
		    (op==7'b1101111) ? 3'b011 : //J_T
		    (op==7'b0110111) ? 3'b100 : 3'bz; // U_T 


//ALU_source => R_T and B_T:0, I_T and S_T:1, U_T and J_T:dont care
assign ALU_source = (op==7'b0110011 || op==7'b1100011) ? 1'b0 : 1'b1;


//mem_wr => only on sw
assign mem_wr = (op==7'b0100011) ? 1'b1 : 1'b0;


//jal and jalr => 10 ,,, I_T and R_T => 00 ,,, sw and B_T => dont care
assign reg_source = (op==7'b0000011) ? 2'b01 : //lw
		    (op==7'b0110111) ? 2'b00 : //lui
		    (op==7'b1100111 || op==7'b1101111) ? 2'b10 : 2'b00;



//pc_source2 => only on jalr
assign pc_source2 = (op==7'b1100111) ? 1'b1 : 1'b0;


assign ALU_control = (op==7'b0000011 || op==7'b0110111) ? 3'b000 : //lw
		     (op==7'b1100111) ? 3'b000 : //jalr 
		     (op==7'b0100011) ? 3'b000 : //sw
		     (op==7'b1100011) ? 3'b001 : //B_T
		     (op==7'b0110011 && f7==7'b0100000) ? 3'b001 : //sub
		     (f3==3'b000) ? 3'b000 : //add
		     (f3==3'b111) ? 3'b010 : //and
		     (f3==3'b110) ? 3'b011 : //or
		     (f3==3'b010) ? 3'b101 : //slt
		     (f3==3'b100) ? 3'b100 : 3'bz; //xor	
endmodule
