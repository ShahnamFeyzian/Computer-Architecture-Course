

module SC_Datapath (clk, imm_src, reg_wr, alu_control, mem_wr, pc_src, alu_src, pc_inp_src, reg_src,
    zero , func7, func3, op , alu_sign);

    input [0:0] clk, reg_wr, mem_wr, pc_src, alu_src, pc_inp_src ;
    input [1:0] reg_src ;
    input [2:0] alu_control, imm_src ;

    output [0:0] zero , alu_sign;
    output [6:0] func7, op ; 
    output [2:0] func3 ;

    wire [31:0] pcOut , pcIn , instruction , ieOut , pcSrcA , pcSrcB , pcInp , Rd1 , Rd2 , aluB , aluOut , memOut , 
    regWd ;
    reg[31:0] PC_adder_val = 32'd4;

    Program_Counter SC_PC(.clk(clk), .in(pcIn), .out(pcOut));
    Inst_Mem SC_IM(.address(pcOut), .inst(instruction));
    Imm_Ext SC_IE(.v_in(instruction), .imm_source(imm_src), .v_out(ieOut));
    Reg_File SC_RF(.clk(clk), .wr_en(reg_wr), .a1(instruction[19:15]), .a2(instruction[24:20]),
    .a3(instruction[11:7]), .wd(regWd), .rd1(Rd1), .rd2(Rd2));
    ALU SC_ALU(.A(Rd1), .B(aluB) , .op(alu_control), .v_out(aluOut), .z(zero));
    Data_Mem SC_MEM(.clk(clk), .wr_en(mem_wr), .address(aluOut), .data_in(Rd2), .data_out(memOut));
    Adder SC_IE_ADDER(.A(pcOut) , .B(ieOut) , .out(pcSrcA));
    Adder SC_PC_ADDER(.A(pcOut) , .B(PC_adder_val) , .out(pcSrcB));
    MUX_2to1_32bit SC_ALU_SRC(.i1(Rd2), .i2(ieOut), .sel(alu_src), .out(aluB));
    MUX_2to1_32bit SC_PC_SRC(.i1(pcSrcA), .i2(pcSrcB), .sel(pc_src), .out(pcInp));
    MUX_2to1_32bit SC_PC_INP(.i1(pcInp), .i2(aluOut), .sel(pc_inp_src), .out(pcIn));
    MUX_4to1_32bit SC_REG_SRC(.i1(aluOut), .i2(memOut), .i3(pcSrcB), .i4(ieOut), .sel(reg_src), .out(regWd));

    assign func7 = instruction[31:25] ;
    assign func3 = instruction[14:12] ;
    assign op = instruction[6:0] ;
    assign alu_sign = aluOut[31] ;

endmodule
