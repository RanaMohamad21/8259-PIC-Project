`timescale 1ps / 1ps

module Control_logic_tb;

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in ns

  // Signals
  reg clk, WD, RD, A0, INTA;
  reg [7:0] IRR,ISR;
  reg[2:0] highest_priority_ISR;
  reg vecFlag;
  wire[7:0] data_bus;
  wire INT, ICW1_LTIM, ICW1_SNGL, ICW4_AEOI;
  wire [7:0] vector_address, ICW2, OCW1;
  wire [2:0] reset_by_EOI,slave_id;
  wire  auto_rotate_status, begin_to_set_ISR, send_ISR_to_data_bus,specific_eoi_status;
  wire [1:0] reading_status;
  reg [7:0]data_bus_container;
  reg sp;
  wire [2:0]intr_id;
  wire INT_Flag;
  // Instantiate the Control_logic module
  Control_logic uut (
    .WD(WD),
    .RD(RD),
    .A0(A0),
    .ISR(ISR),
    .IRR(IRR),
    .INTA(INTA),
    .INT(INT),
    .specific_eoi_status(specific_eoi_status),
    .ICW1_LTIM(ICW1_LTIM),
    .ICW1_SNGL(ICW1_SNGL),
    .ICW4_AEOI(ICW4_AEOI),
    .data_bus(data_bus),
    .highest_priority_ISR(highest_priority_ISR), // Provide a default value for highest_priority_ISR
    .reset_by_EOI(reset_by_EOI),
    .OCW1(OCW1),
    .reading_status(reading_status),
    .auto_rotate_status(auto_rotate_status),
    .begin_to_set_ISR(begin_to_set_ISR),
    .send_ISR_to_data_bus(send_ISR_to_data_bus),
    .slave_id(slave_id),
    .vecFlag(vecFlag),
    .intr_id(intr_id),
    .sp(sp),
    .INT_Flag(INT_Flag)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #((CLK_PERIOD)/2) clk = ~clk;
    
    
  end

  // Test stimulus
  initial begin
    
   sp = 1'b1;
    WD = 1'b1;
    RD = 1'b1;
   
    A0 = 1'b0;
    IRR = 8'b0;
    ISR = 8'b0;
    INTA = 1'b1;
    data_bus_container = 8'bzzzzzzzz;
    
     //ICW1
     #10 WD = 1'b0;
     
     A0 = 1'b0;
     data_bus_container= 8'b00011011;
    //ICW2
    #10 WD = 1'b1;
  
//ICW4
  
    
     A0=1'b0;
    #10 WD = 1'b0;
   
    A0 =1'b1;
     data_bus_container = 8'b00000010;
     
     
 
     #10 WD = 1'b1;
     //OCW1
    #10 WD = 1'b0;
        A0 = 1'b1;
        data_bus_container  = 8'b00000000;
        #10 WD = 1'b1;
    
//trying to send IRR

     #10 IRR = 8'b11100000;
     #10 highest_priority_ISR =3'b111;
     #10 INTA = 0;
     #10 INTA = 1;
     #10 INTA = 0;
     #10 INTA = 1;
     
  //ocw3 reading IRR register
   #10 WD = 1'b0;
       A0 = 1'b0;
       data_bus_container = 8'b00001010;
  
   
   #10 WD  =1'b1;
        RD=1'b0;
   #10 RD = 1'b1;

 

    #100 $stop; // Stop simulation after some time
  end
 
  assign data_bus = (WD==1'b0)? data_bus_container:8'bzzzzzzzz;
  // Display outputs
  always @(posedge clk) begin
    $display("Time=%0t: INT=%b, vector_address=%h, OCW1=%h", $time, INT, vector_address, OCW1);
  end

endmodule
