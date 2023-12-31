module TB_IRQs;

  reg [7:0] irq_lines;
  reg trigger;
  reg inta;
  wire [7:0] irq_status;
  reg [2:0] priority;  // Fix the size of priority
  
  IRQs dut (
    .irq_lines(irq_lines),
    .trigger(trigger),
    .inta(inta),
    .highest_priority_idx(priority),  // Fix the port name
    .irq_status(irq_status)
  );

  initial begin
    // Initialize inputs
    priority = 3'b000; // Initialize the priority
    irq_lines = 8'b00000000;
    trigger = 1'b0; // Edge-triggered mode
    inta = 1'b0;
    
    // Apply some test stimuli
    #10 irq_lines = 8'b00000001; // Enable IRQ line 0
    #30 inta = 1'b1;
    #10 priority = 3'b000;  // Set highest priority to 1
    #20 trigger = 1'b1; // Level-triggered mode
    #5 inta = 1'b0;
    #20 irq_lines = 8'b01010101; // Enable alternate IRQ lines
    
    // Simulate INTA signal and acknowledge IRQ
    #30 inta = 1'b1;
    #10 priority = 3'b100;  // Set highest priority to 4
    #5 inta = 1'b0;

    // Add more test cases

    // Test 1: Edge-triggered mode with multiple IRQ lines
    #10 trigger = 1'b0;
    #20 irq_lines = 8'b10101110; // Enable alternate IRQ lines
    #30 inta = 1'b1;
    #10 priority = 3'b010;  // Set highest priority to 2
    #5 inta = 1'b0;

    // Test 2: Edge-triggered mode with all IRQ lines active
    #10 irq_lines = 8'b11111111; // Enable all IRQ lines
    #30 inta = 1'b0;
    #10 priority = 3'b111;  // Set highest priority to 7
    #5 inta = 1'b1;

    // Test 3: Level-triggered mode with alternating IRQ lines
    #10 trigger = 1'b1;
    #10 irq_lines = 8'b01011101; // Enable alternate IRQ lines
    #30 inta = 1'b1;
    #10 priority = 3'b011;  // Set highest priority to 3
    #5 inta = 1'b0;

    // Finish simulation
    #100 $finish;
  end
endmodule

