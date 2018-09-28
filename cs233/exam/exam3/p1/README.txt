Q3 is a data path modification problem in Verilog.

We've provided the following files:

        prompt.txt              (a description of what instruction
                                 to implement)

        machine.v               (a single-cycle machine for you to
                                 modify to add a new instruction)

        mips_defines.v          (Verilog components; you shouldn't
        modules.v                edit these, as you won't submit
        mux_lib.v                them.)
        rom.v

        machine_tb.v            (a standard testbench)

        Makefile

        test.s                  (a test that includes the instruction
        test.data.dat            that you are supposed to implement.)
        test.text.dat

        regression.s            (a regression test consisting of the
        regression.data.dat      instructions that the machine already
        regression.text.dat      implements to help you know if you
                                 broke the existing functionality.)

        custom.s                (a file for you to write your own test
        spim-datapath            case, if you wish, and programs to
        QtSpim-datapath          assemble and run said test case.)

        MIPSGreenSheet.pdf      (for your reference)

My suggestion of how to solve this problem.

 1. read the prompt and figure out what the desired outputs of the test.s
    input are.  You need to understand what you are trying to implement.
 
 2. download spim-vasm and QtSpim-datapath (you only need to do this once):
            ./download-spim
 
    you can then use QtSpim-datapath to run test.s and verify your
    understanding of the instruction's desired behavior:
            ./QtSpim-datapath -file test.s
 
 3. design the circuit on paper
 
 4. make a copy of the original 'machine.v' (and any other Verilog file
    that you change), so you can later diff your modified version with
    it, if you end up breaking anything.  You could use svn or git to make
    this copy, if you are particularly awesome.
 
 5. run:
            make regression
            make > regress
 
    this will run the base Verilog against the regression inputs and save
    the result in a file called 'regress'.  This way you know what the
    outputs of the regression tests should be and when you are done, you
    can verify that you didn't break anything.
 
 6. modify 'machine.v' to implement the changes you drew on paper.
 
 7. run:
            make test
            make
 
    this runs your Verilog against the test input that has your instruction.
    If the results are not what you expected them to be from step 1, then
    I suggest firing up gtkwave to trace down your errors, especially if
    you are getting X's or Z's in register values.  Start by looking
    at the values going into the register file and trace them backward
    until you find the first spot where they go bad.
 
    at any point it can be useful to review the changes that you made to
    see if you did something stupid.  An efficent way to do that is to
    diff your modified file against the original
 
           diff machine.v orig_machine.v
 
    (where 'orig_machine.v' is whatever you called the copy you made in
    step 3.  If you used svn or git, then use 'svn diff' or 'git diff'.)
 
 8. when your test input is working, run:
 
            make regression
            make > regress.new
            diff regress.new regress
 
    like step 4, this will run the regression test, but in addition compare
    your new results to what they should be.  Fix any bugs.
 
 9. if you want to write your own test cases, edit custom.s to your heart's
    content (perhaps taking inspiration from the provided test case), and
    then run:
            make custom
            make
 
    to run your machine against your custom test case. You can run your test
    to verify its behavior:
            ./QtSpim-datapath -file custom.s

10. celebrate a job well done.
