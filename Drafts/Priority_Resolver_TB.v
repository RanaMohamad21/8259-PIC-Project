module Priority_Resolver_tb;
  reg        INTA;
  reg  [7:0] IRQ_status;
  reg  [7:0] IS_status;
  reg  [7:0] IR_mask;
  reg        Rotating_priority;
  reg  [7:0] last_serviced;
  wire [7:0] Priority;

  // Instantiate the Priority_Resolver module
  Priority_Resolver uut (
    .INTA(INTA),
    .IRQ_status(IRQ_status),
    .IS_status(IS_status),
    .IR_mask(IR_mask),
    .Rotating_priority(Rotating_priority),
    .last_serviced(last_serviced),
    .Priority(Priority)
  );

  // Initialize inputs
  initial begin
    INTA = 1'b0;
    IRQ_status = 8'b00000000;
    IS_status = 8'b00000000;
    IR_mask = 8'b00000000;
    Rotating_priority = 1'b0;
    last_serviced = 8'b00000000;

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
    last_serviced = 8'b00000001;
    #50; // Simulate for some time
    IS_status = 8'b00000000;
    IRQ_status = 8'b11000000;
    #50  // Simulate for some time
    IS_status = 8'b01000000;
    #50  // Simulate for some time
    IS_status = 8'b00000000;
    last_serviced = 8'b01000000;
    #50  // Simulate for some time
    
    // Add more test scenarios as needed

    $stop; // Stop simulation
  end

  // Add stimulus generation and result checking as needed

endmodule

