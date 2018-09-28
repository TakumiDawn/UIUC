module blackbox_test;
  reg a, y, o;
  wire n;
  blackbox  bb1(n, a, y, o);

initial begin
  $dumpfile("bb1.vcd");
  $dumpvars(0,blackbox_test);

  a = 0; y = 0; o = 0; #10;
  a = 0; y = 0; o = 1; #10;
  a = 0; y = 1; o = 0; #10;
  a = 0; y = 1; o = 1; #10;
  a = 1; y = 0; o = 0; #10;
  a = 1; y = 0; o = 1; #10;
  a = 1; y = 1; o = 0; #10;
  a = 1; y = 1; o = 1; #10;

  $finish;
end

initial
  $monitor("At time %2t, a = %d, y= %d, o =%d, n = %d", $time, a, y, o, n);

endmodule // blackbox_test
