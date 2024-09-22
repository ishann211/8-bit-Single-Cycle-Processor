`timescale 1ns/100ps

//Program counter module
module PC (
    input CLK, RESET, BUSYWAIT, I_BUSYWAIT,
    input [31:0] nextPC,
    output reg [31:0] PC
);

    //reg [31:0] updatedPC;

    always @(posedge CLK)
    begin
        //If RESET is high, PC get resets.
        if (RESET == 1) 
        begin
            #1
            PC = 0;
            //updatedPC = 0;
        end
        else if (~BUSYWAIT && ~I_BUSYWAIT) begin
            #1 PC = nextPC;
        end
    end

    
endmodule