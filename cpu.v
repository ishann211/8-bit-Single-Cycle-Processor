
`include "pc.v"
`include "PCAdder.v"
`include "ALU.v"
`include "regFile.v"
`include "combinationalLogic.v"
`include "twoscomplement.v"
`include "mux.v"
`include "JumpBranch.v"

`timescale 1ns/100ps


module cpu(PC, INSTRUCTION, CLK, RESET, BUSYWAIT, I_BUSYWAIT, read, write, ADDRESS, WRITEDATA, READDATA);

    //Input ports
    input [31:0] INSTRUCTION;
    input CLK, RESET;
    input BUSYWAIT;
    input I_BUSYWAIT;
    input [7:0] READDATA;


    //Output ports
    output [31:0] PC;
    output reg read, write;
    output [7:0] ADDRESS, WRITEDATA;

    //Control unit output Signals
    /* ALUOP [2:0] - Alu select
        signSelector 1 bit - Negation Mux Selector
        aluRTSelector 1 bit - Alu second operand selector
        WRITEENABLE 1 bit - Register File write signal
        pcValueSelector 1 bit - Next PC value selector
        writeDataSelector 1 bit - Write Data Selector
    */
    reg [2:0] ALUOP;
    reg signSelector, aluRTSelector;
    reg WRITEENABLE;
    wire pcValueSelector;
    reg writeDataSelector;

    // Connections for ALU
    wire [7:0] DATA1, DATA2, RESULT;
    wire ZERO;
    

    // Connections for regFile
    wire [2:0] WRITEREG, READREG1, READREG2;
    wire [7:0] REGOUT1, REGOUT2;

    // Connections for twosComplement
    wire [7:0] negatedOut;

    // Connections for negationMux
    wire [7:0] negatedMuxOut;

    // Connections for WRITEDATAMux
    wire [7:0] WriteDataMuxOut;

    //Current OPCODE stored in CPU
	reg [7:0] OPCODE;

    // Connection for Immediate value
    wire [7:0] IMMEDIATE;

    // Connections for Jump & Branch
    reg JUMP, BRANCH;

    //PC+4 and NEWPC wires for MUX32 connection
    wire [31:0] PCPlusFour, PCJumpBranch, NEWPC; 
    wire [7:0] OFFSET;

    //Controls for Data Memory
    assign WRITEDATA = REGOUT1;
    assign ADDRESS = RESULT;






    //Instances
    PC our_PC (CLK, RESET, BUSYWAIT, I_BUSYWAIT, NEWPC , PC);
    combiLogic our_combiLogic (INSTRUCTION, READREG1, READREG2, WRITEREG, IMMEDIATE, OFFSET);
    alu our_alu (REGOUT1, DATA2, ALUOP, RESULT, ZERO);
    reg_file our_reg_File (WriteDataMuxOut, WRITEREG, READREG1, READREG2, CLK, RESET, WRITEENABLE, BUSYWAIT, REGOUT1, REGOUT2);
    twoscomplement our_twoscomplement (REGOUT2, negatedOut);
    MUX negation_mux (REGOUT2, negatedOut, signSelector, negatedMuxOut);
    MUX aluRT_mux (negatedMuxOut, IMMEDIATE, aluRTSelector, DATA2);

    flowControler our_flowController (JUMP, BRANCH, ZERO, pcValueSelector);
    MUXV32 pcSelecting_mux (PCPlusFour, PCJumpBranch, pcValueSelector, NEWPC);
    JumpBranch our_JumpBranch (PCPlusFour, OFFSET, PCJumpBranch);
    PCAdder our_PCAdder (PC, PCPlusFour);
    MUX writeData_mux(RESULT, READDATA, writeDataSelector, WriteDataMuxOut);




// OPCODES for instructions
/*
Instruction     OPCODE
loadi           0000_0000
mov             0000_0001
add             0000_0010
sub             0000_0011
and             0000_0100
or              0000_0101
beq             0000_0111
jump            0000_0110
lwd             0000_1000
lwi             0000_1001
swd             0000_1010
swi             0000_1011
*/

    always @ (BUSYWAIT) begin
        if (~BUSYWAIT) begin
            read = 1'b0;
            write = 1'b0;
        end
    end

    always @(INSTRUCTION)
    begin
        OPCODE = INSTRUCTION[31:24] ;
        #1  //1 Time unit delay in decoding

        case(OPCODE)

            //loadi
            8'b0000_0000:   begin
                                ALUOP = 3'b000;
                                aluRTSelector = 1'b1;
                                signSelector = 1'b0;
                                WRITEENABLE = 1'b1;
                                JUMP = 1'b0;			
								BRANCH = 1'b0;
                                write = 1'b0;
                                read = 1'b0;
                                writeDataSelector = 1'b0;
                            end
            
            //mov
            8'b0000_0001:   begin
                                ALUOP = 3'b000;
                                aluRTSelector = 1'b0;
                                signSelector = 1'b0;
                                WRITEENABLE = 1'b1;
                                JUMP = 1'b0;			
								BRANCH = 1'b0;
                                write = 1'b0;
                                read = 1'b0;
                                writeDataSelector = 1'b0;
                            end
            
            //add
            8'b0000_0010:   begin
                                ALUOP = 3'b001;
                                aluRTSelector = 1'b0;
                                signSelector = 1'b0;
                                WRITEENABLE = 1'b1;
                                JUMP = 1'b0;			
								BRANCH = 1'b0;
                                write = 1'b0;
                                read = 1'b0;
                                writeDataSelector = 1'b0;
                            end
            
            //sub
            8'b0000_0011:   begin
                                ALUOP = 3'b001;
                                aluRTSelector = 1'b0;
                                signSelector = 1'b1;
                                WRITEENABLE = 1'b1;
                                JUMP = 1'b0;			
								BRANCH = 1'b0;
                                write = 1'b0;
                                read = 1'b0;
                                writeDataSelector = 1'b0;
                            end
            
            //and
            8'b0000_0100:   begin
                                ALUOP = 3'b010;
                                aluRTSelector = 1'b0;
                                signSelector = 1'b0;
                                WRITEENABLE = 1'b1;
                                JUMP = 1'b0;			
								BRANCH = 1'b0;
                                write = 1'b0;
                                read = 1'b0;
                                writeDataSelector = 1'b0;
                            end
            
            //or
            8'b0000_0101:   begin
                                ALUOP = 3'b011;
                                aluRTSelector = 1'b0;
                                signSelector = 1'b0;
                                WRITEENABLE = 1'b1;
                                JUMP = 1'b0;			
								BRANCH = 1'b0;
                                write = 1'b0;
                                read = 1'b0;
                                writeDataSelector = 1'b0;
                            end

            //jump
            8'b0000_0110:   begin
                                JUMP = 1'b1;
                                BRANCH = 1'b0;
                                WRITEENABLE = 1'b1;
                            end 

            //beq
            8'b0000_0111:   begin
                                ALUOP = 3'b001;
                                aluRTSelector = 1'b0;
                                signSelector = 1'b1;
                                WRITEENABLE = 1'b0;
                                JUMP = 1'b0;
                                BRANCH = 1'b1;
                                write = 1'b0;
                                read = 1'b0;
                                writeDataSelector = 1'b0;
                            end

            //lwd
            8'b0000_1000:   begin
                                ALUOP = 3'b000;
                                aluRTSelector = 1'b0;
                                signSelector = 1'b0;
                                WRITEENABLE = 1'b1;
                                JUMP = 1'b0;
                                BRANCH = 1'b0;
                                write = 1'b0;
                                read = 1'b1;
                                writeDataSelector = 1'b1;
                            end

            //lwi
            8'b0000_1001:   begin
                                ALUOP = 3'b000;
                                aluRTSelector = 1'b1;
                                signSelector = 1'b0;
                                WRITEENABLE = 1'b1;
                                JUMP = 1'b0;
                                BRANCH = 1'b0;
                                write = 1'b0;
                                read = 1'b1;
                                writeDataSelector = 1'b1;
                            end

            //swd
            8'b0000_1010:   begin
                                ALUOP = 3'b000;
                                aluRTSelector = 1'b0;
                                signSelector = 1'b0;
                                WRITEENABLE = 1'b0;
                                JUMP = 1'b0;
                                BRANCH = 1'b0;
                                write = 1'b1;
                                read = 1'b0;
                                writeDataSelector = 1'b0;
                            end

            //swi
            8'b0000_1011:   begin
                                ALUOP = 3'b000;
                                aluRTSelector = 1'b1;
                                signSelector = 1'b0;
                                WRITEENABLE = 1'b0;
                                JUMP = 1'b0;
                                BRANCH = 1'b0;
                                write = 1'b1;
                                read = 1'b0;
                                writeDataSelector = 1'b0;
                            end

        endcase
    end

endmodule