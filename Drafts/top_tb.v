// Code your testbench here
// or browse Examples
module top_tb;

  // Declare signals for connecting to the DUT (Design Under Test)
  wire [7:0] data_Bus;
  wire [2:0] cascade_lines;
  reg read_flag, write_flag, A0, chip_select, slave_program, INTA;
  reg [7:0] interrupt_requests;
  wire INT;
  reg [7:0] data_bus_container ;
  wire [7:0]  IRQ_status;
   wire [7:0]interrupt_inservice;
 wire [2:0]  last_serviced;
 wire [2:0] PriorityID;
   wire first_ack;
  wire second_ack;
   wire AEOI;
   wire single_or_cascade;
   wire Rotating_priority;
wire write_Enable;
  // Instantiate the top module
  top uut (
      .IRQ_status(IRQ_status),

  .interrupt_inservice(interrupt_inservice),

  .last_serviced(last_serviced),
  .PriorityID(PriorityID),
    .data_Bus(data_Bus),
    .cascade_lines(cascade_lines),
    .read_flag(read_flag),
    .write_flag(write_flag),
    .A0(A0),
    .chip_select(chip_select),
    .slave_program(slave_program),
    .INTA(INTA),
    .interrupt_requests(interrupt_requests),
    .INT(INT),
    .first_ack(first_ack),
    .second_ack(second_ack),
    .AEOI(AEOI),
    .single_or_cascade(single_or_cascade),
    .Rotating_priority(Rotating_priority),
    .write_Enable(write_Enable)
  );

  assign data_Bus = ( write_Enable==1'b0)? data_bus_container:8'bzzzzzzzz;

  // Initial stimulus
  initial begin
    // Initialize inputs
    //ICW1
    read_flag = 1'b1;
    write_flag=1'b1;
    INTA = 1'b1;
    chip_select = 1'b1;
    
    #10 chip_select = 1'b0;
    
    
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
     A0 =1'b0;
    data_bus_container = 8'b00011011;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
    //ICW2
    #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1; 
    #10 write_flag = 1'b0;
        data_bus_container = 8'b11111000;
    #10 write_flag = 1'b1;
    //ICW3
    #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1; 
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag = 1'b1;
    //ICW4
     #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00001111;
    #10 write_flag = 1'b1;
    //OCW2  
    
       #10 chip_select =1'b0;
        A0 = 1'b0;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag = 1'b1;
    #10 interrupt_requests = 8'b00010000;
        #10 INTA =0;
        #10 INTA =1;
        #10 INTA = 0;
        #10 INTA = 1;
        #10 read_flag = 1'b0;
        #10 read_flag = 1'b1;
    
#10 interrupt_requests = 8'b11010000;
        #10 INTA =0;
        #10 INTA =1;
        #10 INTA = 0;
        #10 INTA = 1;
        #10 read_flag = 1'b0;
        #10 read_flag = 1'b1;
#10 interrupt_requests = 8'b00010110;
        #10 INTA =0;
        #10 INTA =1;
        #10 INTA = 0;
        #10 INTA = 1;
        #10 read_flag = 1'b0;
        #10 read_flag = 1'b1;
    




    /*#10
    write_Enable = 1;
    #10
    write_Enable = 0;
    #10
    write_Enable = 1;
    
    A0 = 0;
    chip_select = 0;
    slave_program = 0;
    INTA = 0;
    interrupt_requests = 8'b00000001;
	#20
    data_bus_container = 8'b01100111;
    #100;*/
    
 
  end
  
  initial begin
    // End simulation
    $dumpfile("uvm.vcd");
    $dumpvars;
    #1000 $finish; 
    
  end

endmodule

