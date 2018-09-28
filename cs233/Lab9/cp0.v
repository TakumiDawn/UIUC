`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here
    wire [31:0] user_status, status_reg, cause_reg, decoderOut;
    wire exception_level, decoderOut_12, decoderOut_14, excep_lev_reset, EPC_reg_enable;
    wire [29:0] m1_out;

    //STATUS_REGISTER
    assign status_reg[31:0] = {16'b0,user_status[15:8],6'b0,exception_level,user_status[0]};
    //CAUSE_REGISTER
    assign cause_reg[31:0] = {16'b0,TimerInterrupt,15'b0};

    //cp0
    register user_stat(user_status, wr_data, clock, decoderOut_12, reset);

    dffe excep_lev(exception_level, 1'b1, clock, TakenInterrupt, excep_lev_reset);
    assign excep_lev_reset = reset | ERET;

    mux2v #(30) m1(m1_out, wr_data[31:2], next_pc, TakenInterrupt);
    register #(30) EPC_reg(EPC, m1_out, clock, EPC_reg_enable, reset);
    assign EPC_reg_enable = decoderOut_14 | TakenInterrupt;

    decoder32 dec_MTX0(decoderOut, regnum, MTC0);
    assign decoderOut_12 = decoderOut[12];
    assign decoderOut_14 = decoderOut[14];

    mux32v m2(rd_data, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, status_reg, cause_reg, {EPC,2'b0}, 0,
                      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, regnum);

    assign TakenInterrupt = ( (cause_reg[15]&status_reg[15]) & (~status_reg[1]&status_reg[0]));

endmodule
