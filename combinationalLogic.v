`timescale 1ns/100ps

module combiLogic (

    //Inputs
    input [31:0] INSTRUCTION,

    //Outputs
    output [2:0] READREG1, READREG2, WRITEREG,
    output [7:0] IMMEDIATE, OFFSET
); 

    //Instruction encoded format
    /*  OP-CODE         (bits 31-24)        OPCODE
        RD / IMM        (bits 23-16)        WRITEREG / OFFSET
        RT              (bits 15-8)         READREG1
        RS / IMM        (bits7-0)           READREG2 / IMMEDIATE
        OFFSET          (bits 23-16)        JUMP/BRANCH 
    */

    //Assigining values to the outputs 
    //No delays - assing values immediately
    assign READREG1 = INSTRUCTION[15:8];
    assign READREG2 = INSTRUCTION[7:0];
    assign WRITEREG = INSTRUCTION[18:16];
    assign IMMEDIATE = INSTRUCTION[7:0];
    assign OFFSET = INSTRUCTION[23:16];
    
endmodule