//CO224 - Computer Architecture
//Lab05 - Building a simple processor part-2
//Group36

`timescale 1ns/100ps

module reg_file(
    input [7:0] WRITEDATA,
    input [2:0] WRITEREG, READREG1, READREG2,
    input CLK, RESET, WRITEENABLE, BUSYWAIT,
    output [7:0] REGOUT1, REGOUT2
    );

    //Array of 8-bit registers with size of 8
    reg [7:0] register[0:7];

    //To load values onto OUT1 and OUT2 asynchronously
    /*always @(READREG1,READREG2) begin
        //Parallel data outputs (Hence Non-blocking Assigment)
        //Non-blocking assignment with 2 time units delay
        REGOUT1 <= #2 register[READREG1];
        REGOUT2 <= #2 register[READREG2];
    end*/
    assign #2 REGOUT1 =  register[READREG1];
    assign #2 REGOUT2 =  register[READREG2];


    //Variable to go through all the registers 
    integer i;

    //To write to the register file syncronously
    //At the rising edge of CLOCK
    always @(posedge CLK) begin
        //When signal at the WRITE port is set high
        //Non-blocking assignment with 2 time units delay
        if ( WRITEENABLE && !BUSYWAIT )begin                  // else if write is high input data is written to register
            #1 register[WRITEREG] = WRITEDATA;         
        end

        //To reset all the registers synchorounsly
        //When the RESET signal is high
        if(RESET)
        begin
            for (i=0; i<8; i=i+1)begin
                //Set all the registers to '0'
                //Non-blocking assignment with 1 time units delay
                register[i] <= #1 0;
            end
        end
        
            
    end

    initial begin
        //Monitor the changes in reg file content and print
        $display("\n\t\t\t================================================");
        $display("\t\t\tChangeof the Register Content Starting from Time #5");
        $display("\t\t\t================================================\n");
        $display("\t\ttime\t\treg0\treg1\treg2\treg3\treg4\treg5\treg6\treg7");
        $display("\t\t\t--------------------------------------------------");
        $monitor($time,"\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", register[0], register[1], register[2], register[3], register[4], register[5], register[6], register[7]);
    end

    initial begin
        $dumpfile("cpu_wavedata.vcd");
        for (i = 0; i < 8; i = i + 1) begin
            $dumpvars(1,register[i]);
        end
    end

endmodule