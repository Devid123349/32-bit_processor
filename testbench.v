`timescale 1ns / 1ps
module testbench();
reg [31:0] inst;
reg clock;
wire [31:0] out;
integer k;
initial begin
clock = 0;
for(k=0;k<32;k=k+1)
DUT.regbank.regfile[k] = 32'h00000000;
end
always #10 clock = ~clock;
processor DUT(inst,out,clock);

initial begin
    DUT.regbank.regfile[1] = 32'h0000000F;
    DUT.regbank.regfile[2] = 32'h0000000C;
    DUT.regbank.regfile[3] = 32'hFF0000FF;
    DUT.regbank.regfile[4] = 32'h70000000;
    DUT.regbank.regfile[5] = 32'hF0000000;
    DUT.regbank.regfile[6] = 32'h00000004;
    #20 inst = {7'h00,5'h02,5'h01,3'h00,5'h07,7'h01} ;//ADD
    #20 inst = {7'h00,5'h02,5'h01,3'h01,5'h08,7'h01} ;//SUB
    #20 inst = {7'h00,5'h06,5'h03,3'h00,5'h09,7'h03} ;//SLL
    #20 inst = {7'h00,5'h06,5'h03,3'h01,5'h0a,7'h03} ;//SRL
    #20 inst = {7'h00,5'h06,5'h03,3'h02,5'h0b,7'h03} ;//SRA
    #20 inst = {7'h00,5'h01,5'h04,3'h00,5'h0c,7'h07} ;//SLT
    #20 inst = {7'h00,5'h04,5'h01,3'h01,5'h0d,7'h07} ;//SLTU
    #20 inst = {7'h00,5'h02,5'h01,3'h00,5'h0e,7'h0f} ;//XOR
    #20 inst = {7'h00,5'h02,5'h01,3'h01,5'h0f,7'h0f} ;//OR
    #20 inst = {7'h00,5'h02,5'h01,3'h02,5'h10,7'h0f} ;//AND
    #40 $finish;
end
endmodule