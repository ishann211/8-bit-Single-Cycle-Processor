`timescale 1ns/100ps

//PCAdder module to get the PC+4 value

module PCAdder (

    //Input Port - Current PC Value
    input [31:0] PC,

    //Output Port
    output [31:0] PCPlusFour
);

    //PC+4
    assign #1 PCPlusFour = PC +4;
    
endmodule