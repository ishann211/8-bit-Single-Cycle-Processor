/*
Module  : Data Cache 
Author  : Isuru Nawinne, Kisaru Liyanage
Date    : 25/05/2020

Description	:

This file presents a skeleton implementation of the cache controller using a Finite State Machine model. Note that this code is not complete.
*/
`timescale 1ns/100ps

module dcache (
    clock,
    reset,
    read,
    write,
    address,
    writedata,
    readdata,
	busywait,
    mem_read,
    mem_write,
    mem_address,
    mem_writedata,
    mem_readdata,
    mem_busywait
);
    //CPU inputs and outputs
    input				clock;
    input           	reset;
    input           	read;
    input           	write;
    input[7:0]      	address;
    input[7:0]     	    writedata;
    output reg [7:0]	readdata;
    output reg      	busywait;

    //Memory inputs and outputs
    output reg          mem_read;
    output reg          mem_write;
    output reg[5:0]     mem_address;
    output reg[31:0]    mem_writedata;
    input[31:0]	        mem_readdata;
    input      	        mem_busywait;
    

    //Declare Cache array 8x32-bits 
    reg [31:0] cache_array [7:0];

    //Declare Valid bit Array
    reg valid_array [7:0];

    //Declare Dirty bit Array
    reg dirty_array [7:0];

    //Declare Tag Array
    reg [2:0] tag_array [7:0];


    //Connections
    reg tagMatched;
    wire hit;
    wire dirty;

    /*
    Combinational part for indexing, tag comparison for hit deciding, etc.
    ...
    */

    //Spliting the address 
    wire [2:0] index;
    wire [1:0] offset;
    wire [2:0] tag;

    assign #1 index = address[4:2];
    assign #1 offset = address[1:0];
    assign #1 tag = address[7:5];

    //Whenever read or Write is received busywait is set to 1
    always @(read, write)
    begin
        if(read || write)
            busywait = 1;
        else
            busywait = 0;
    end 

    //Extract dirty bit according to the index
    assign #1 dirty = dirty_array[index];

    //If the incoming tag is matched with the existing tag, generate hit
    always @(index, tag, tag_array[index])
    begin
        #0.9
        if(tag == tag_array[index])
            tagMatched = 1;
        else
            tagMatched = 0;
    end

    //Generate hit
    assign hit = tagMatched && valid_array[index] ? 1 : 0;


    //Extracting data from the cache array to readdata
    always @(*)
    begin
        #1
        case(offset)
            2'b00: readdata = cache_array[index][7:0];
            2'b01: readdata = cache_array[index][15:8];
            2'b10: readdata = cache_array[index][23:16];
            2'b11: readdata = cache_array[index][31:24];
        endcase
    end

    //Write Hit
    reg write_Hit;

    always @(*)
        begin
            if (hit) begin
                if(read && (!write)) begin
                    busywait=0;
                    tagMatched=0;
                end
                else if(write && (!read)) begin
                    busywait=0;
                    //tagMatched=0;
                    write_Hit = 1;
                end
            end
            
        end

    

    //Write data to the cache arra
    always @(posedge clock)
    begin
        if(write_Hit)
        begin
            #1 // Consider the delay
            case(offset)
                2'b00: cache_array[index][7:0] = writedata;
                2'b01: cache_array[index][15:8] = writedata;
                2'b10: cache_array[index][23:16] = writedata;
                2'b11: cache_array[index][31:24] = writedata;
            endcase
            dirty_array[index] = 1;
            write_Hit = 0;
        end
    end

    //Write miss - have to store the tag to write to the data memory
    reg [2:0] pre_tag;

    always @(*) begin
        if (dirty && !write_Hit) begin
            pre_tag = tag_array[index];
        end
    end
    





    

    /* Cache Controller FSM Start */

    parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE= 3'b010;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if ((read || write) && !dirty && !hit)  
                    next_state = MEM_READ;
                else if ((read || write) && dirty && !hit)
                    next_state = MEM_WRITE;
                else
                    next_state = IDLE;
            
            MEM_READ:
                if (!mem_busywait)
                    next_state = IDLE;
                else    
                    next_state = MEM_READ;
            
            MEM_WRITE:
                if (!mem_busywait)
                    next_state = MEM_READ;
                else    
                    next_state = MEM_WRITE;
            
        endcase
    end

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 8'dx;
                mem_writedata = 8'dx;
            end
         
            MEM_READ: 
            begin
                mem_read = 1;
                mem_write = 0;
                mem_address = {tag, index};
                mem_writedata = 32'dx;
                busywait = 1;
                #1
                if(mem_busywait == 0)begin
                    cache_array[index] = mem_readdata;
                    valid_array[index] = 1;
                    tag_array[index] = tag;
                end
                    
            end

            MEM_WRITE: 
            begin
                mem_read = 0;
                mem_write = 1;
                mem_address = {pre_tag, index};
                mem_writedata = cache_array[index];
                busywait = 1;

                //Data has written to memory
                //When mem_busywait goes to 0, dirty bit set as 0
                if(mem_busywait == 0)begin
                    dirty_array[index] = 0;
                end
            end
            
        endcase
    end

    // sequential logic for state transitioning 
    integer i;
    always @(posedge clock, reset)
    begin
        if(reset)begin
            state = IDLE;
            for (i = 0; i < 8; i=i+1) begin
                valid_array[i] = 0;
                dirty_array[i] = 0;
            end
        end
        else
            state = next_state;
    end

    /* Cache Controller FSM End */

    //testing - dump the values of the memory array to the gtkwave file
    initial begin
        $dumpfile("cpu_wavedata.vcd");
        for (i = 0; i < 8; i = i + 1) begin
            $dumpvars(2, cache_array[i]);
        end
    end

endmodule