
module palindrome_control(palindrome, done, select, load, go, a_ne_b, front_ge_back, clock, reset);
	output palindrome, done, select, load;
	input go, a_ne_b, front_ge_back;
	input clock, reset;


	wire sGarbage, sStart, sCheck, sDoneR, sDoneA;

	wire sGarbage_next = reset | (~sStart & ~sCheck & ~sDoneR & ~sDoneA);
	wire sStart_next = (sGarbage & go & ~reset)|(sDoneR & go & ~reset)|(sDoneA & go & ~reset)|(sStart & go &~reset);

	wire sCheck_next = (sStart & ~a_ne_b & ~reset & ~go) | (sCheck & ~front_ge_back & ~a_ne_b & ~reset);
	wire sDoneR_next = (sCheck & a_ne_b & ~reset) | (sDoneR & ~go & ~reset) | (sStart & ~go & a_ne_b & ~reset);
	wire sDoneA_next = (sCheck & front_ge_back & ~reset) | (sDoneA & ~go & ~reset);

	dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe fsStart(sStart, sStart_next, clock, 1'b1, 1'b0);

	dffe fsCheck(sCheck, sCheck_next, clock, 1'b1, 1'b0);
	dffe fsDoneR(sDoneR, sDoneR_next, clock, 1'b1, 1'b0);
	dffe fsDoneA(sDoneA, sDoneA_next, clock, 1'b1, 1'b0);

assign palindrome = sDoneA;
assign done = sDoneA | sDoneR;
assign select = sCheck;
assign load = sStart | sCheck;

endmodule // palindrome_control