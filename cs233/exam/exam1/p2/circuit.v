// Design a circuit that divides a 4-bit signed binary number (in)
// by 3 to produce a 3-bit signed binary number (out).  Note that
// integer division rounds toward zero for both positive and negative
// numbers (e.g., -5/3 is -1).

module sdiv3(out, in);
   output [2:0] out;
   input  [3:0]	in;

//   assign out[2] = (in[3]==1)& ~( ~(in[2]^in[1])& (in[2]&in[1]));
//   assign out[1] = ((in[3]==1)& ~( ~(in[2]^in[1])& (in[2]&in[1])) ) | ((in[3]==0)& ~(in[2]^in[1])) ;
   assign out[0] = (in[3:0]== 4'b1011)|(in[3:0]== 4'b1100)|(in[3:0]== 4'b1101)|(in[3:0]== 4'b0011)|(in[3:0]== 4'b0100)|(in[3:0]== 4'b0101);
   assign out[1] = (in[3:0]== 4'b1011)|(in[3:0]== 4'b1100)|(in[3:0]== 4'b1101)|(in[3:0]== 4'b1000)|(in[3:0]== 4'b1001)|(in[3:0]== 4'b1010)|(in[3:0]== 4'b0110)|(in[3:0]== 4'b0111);
   assign out[2] = (in[3:0]== 4'b1011)|(in[3:0]== 4'b1100)|(in[3:0]== 4'b1101)|(in[3:0]== 4'b1000)|(in[3:0]== 4'b1001)|(in[3:0]== 4'b1010);

endmodule // sdiv3
