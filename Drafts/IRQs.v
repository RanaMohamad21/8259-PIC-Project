module IRQs (
  input wire [7:0] irq_lines,
  input wire trigger, // D3 -> ICW1 1 -> LEVEL TRIGGERED MODE 0 -> EDGE TRIGGERED MODE 1
  input wire inta,
  input wire [7:0] priority,
  output reg [7:0] irq_status
);
  reg [7:0] edge_triggered_irqs;
  reg [7:0] level_triggered_irqs;
  genvar i;

  generate
    for (i = 0; i < 8; i = i + 1) begin : INST
      always @* begin
        if (trigger == 0) begin
          // Edge-Triggered IRQs
          if (irq_lines[i] && ~edge_triggered_irqs[i])
            edge_triggered_irqs[i] <= 1;
          else if (~irq_lines[i])
            edge_triggered_irqs[i] <= 0;
        end
        else begin
          // Level-Triggered IRQs
          level_triggered_irqs[i] <= irq_lines[i];
        end
      end
    end
  endgenerate

  always @* begin
    if (trigger == 0)
      irq_status = edge_triggered_irqs;
    else
      irq_status = level_triggered_irqs;
  end

  always @(negedge inta) begin  // Assuming INTA signal 'inta'
    if (~inta) begin
      // Acknowledge the IRQ
      if (trigger == 0) begin
        edge_triggered_irqs <= edge_triggered_irqs & ~priority;
        irq_status <= irq_status & ~priority;
      end
      else begin
        level_triggered_irqs <= level_triggered_irqs & ~priority;
        irq_status <= irq_status & ~priority;
      end
    end
  end
endmodule