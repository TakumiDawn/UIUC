module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire w1, w2, w3, w4, w5, w6,w7,w8,w9;

   or ov(valid, w1,w2,w3,w4,w5,w6,w7,w8,w9,w0);
   or o3(number[3],w8,w9);
   or o2(number[2],w4,w5,w6,w7);
   or o1(number[1],w2,w3,w5,w6);
   or o0(number[0],w1,w3,w5,w7,w9);

   and a1(w1, a,d);
   and a2(w2, b,d);
   and a3(w3, c,d);
   and a4(w4, b,e);
   and a5(w5, a,e);
   and a6(w6, c,e);
   and a7(w7, a,f);
   and a8(w8, b,f);
   and a9(w9, c,f);
   and a0(w0, b,g);


endmodule // keypad
