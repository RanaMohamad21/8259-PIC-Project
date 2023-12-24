`timescale 1ps / 1ps

module Control_logic_tb;

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in ns

  // Signals
  reg clk, WD, RD, A0, INTA;
  reg [7:0] IRR, ISR;
  reg[2:0] highest_priority_ISR;
  wire[7:0] data_bus;
  wire INT, ICW1_LTIM, ICW1_ADI, ICW1_SNGL, ICW1_IC4, ICW4_SFNM, ICW4_BUF, ICW4_M_OR_S, ICW4_AEOI, ICW4_uPM;
  wire [7:0] vector_address, ICW3, ICW2, OCW1;
  wire [2:0] reset_by_EOI;
  wire  auto_rotate_status, begin_to_set_ISR, send_ISR_to_data_bus;
  wire [1:0] reading_status;
  reg [7:0]data_bus_container;
  // Instantiate the Control_logic module
  Control_logic uut (
    .WD(WD),
    .RD(RD),
    .A0(A0),
    .IRR(IRR),
    .ISR(ISR),
    .INTA(INTA),
    .INT(INT),
    .ICW1_LTIM(ICW1_LTIM),
    .ICW1_ADI(ICW1_ADI),
    .ICW1_SNGL(ICW1_SNGL),
    .ICW1_IC4(ICW1_IC4),
    .ICW4_SFNM(ICW4_SFNM),
    .ICW4_BUF(ICW4_BUF),
    .ICW4_M_OR_S(ICW4_M_OR_S),
    .ICW4_AEOI(ICW4_AEOI),
    .ICW4_uPM(ICW4_uPM),
    .vector_address(vector_address),
    .ICW3(ICW3),
    .ICW2(ICW2),
    .data_bus(data_bus),
    .highest_priority_ISR(highest_priority_ISR), // Provide a default value for highest_priority_ISR
    .reset_by_EOI(reset_by_EOI),
    .OCW1(OCW1),
    .reading_status(reading_status),
    .auto_rotate_status(auto_rotate_status),
    .begin_to_set_ISR(begin_to_set_ISR),
    .send_ISR_to_data_bus(send_ISR_to_data_bus)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #((CLK_PERIOD)/2) clk = ~clk;
    
    
  end

  // Test stimulus
  initial begin
    
   
    WD = 1'b1;
    RD = 1'b1;
   
    A0 = 1'b0;
    IRR = 8'b0;
    ISR = 8'b0;
    INTA = 1'b1;
    data_bus_container = 8'b0;
    
     //ICW1
     #10 WD = 1'b0;
     
     A0 = 1'b0;
     data_bus_container= 8'b00010101;
    //ICW2
    #10 WD = 1'b1;
       
        A0=1'b0;
   #10 WD = 1'b0;
  
    A0 =1'b1;
      data_bus_container = 8'b11111000;
     //ICW3
    #10 WD = 1'b1;
 
    #10 WD = 1'b0;
 
      A0 =1'b1;
     data_bus_container = 8'b11111111;
//ICW4
     #10 WD = 1'b1;
    
     A0=1'b0;
    #10 WD = 1'b0;
   
    A0 =1'b1;
     data_bus_container = 8'b00011111;
     
     
 
     #10 WD = 1'b1;
    
//trying to send IRR

     #10 IRR = 8'b01100000;
     #10 highest_priority_ISR =3'b111;
     #10 INTA = 0;
     #100 INTA = 1;
     #10 INTA = 0;
     #100 INTA = 1;
   
    #10 RD= 1'b0;
    #10 RD = 1'b1;



    #100 $stop; // Stop simulation after some time
  end
 
  assign data_bus = (RD==1'b0)?vector_address:(WD==1'b0)? data_bus_container:8'bzzzzzzzz;
  // Display outputs
  always @(posedge clk) begin
    $display("Time=%0t: INT=%b, vector_address=%h, OCW1=%h", $time, INT, vector_address, OCW1);
  end

endmodule
