// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Isuru Nawinne

`include "cpu.v"
`include "dmem_for_dcache.v"
`include "dcache.v"
`include "inst_cache.v"
`include "instruction_mem.v"
`timescale 1ns/100ps

module cpu_tb;

    reg CLK, RESET;
    wire read, write, BUSYWAIT;

    wire [31:0] PC;
    wire [31:0] INSTRUCTION;

    wire[7:0] ADDRESS, WRITEDATA, READDATA;

    wire mem_read, mem_write;
    wire mem_busywait;
    wire [5:0] mem_address;
    wire [31:0] mem_writedata,mem_readdata;

    wire icache_busywait, inst_mem_read,inst_mem_busywait;
    wire [5:0] inst_mem_address;
    wire [127:0] inst_mem_readdata;

    
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    /*
    // TODO: Initialize an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
    reg [7:0] instr_mem [1023:0];
    
    // TODO: Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)
    assign #2 INSTRUCTION = {instr_mem[PC+3], instr_mem[PC+2], instr_mem[PC+1], instr_mem[PC]};

    
    initial
    begin
        // Initialize instruction memory with the set of instructions you need execute on CPU
        
        // METHOD 1: manually loading instructions to instr_mem
        {instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]}    = 32'b00000000_00000000_00000000_00001001;
        {instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]}    = 32'b00000000_00000001_00000000_00000001;
        {instr_mem[10'd11], instr_mem[10'd10], instr_mem[10'd9], instr_mem[10'd8]}  = 32'b00001010_00000000_00000000_00000001;
        {instr_mem[10'd15], instr_mem[10'd14], instr_mem[10'd13], instr_mem[10'd12]} = 32'b00001011_00000000_00000001_00000000;
        {instr_mem[10'd19], instr_mem[10'd18], instr_mem[10'd17], instr_mem[10'd16]} = 32'b00001000_00000010_00000000_00000001;
        {instr_mem[10'd23], instr_mem[10'd22], instr_mem[10'd21], instr_mem[10'd20]} = 32'b00001000_00000011_00000000_00000001;
        {instr_mem[10'd27], instr_mem[10'd26], instr_mem[10'd25], instr_mem[10'd24]} = 32'b00000011_00000100_00000000_00000001;
        {instr_mem[10'd31], instr_mem[10'd30], instr_mem[10'd29], instr_mem[10'd28]} = 32'b00001011_00000000_00000100_00000010;
        {instr_mem[10'd35], instr_mem[10'd34], instr_mem[10'd33], instr_mem[10'd32]} = 32'b00001001_00000101_00000000_00000010;
        {instr_mem[10'd39], instr_mem[10'd38], instr_mem[10'd37], instr_mem[10'd36]} = 32'b00001011_00000000_00000100_00100000;
        {instr_mem[10'd43], instr_mem[10'd42], instr_mem[10'd41], instr_mem[10'd40]} = 32'b00001001_00000110_00000000_00100000;
        
        // METHOD 2: loading instr_mem content from instr_mem.mem file
        //$readmemb("instr_mem.mem", instr_mem);
    end*/

    /*
	------------------
	INSTRUCTION CACHE
	------------------
    */
    icache our_icache (CLK, RESET, PC[9:0], INSTRUCTION, icache_busywait, inst_mem_read, inst_mem_address, inst_mem_readdata, inst_mem_busywait);
    

    /*
	------------------
	INSTRUCTION MEMORY
	------------------
    */
    instruction_memory our_insr_mem(CLK, inst_mem_read, inst_mem_address, inst_mem_readdata, inst_mem_busywait);
    

    /* 
    -----
     DATA MEMORY
    -----
    */
    data_memory our_dmem (CLK, RESET, mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);

        
    /* 
    -----
     DATA CACHE
    -----
    */
    dcache our_dcache (CLK, RESET, read, write, ADDRESS, WRITEDATA, READDATA, BUSYWAIT, mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);

    
    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET, BUSYWAIT, icache_busywait, read, write, ADDRESS, WRITEDATA, READDATA);

    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        RESET = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        RESET = 1'b1;
		#5
		RESET = 1'b0;

        // finish simulation after some time
        #4000
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule