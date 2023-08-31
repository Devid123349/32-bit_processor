`timescale 1ns / 1ps

module control(output reg [31:0] ID_EX_IR, output reg [3:0] ctrl,
input [31:0] inst,output reg [4:0] regA_num,reg [4:0] regB_num,reg [4:0] destreg_num,input clock);
always@(*)
begin
ID_EX_IR <= inst ;
regA_num <= inst[19:15]; //rs1
regB_num <= inst[24:20]; //rs2
destreg_num <= inst[11:7]; //rd
end
parameter ADD = 10'b0000001, SUB = 10'b0010001, SLL = 10'b0000011,
SRL = 10'b0010011, SRA = 10'b0100011, SLT = 10'b0000111,
SLTU= 10'b0010111, XOR = 10'b0001111, OR = 10'b0011111,
AND = 10'b0101111; //func opcode

always@(posedge clock)
begin
    case({inst[3:0], inst[14:12]}) //func opcode
    ADD : ctrl = 4'h1;
    SUB : ctrl = 4'h2;
    SLL : ctrl = 4'h3;
    SRL : ctrl = 4'h4;
    SRA : ctrl = 4'h5;
    SLT : ctrl = 4'h6;
    SLTU: ctrl = 4'h7;
    XOR : ctrl = 4'h8;
    OR : ctrl = 4'h9;
    AND : ctrl = 4'ha;
    default : ctrl = 4'h0;
    endcase
end
endmodule
