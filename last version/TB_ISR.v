module TB_ISR;

  // Parameters and signals
  parameter DELAY = 5;  // Delay between inputs in simulation steps

  // Testbench signals
  reg [2:0] highest_priority_idx;
  reg AEOI;
  reg specific_eoi_flag;
  reg [2:0] specific_irq;
  reg ack1;
  reg ack2;  // Acknowledge signal for the second level
  reg SP;
  reg SNGL;

  // Outputs from the DUT (Device Under Test)
  wire [7:0] interrupts_in_service;
  wire [2:0] last_serviced_idx;

  // DUT instantiation
  ISR dut (
    // Inputs
    .highest_priority_idx(highest_priority_idx),
    .AEOI(AEOI),
    .specific_eoi_flag(specific_eoi_flag),
    .specific_irq(specific_irq),
    .ack1(ack1),
    .ack2(ack2),
    .SP(SP),
    .SNGL(SNGL),
    // Outputs
    .interrupts_in_service(interrupts_in_service),
    .last_serviced_idx(last_serviced_idx)
  );

  // Initialize testbench signals
  initial begin
    highest_priority_idx = 3'b000;
    AEOI = 1'b0;
    specific_eoi_flag = 1'b1;
    specific_irq = 3'b000;
    ack1 = 1'b0;
    ack2 = 1'b0; // Initialize ack2
    SP = 1'b0;
    SNGL = 1'b1;
  end

  // Stimulus generation
  always begin
    // Test scenario 1: Non-cascading mode, normal EOI non-specific
    #DELAY;
    highest_priority_idx = 3'b011;
    #DELAY;
    ack1 = 1'b0;
    AEOI = 1'b0;
    specific_eoi_flag = 1'b0;
    SNGL = 1'b1;
    SP = 1'b1;

    // Test scenario 2: Non-cascading mode, automatic EOI
    #DELAY;
    highest_priority_idx = 3'b001;
    #DELAY;
    ack1 = 1'b0;
    AEOI = 1'b1;
    specific_eoi_flag = 1'b0;
    SNGL = 1'b1;
    SP = 1'b1;

    // Test scenario 3: Non-cascading mode, specific EOI
    #DELAY;
    highest_priority_idx = 3'b100;
    #DELAY;
    ack1 = 1'b0;
    AEOI = 1'b0;
    specific_eoi_flag = 1'b1;
    specific_irq = 3'b010;
    SNGL = 1'b1;
    SP = 1'b1;

    // Test scenario 4: Cascading mode, normal EOI non-specific (Master)
    #DELAY;
    highest_priority_idx = 3'b001;
    ack1 = 1'b0;
    AEOI = 1'b0;
    specific_eoi_flag = 1'b0;
    SP = 1'b1;
    #DELAY;
    ack1 = 1'b1;

    // Test scenario 5: Cascading mode, automatic EOI (Slave)
    #DELAY;
    SNGL = 0;
    highest_priority_idx = 3'b010;
    ack1 = 1'b0;
    AEOI = 1'b1;
    specific_eoi_flag = 1'b0;
    SP = 1'b0;
    #DELAY;
    ack1 = 1'b1;

    // Test scenario 6: Cascading mode, specific EOI
    #DELAY;
    highest_priority_idx = 3'b010;
    ack1 = 1'b0;
    AEOI = 1'b0;
    specific_eoi_flag = 1'b1;
    specific_irq = 3'b011;
    #DELAY;
    ack1 = 1'b1;

  // Test scenario 7: Non-cascading mode, automatic EOI, specific IRQ
  #DELAY;
  highest_priority_idx = 3'b001;
  #DELAY;
  ack1 = 1'b0;
  AEOI = 1'b1;
  specific_eoi_flag = 1'b1;
  specific_irq = 3'b010;
  SNGL = 1'b1;
  SP = 1'b1;
  #DELAY;
  ack1 = 1'b1;

  // Test scenario 8: Cascading mode, automatic EOI, specific IRQ (Master)
  #DELAY;
  highest_priority_idx = 3'b001;
  ack1 = 1'b0;
  AEOI = 1'b1;
  specific_eoi_flag = 1'b1;
  specific_irq = 3'b010;
  SP = 1'b1;
  #DELAY;
  ack1 = 1'b1;

  // Test scenario 9: Cascading mode, automatic EOI, specific IRQ (Slave)
  #DELAY;
  SNGL = 0;
  highest_priority_idx = 3'b010;
  ack1 = 1'b0;
  AEOI = 1'b1;
  specific_eoi_flag = 1'b1;
  specific_irq = 3'b011;
  SP = 1'b0;
  #DELAY;
  ack1 = 1'b1;

  // Test scenario 10: Cascading mode, normal EOI non-specific (Slave)
  #DELAY;
  SNGL = 0;
  highest_priority_idx = 3'b100;
  ack1 = 1'b0;
  AEOI = 1'b0;
  specific_eoi_flag = 1'b0;
  SP = 1'b0;
  #DELAY;
  ack1 = 1'b1;

  // Test scenario 11: Cascading mode, normal EOI non-specific (Master)
  #DELAY;
  highest_priority_idx = 3'b010;
  ack1 = 1'b0;
  AEOI = 1'b0;
  specific_eoi_flag = 1'b0;
  SP = 1'b1;
  #DELAY;
  ack1 = 1'b1;

  // Test scenario 12: Cascading mode, specific EOI (Master)
  #DELAY;
  highest_priority_idx = 3'b001;
  ack1 = 1'b0;
  AEOI = 1'b0;
  specific_eoi_flag = 1'b1;
  specific_irq = 3'b010;
  SP = 1'b1;
  #DELAY;
  ack1 = 1'b1;

  // Test scenario 13: Cascading mode, specific EOI (Slave)
  #DELAY;
  SNGL = 0;
  highest_priority_idx = 3'b100;
  ack1 = 1'b0;
  AEOI = 1'b0;
  specific_eoi_flag = 1'b1;
  specific_irq = 3'b110;
  SP = 1'b0;
  #DELAY;
  ack1 = 1'b1;
  
    // End simulation after all test scenarios are completed
    #300 $finish;
  end

  // Monitor
  always @(interrupts_in_service, last_serviced_idx) begin
    // Display the current state of the outputs
    $display("Interrupts in service: %b, Last serviced index: %b",
      interrupts_in_service, last_serviced_idx);
  end

endmodule

