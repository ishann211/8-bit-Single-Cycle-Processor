`include "ALU.v"

module testbench ;
    reg [7:0] DATA1, DATA2; //8-bit registers for inputs DATA1 and Data2
    reg [2:0] SELECT; //3-bit register for input SELECT
    wire [7:0] RESULT; //8-bit wire for output RESULT

    //Creating an instance of alu called aluUnit
    alu aluUnit(DATA1, DATA2, SELECT, RESULT);
    
    initial begin
        $dumpfile("wavedata.vcd");
        $dumpvars(0, testbench);
        $monitor($time,  " DATA1 = %b DATA2 = %b, RESULT = %b\n", DATA1, DATA2, RESULT);
    end

    initial begin
        DATA1 = 8'b0000_0001;
        DATA2 = 8'B0000_0010;
        SELECT = 3'b001;
        #10;

        DATA1 = 8'd12;
        DATA2 = 8'd8;
        SELECT = 3'b010;
        #10;
        
        
        DATA1 = 8'd2;
        DATA2 = 8'd1;
        SELECT = 3'b011;
        #10;

        
        DATA2 = 8'd12;
        SELECT = 3'b000;
        #10;
        

    end
    
endmodule

