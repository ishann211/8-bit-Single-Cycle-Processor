// Calculate the PC value for Jump and Branch instructions

`timescale 1ns/100ps

module JumpBranch(PC, OFFSET, NEWPC);

    //Input ports
    input [31:0] PC;
    input [7:0] OFFSET;

    //Output port
    output [31:0] NEWPC;

    wire [21:0] first22Bits;

    //Sign extending upto 28 bits
    //8th bit's value has extended
    assign first22Bits = {22{OFFSET[7]}};

    //Get the jamp or branch address by multiplying the sign extended address by 4
    assign #2 NEWPC = PC + {first22Bits, OFFSET, 2'b0};

endmodule


//Flow controller module to select the jump or branch address for next pc 
module flowControler(JUMP, BRANCH, ZERO, OUT);

    input JUMP, BRANCH, ZERO;
    output OUT;

    assign OUT = JUMP | (BRANCH & ZERO);

endmodule