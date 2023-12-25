module IRQs (
  input wire [7:0] irq_lines,
  input wire trigger, // D3 -> ICW1 1 -> LEVEL TRIGGERED MODE 0 -> EDGE TRIGGERED MODE 1
  input wire inta,
  input wire [2:0] highest_priority_idx,
  output reg [7:0] irq_status
);
  reg [7:0] edge_triggered_irqs;
  reg [7:0] level_triggered_irqs;
 always @* begin
    if (trigger == 0) begin
      // Edge-Triggered IRQs
      if (irq_lines[0] && ~edge_triggered_irqs[0])
        edge_triggered_irqs[0] <= 1;
      else if (~irq_lines[0])
        edge_triggered_irqs[0] <= 0;

      if (irq_lines[1] && ~edge_triggered_irqs[1])
        edge_triggered_irqs[1] <= 1;
      else if (~irq_lines[1])
        edge_triggered_irqs[1] <= 0;

      if (irq_lines[2] && ~edge_triggered_irqs[2])
        edge_triggered_irqs[2] <= 1;
      else if (~irq_lines[2])
        edge_triggered_irqs[2] <= 0;

      if (irq_lines[3] && ~edge_triggered_irqs[3])
        edge_triggered_irqs[3] <= 1;
      else if (~irq_lines[3])
        edge_triggered_irqs[3] <= 0;
        
      if (irq_lines[4] && ~edge_triggered_irqs[4])
        edge_triggered_irqs[4] <= 1;
      else if (~irq_lines[4])
        edge_triggered_irqs[4] <= 0;

      if (irq_lines[5] && ~edge_triggered_irqs[5])
        edge_triggered_irqs[5] <= 1;
      else if (~irq_lines[5])
        edge_triggered_irqs[5] <= 0;
        
      if (irq_lines[6] && ~edge_triggered_irqs[6])
        edge_triggered_irqs[6] <= 1;
      else if (~irq_lines[6])
        edge_triggered_irqs[6] <= 0;

      if (irq_lines[7] && ~edge_triggered_irqs[7])
        edge_triggered_irqs[7] <= 1;
      else if (~irq_lines[7])
        edge_triggered_irqs[7] <= 0;
    end
    else begin
      // Level-Triggered IRQs
      level_triggered_irqs <= irq_lines;
    end
  end

  always @* begin
    if (trigger == 0)
      irq_status = edge_triggered_irqs;
    else
      irq_status = level_triggered_irqs;
  end

  always @(posedge inta) begin  // Assuming INTA signal 'inta'
    if (inta) begin
      // Acknowledge the IRQ
      if (trigger == 0) begin
        edge_triggered_irqs[highest_priority_idx] <= 0;
        irq_status [highest_priority_idx] <= 0;
      end
      else begin
        level_triggered_irqs [highest_priority_idx] <= 0;
        irq_status [highest_priority_idx] <= 0;
      end
    end
  end
endmodule