module alu1_test;
    // exhaustively test your 1-bit ALU by adapting mux4_tb.v
    reg A = 0;
    always #1 A = !A;
    reg B = 0;
    always #2 B = !B;
    reg carryin = 0;
    always #4 carryin = !carryin;

    reg [2:0] control = 2; // start from 2

    initial begin
        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

        // control is initially 0
        //# 8 control = 1; // undefiend
        //# 8 control = 2; 
        # 8 control = 3; // wait 8 time units and then set it to 3
        # 8 control = 4; // wait 8 time units and then set it to 4
        # 8 control = 5; // wait 8 time units and then set it to 5
        # 8 control = 6; // wait 8 time units and then set it to 6
        # 8 control = 7; // wait 8 time units and then set it to 7
        # 8 $finish; // wait 8 time units and then end the simulation
    end

    wire out, carryout;
    alu1 alu_1(out, carryout, A, B, carryin, control);
endmodule
