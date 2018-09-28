module test;
    reg       clk = 0, enable = 0, reset = 1;  // start by reseting the register file

    /* Make a regular pulsing clock with a 10 time unit period. */
    always #5 clk = !clk;

    reg [4:0] regnum;
    reg [31:0] d;

    wire [31:0] q;
    initial begin
        $dumpfile("register.vcd");
        $dumpvars(0, test);
        # 10  reset = 0;      // stop reseting the register

        # 10
          // write 88 to the register 2
          enable = 1;
          regnum = 2;
          d = 88;

        # 10
          // try writing to the register when its disabled
          enable = 0;
	        regnum = 2;
	        d = 89;

        // Add your own testcases here!
        # 10
          // write 101 to the register 31
          enable = 1;
          d = 101;//0x 65

        # 10
          // try writing to the register when its disabled
          enable = 0;
	        d = 65;//0x 41

        # 10 reset = 1; //test reset

        # 10 $finish;
    end

    initial begin
    end

    register reg1(q, d, clk, enable, reset);

endmodule // test
