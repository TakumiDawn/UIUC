module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here
    wire TimerRead, TimerWrite, Acknowledge, il_reset, il_enable;
    wire [31:0] interrupt_cycle_out, cycle_counter_out,cycle_counter_in;

    assign TimerRead = (address == 32'hffff001c) & MemRead;
    assign TimerWrite = (address == 32'hffff001c) & MemWrite;
    assign Acknowledge = (address == 32'hffff006c) & MemWrite;

    assign TimerAddress = (address == 32'hffff001c) | (address == 32'hffff006c);

    register #(,32'hffffffff) interrupt_cycle(interrupt_cycle_out, data, clock, TimerWrite, reset);
    register cycle_counter(cycle_counter_out, cycle_counter_in, clock,  1'b1, reset);
    alu32 cycle_counter_alu(cycle_counter_in, , , `ALU_ADD, cycle_counter_out, 32'b1);

    assign il_enable =  cycle_counter_out == interrupt_cycle_out;
    assign il_reset = Acknowledge | reset;
    dffe interrupt_line(TimerInterrupt, 1'b1, clock, il_enable, il_reset);

    tristate tri_buff(cycle, cycle_counter_out, TimerRead);
    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
endmodule
