// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// writeenable (output) - should a new value be captured by the register file
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_op, rd_src, alu_src2, writeenable, except, opcode, funct);
    output [2:0] alu_op;
    output       rd_src, alu_src2, writeenable, except;
    input  [5:0] opcode, funct;

    wire inst_addi = opcode == `OP_ADDI;
    wire inst_andi = opcode == `OP_ANDI;
    wire inst_ori = opcode == `OP_ORI;
    wire inst_xori = opcode == `OP_XORI;
    wire inst_add = (opcode == `OP_OTHER0 ) & (funct == `OP0_ADD);
    wire inst_sub = (opcode == `OP_OTHER0 ) & (funct == `OP0_SUB);
    wire inst_and = (opcode == `OP_OTHER0 ) & (funct == `OP0_AND);
    wire inst_or  = (opcode == `OP_OTHER0 ) & (funct == `OP0_OR);
    wire inst_nor = (opcode == `OP_OTHER0 ) & (funct == `OP0_NOR);
    wire inst_xor = (opcode == `OP_OTHER0 ) & (funct == `OP0_XOR);

    assign alu_op = inst_add ? 3'b010 :
    inst_sub ? 3'b011 :
    inst_and ? 3'b100 :
    inst_or ? 3'b101 :
    inst_nor ? 3'b110 :
    inst_xor ? 3'b111 :
    inst_addi ? 3'b010 :
    inst_andi ? 3'b100 :
    inst_ori ? 3'b101 :
    inst_xori ? 3'b111:
    3'b000;

    assign rd_src = inst_add ? 0 :
    inst_sub ? 0 :
    inst_and ? 0 :
    inst_or ? 0 :
    inst_nor ? 0 :
    inst_xor ? 0 :
    inst_addi ? 1 :
    inst_andi ? 1 :
    inst_ori ? 1 :
    inst_xori ? 1:
    0;
    assign alu_src2 = inst_add ? 0 :
    inst_sub ? 0 :
    inst_and ? 0 :
    inst_or ? 0 :
    inst_nor ? 0 :
    inst_xor ? 0 :
    inst_addi ? 1 :
    inst_andi ? 1 :
    inst_ori ? 1 :
    inst_xori ? 1:
    0;

    assign writeenable = inst_add | inst_sub | inst_and |inst_or |inst_nor| inst_xor | inst_addi |inst_andi|inst_ori|inst_xori;
    assign except = ~writeenable;



endmodule // mips_decode
