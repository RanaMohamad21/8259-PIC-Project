module TB_IRQs;
  reg [7:0] irq_lines;
  reg trigger;
  reg inta;
  wire [7:0] irq_status;
  reg [7:0] priority;
  
  IRQs dut (
    .irq_lines(irq_lines),
    .trigger(trigger),
    .inta(inta),
    .priority(priority),
    .irq_status(irq_status)
  );
  

  
  initial begin
    // Initialize inputs
    priority = 8'b00000000; 
    irq_lines = 8'b00000000;
    trigger = 1'b0; // Edge-triggered mode
    inta = 1'b1;
    
    // Apply some test stimuli
    #10 irq_lines = 8'b00000001; // Enable IRQ line 0
    #10 priority = 8'b00000001; 
    #20 trigger = 1'b1; // Level-triggered mode
    
    #10 irq_lines = 8'b01010101; // Enable alternate IRQ lines
    
    // Simulate INTA signal and acknowledge IRQ
    #30 inta = 1'b0;
    #10 priority = 8'b00000100; 
    #5 inta = 1'b1;
    

    // Finish simulation
    #100 $finish;
  end
endmodule