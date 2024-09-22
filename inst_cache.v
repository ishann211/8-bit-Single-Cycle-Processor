`timescale 1ns/100ps

module icache (
    clock,
    reset,
    address,
    readdata,
	busywait,
    mem_read,
    mem_address,
    mem_readdata,
    mem_busywait
);
    //CPU inputs and outputs to the instruction cache
    input				clock;
    input           	reset;
    input[9:0]      	address;
    output reg [31:0]	readdata;
    output reg      	busywait;

    //Instruction memory inputs and outputs
    output reg          mem_read;
    output reg[5:0]     mem_address;
    input[127:0]	    mem_readdata;
    input     	        mem_busywait;
    

    //Declare Cache array 8x32-bits 
    reg [127:0] inst_cache_array [7:0];

    //Declare Valid bit Array
    reg valid_array [7:0];

    //Declare Tag Array
    reg [2:0] tag_array [7:0];


    //Connections
    reg tagMatched;
    wire hit;

    /*
    Combinational part for indexing, tag comparison for hit deciding, etc.
    ...
    */

    //Spliting the address 
    wire [2:0] index;
    wire [1:0] offset;
    wire [2:0] tag;

    assign #1 index = address[6:4];
    assign #1 offset = address[3:2];
    assign #1 tag = address[9:7];

    //Whenever the address is received read is set to 1
    always @(address) begin
        busywait = 1 ;
    end


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

    //Mnage the busywait signal
    always @(clock) begin
        if (hit) begin
            busywait = 0;
        end
    end 

    //Extracting data from the cache array to readdata
    always @(*)
    begin
        #1
        case(offset)
            2'b00: readdata = inst_cache_array[index][31:0];
            2'b01: readdata = inst_cache_array[index][63:32];
            2'b10: readdata = inst_cache_array[index][95:64];
            2'b11: readdata = inst_cache_array[index][127:96];
        endcase
    end    

    /* Cache Controller FSM Start */

    parameter IDLE = 3'b000, MEM_READ = 3'b001;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if (!hit)  
                    next_state = MEM_READ;
                else
                    next_state = IDLE;
            
            MEM_READ:
                if (!mem_busywait)
                    next_state = IDLE;
                else    
                    next_state = MEM_READ;    
        endcase
    end

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
                mem_read = 0;
                mem_address = 6'dx;
            end
         
            MEM_READ: 
            begin
                mem_read = 1;
                /*  Address = PC[11:0] (Byte address)
                    Address[11:2] = Word Address
                    Address[11:4] = Instruction Address
                    Address[11:6] = Block Address   
                */
                mem_address = {tag, index};
                busywait = 1;
                #1
                if(mem_busywait == 0)begin
                    inst_cache_array[index] = mem_readdata;
                    valid_array[index] = 1;
                    tag_array[index] = tag;
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
            $dumpvars(2, inst_cache_array[i]);
        end
    end

endmodule