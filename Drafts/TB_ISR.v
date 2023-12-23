module TB_ISR;

  // Inputs
  reg [7:0] priority;
  reg eoi, aeoi, specific_eoi;
  reg [2:0] specific_irq;
  reg ack;


  // Outputs
  wire [7:0] interrupts_in_service;

  // Instantiate the ISR module
  ISR uut (
    .priority(priority),
    .eoi(eoi),
    .aeoi(aeoi),
    .specific_eoi(specific_eoi),
    .specific_irq(specific_irq),
    .ack(ack),
    .interrupts_in_service(interrupts_in_service)
  );

  // Initial stimulus
  initial begin
    // Initialize inputs
    priority = 8'b00000000;
    eoi = 0;
    aeoi = 0;
    specific_eoi = 0;
    specific_irq = 3'b000;
    ack = 0;
 

    // Apply some stimulus
    #10 priority = 8'b00000001;  // Set the first priority bit
    #10 priority = 8'b00000100;  // Set a different priority bit
    #10 eoi = 1;  // Simulate EOI
    #10 eoi = 0;  // Simulate EOI
    #10 aeoi = 1; // Simulate AEOI
    #10 priority = 8'b01000000;  // Set a different priority bit
    #10 aeoi = 0; // Simulate AEOI
    #10 specific_eoi = 1; // Simulate Specific EOI
    #10 specific_irq = 3'b001; // Set a specific IRQ for EOI
    #10 ack = 1;  // Simulate ACK

    // Add more test scenarios as needed

    #100 $finish;  // Finish simulation after 100 time units
  end

endmodule
