module ISR (
  // Inputs
  input wire [2:0] highest_priority_idx,
  input wire eoi,
  input wire aeoi,
  input wire specific_eoi,  // Signal for specific EOI mode
  input wire [2:0] specific_irq,  // Specific IRQ for specific EOI
  input wire ack1,
  input wire ack2,
  // Outputs
  output reg [7:0] interrupts_in_service,
  output reg [2:0] last_serviced_idx
);
  reg [7:0] next_inService_reg  = 8'b0;

always @* begin
  if (~ack1) begin 
  //first ack pulse
    next_inService_reg[highest_priority_idx] <= 1'b1;
  end 
  //second ack pusle
  //ede maya el last serviced
  //check eoi code
else begin end
  if (eoi) begin
    // Normal EOI
    next_inService_reg[highest_priority_idx] <= 1'b0;
    last_serviced_idx <= highest_priority_idx;
  end 
else begin end
  if (aeoi && ~ack2) begin
    // Automatic EOI
    next_inService_reg[highest_priority_idx] <= 1'b0;
    last_serviced_idx <= highest_priority_idx;
  end 
else begin end
 if (specific_eoi) begin
    // Specific EOI
    if (specific_irq < 8'b1000) begin
      next_inService_reg[specific_irq] <= 1'b0;
      last_serviced_idx <= specific_irq;
    end
  else begin end
  end
else begin end
end

always @* begin
  interrupts_in_service = next_inService_reg;
end

endmodule
