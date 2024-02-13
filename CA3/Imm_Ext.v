
module Imm_Ext(v_in, imm_source, v_out);

input wire[2:0] imm_source;
input wire[31:0] v_in;
output wire[31:0] v_out;

assign v_out = (imm_source==3'b000) ? {{20{v_in[31]}}, v_in[31:20]} : //I_T
(imm_source==3'b001) ? {{20{v_in[31]}}, v_in[31:25], v_in[11:7]} : //S_T
(imm_source==3'b010) ? {{19{v_in[31]}}, v_in[31], v_in[7], v_in[30:25], v_in[11:8], 1'b0} : //B_T
(imm_source==3'b011) ? {{12{v_in[31]}}, v_in[19:12], v_in[20], v_in[30:21], 1'b0} : //J_T
(imm_source==3'b100) ? {v_in[31:12], 12'b0} : 32'bz; //U_T

endmodule
