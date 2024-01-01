module Priority_Resolver_tb;
  reg  [7:0] IRQ_status;
  reg  [7:0] IS_status;
  reg  [7:0] IR_mask;
  reg        Rotating_priority;
  reg  [2:0] last_serviced;
  wire [2:0] PriorityID;
  wire       INTFLAG;

  // Instantiate the Priority_Resolver module
  Priority_Resolver uut (
    .IRQ_status(IRQ_status),
    .IS_status(IS_status),
    .IR_mask(IR_mask),
    .Rotating_priority(Rotating_priority),
    .last_serviced(last_serviced),
    .PriorityID(PriorityID),
	.INTFLAG(INTFLAG)
  );

  // Initialize inputs
  initial begin
    IRQ_status = 8'b00000000;
    IS_status = 8'b00000000;
    IR_mask = 8'b00000000;
    Rotating_priority = 1'b0;
    last_serviced = 8'b111;

    // Test fully nested mode
    $display("Testing Fully Nested Mode");
    Rotating_priority = 1'b0;
    IRQ_status = 8'b00000010;
    #50; // Simulate for some time
    IS_status = 8'b00000010;
    #50; // Simulate for some time
    IRQ_status = 8'b00000001;
    #50; // Simulate for some time
    IS_status = 8'b00000001;
    
    // Test rotating priority mode
    $display("\nTesting Rotating Priority Mode");
    Rotating_priority = 1'b1;
    last_serviced = 8'b000;
    #50; // Simulate for some time
    IS_status = 8'b00000000;
    IRQ_status = 8'b11000000;
    #50  // Simulate for some time
    IS_status = 8'b01000000;
    #50  // Simulate for some time
    IS_status = 8'b00000000;
    last_serviced = 8'b110;
    #50  // Simulate for some time
    
    

    $stop; // Stop simulation
  end

 

endmodule

