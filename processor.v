`timescale 1ns / 1ps
module processor(input [31:0] inst, output [31:0] out,input clock);
wire [4:0] regA_num, regB_num, destreg_num;
wire [3:0] ctrl;
wire [31:0] regA, regB,ID_EX_IR,ALUout;
control CTL (ID_EX_IR,ctrl,inst,regA_num,regB_num,destreg_num,clock);
RegBank regbank(.rd1(regA),.rd2(regB),.sr1(regA_num),.sr2(regB_num),
.wr(ALUout),.dr(destreg_num),.clock(clock));
ALU ALU (regA, regB, ctrl, ALUout);
assign out = ALUout;
endmodule
module RegBank(rd1,rd2,wr,sr1,sr2,dr,clock);
input [4:0]sr1,sr2,dr;
input [31:0] wr;
input clock;
output reg [31:0] rd1,rd2;
reg [31:0] regfile[0:31];
always @(*)
begin
rd1 <= regfile[sr1];
rd2 <= regfile[sr2];
regfile[dr] <= wr;
end
endmodule
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
module ALU(input [31:0] regA, input [31:0] regB, input [3:0] ctrl,
output reg [31:0] ALUout);
always@(*)
begin
case(ctrl) //func opcode
4'h1 : ALUout = regA + regB ;
4'h2 : ALUout = regA - regB ;
4'h3 : ALUout = regA << regB[4:0] ;
4'h4 : ALUout = regA >> regB[4:0] ;
4'h5 : ALUout = $signed(regA) >>> regB[4:0];
4'h6 : ALUout = ($signed(regA) < $signed(regB))? 32'h00000001 : 32'h00000000 ;
4'h7 : ALUout = (regA < regB) ?32'h00000001 : 32'h00000000;
4'h8 : ALUout = regA ^ regB ;
4'h9 : ALUout = regA | regB;
4'ha : ALUout = regA & regB;
default : ALUout = 32'hxxxxxxxx;
endcase
end
endmodule