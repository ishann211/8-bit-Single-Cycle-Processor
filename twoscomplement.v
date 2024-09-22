/*module testbench ;
    reg [7:0] inputnum;
    wire [7:0] outputnum;


    twoscomplement unit(inputnum, outputnum);

    initial
    begin
        inputnum = 8'd10;
        #5
        inputnum = 8'd12;
        $display("Test Completed.");
    end

    
endmodule*/


`timescale 1ns/100ps

//2's complement module
//Do the sub operation using the same adder
module twoscomplement (
    input [7:0] inputnum,
    output [7:0] outputnum
);

assign #1 outputnum = ~inputnum + 8'd1 ;
    
endmodule