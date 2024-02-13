`timescale 1ns/1ns

module ALU_TB();

reg [31:0] A, B;
reg [2:0] op;

wire [31:0] v_out;
wire [0:0] z;

ALU alu(.A(A), .B(B), .op(op), .v_out(v_out), .z(z));


initial begin

A = 32'd 17; B = 32'd17; op = 3'b001;

#100 A = 32'd 905; B = 32'd267; op = 3'b000;

#100 A = 32'd 77738293; B = 32'd11738; op = 3'b010;

#100 op = 3'b011;

#100 op = 3'b100;

#100 op = 3'b101;

#100 A = 32'd289; B = 32'd1168;

#100 $stop;
end

endmodule
