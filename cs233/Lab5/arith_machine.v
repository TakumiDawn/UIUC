// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC;
    wire [31:0] out;
    wire [31:0] nextPC;
    wire [31:0] B;
    wire [31:0] rsData;
    wire [31:0] rtData;
    wire [4:0] rsNum;
    wire [4:0] rtNum;
    wire [4:0] rdNum;
    wire [31:0] rdData;
    wire rdWriteEnable;
    wire rd_src;
    wire alu_src2;
    wire [2:0] alu_op;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this moduleh = 32;
    // or the test bench will break
    instruction_memory im(inst[31:0], PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData, rtData,
                    inst[25:21], inst[20:16], rdNum, rdData,
                    rdWriteEnable, clock, reset);

    /* add other modules */
    alu32 pcplus4(nextPC,,,, PC, 32'h4, `ALU_ADD);
    mips_decode decoder1(alu_op, rd_src, alu_src2, rdWriteEnable, except, inst[31:26], inst[5:0]);
    mux2v #(5) m1(rdNum, inst[15:11], inst[20:16], rd_src);
    mux2v m2(B[31:0],rtData,out,alu_src2);
    alu32 mainalu(rdData,,,, rsData, B[31:0], alu_op);
    //sign extender
    assign out[15:0] = inst[15:0];
    assign out[31:16] = {16{inst[15]}};

endmodule // arith_machine
