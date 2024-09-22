//CO224 - Computer Architecture
//Lab05 - Building a simple processor part-1
//Group36

`timescale 1ns/100ps

module alu(
    input [7:0] DATA1, DATA2, // 8 bit inputs
    input [2:0] SELECT, // 3 bit selector
    output reg [7:0] RESULT,
    output reg ZERO); // 8 bit register (Having register, because cannot use net data types in always block)
    

    //Array of wires to store the results of each alu function unit 
    wire [7:0] answer [3:0];

    //Creating the instances of each alu function units(forward,ADD,AND,OR)
    //Store the results in the wire array
    forward forwardFunc(DATA2, answer[0]);
    ADD addFunc(DATA1, DATA2, answer[1]);
    AND andFunc(DATA1, DATA2, answer[2]);
    OR orFunc(DATA1, DATA2, answer[3]);

    //Case statement inside the always block to forward the perticular result to the alu output port 
    always @(answer[0], answer[1], answer[2], answer[3], SELECT) begin
    
    /*  Select      Function
        000         FORWARD
        001         ADD
        010         AND
        011         OR       
    */
    case(SELECT)

        3'b000: RESULT = answer[0];
        3'b001: RESULT = answer[1];
        3'b010: RESULT = answer[2];
        3'b011: RESULT = answer[3];
        default RESULT = 8'b0000_0000;

    endcase

    //Generate ZERO output
    assign ZERO = ~(RESULT[0] | RESULT[1] | RESULT[2] | RESULT[3] | RESULT[4] | RESULT[5] | RESULT[6] | RESULT[7]);

    end

endmodule


//FORWARDER UNIT
module forward (
    input [7:0] DATA2, //8 bit input
    output [7:0] RESULT //8 bit output
);

    //forward the value of the DATA2 into RESULT
    //Continuous assignment LHS delay with 1 time unit 
    assign #1 RESULT = DATA2; 

endmodule


//ADD UNIT
module ADD (
    input [7:0] DATA1 ,DATA2, //8 bit inputs
    output [7:0] RESULT  //8 bit output
);

    //Add DATA1 and DATA2 get the RESULT
    //Continuous assignment LHS delay with 2 time unit 
    assign #2 RESULT = DATA1 + DATA2;
    
endmodule


//AND Unit
module AND (
    input [7:0] DATA1 ,DATA2, //8 bit inputs
    output [7:0] RESULT  //8 bit output
);

    //Do AND Operation between DATA1 and DATA2 get the RESULT
    //Continuous assignment LHS delay with 1 time unit 
    assign #1 RESULT = DATA1 & DATA2;
    
endmodule


//OR Unit
module OR (
    input [7:0] DATA1 ,DATA2, //8 bit inputs
    output [7:0] RESULT  //8 bit output
);

    //Do OR Operation between DATA1 and DATA2 get the RESULT
    //Continuous assignment LHS delay with 1 time unit 
    assign #1 RESULT = DATA1 | DATA2;
    
endmodule