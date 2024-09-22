`timescale 1ns/100ps

//Mux module
module MUX (
    //Inputs
    input [7:0] DATA1 , DATA2,
    input SELECT,

    //Outputs
    output reg [7:0] OUTPUT
);
    
    always @(DATA1, DATA2, SELECT) 
    begin
        //Select the output according to the SELECT
        case (SELECT)
            0 : assign OUTPUT = DATA1;
            1 : assign OUTPUT = DATA2;
        endcase
    end
    
endmodule



//32 bit version of Mux module
module MUXV32 (
    //Inputs
    input [31:0] DATA1 , DATA2,
    input SELECT,

    //Outputs
    output reg [31:0] OUTPUT
);
    
    always @(DATA1, DATA2, SELECT) 
    begin
        //Select the output according to the SELECT
        case (SELECT)
            0 : assign OUTPUT = DATA1;
            1 : assign OUTPUT = DATA2;
        endcase
    end
    
endmodule