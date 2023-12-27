module ISR (
  // Inputs
  input wire [2:0] highest_priority_idx,
  input wire AEOI, // 1-> AEOI 0-> EOI
  input wire specific_eoi_flag,   // Signal for specific EOI mode 1-> specific   0 -> non-specific
  input wire [2:0] specific_irq,  // Specific IRQ idx for specific EOI
  input wire ack1,
  input wire ack2,
  input wire SP,
  input wire SNGL,
  // Outputs
  output reg [7:0] interrupts_in_service,
  output reg [2:0] last_serviced_idx
);

  parameter first_eoi = 1'b0;
  parameter second_eoi = 1'b1;

  reg eoi_prev_state = first_eoi;
  reg eoi_current_state = first_eoi;
  reg eoi_next_state = first_eoi;

  reg [7:0] next_inService_reg = 8'b00000000;
  reg [3:0] next_serviced_idx = 3'b000;
  
  always @(posedge AEOI) begin
    if (AEOI) begin
      eoi_next_state <= ~eoi_current_state;
    end else begin
      case (eoi_current_state)
        first_eoi: eoi_next_state <= second_eoi;
        second_eoi: eoi_next_state <= first_eoi;
        default: eoi_next_state <= first_eoi;
      endcase
    end
  end

  always @(posedge ack1 or posedge ack2 or posedge AEOI or posedge specific_eoi_flag or posedge highest_priority_idx or posedge SP) begin
    if (SNGL) begin // Non-cascading mode
      if (ack1) begin
        // First ack pulse
        next_inService_reg[highest_priority_idx] <= 1'b1;
      end if (~AEOI && ~specific_eoi_flag) begin
        // Normal EOI non-specific
        next_inService_reg[highest_priority_idx] <= 1'b0;
        next_serviced_idx <= highest_priority_idx;
      end if (AEOI && ack2) begin // remove ~
        // Automatic EOI
        next_inService_reg[highest_priority_idx] <= 1'b0;
        next_serviced_idx <= highest_priority_idx;
      end if (~AEOI && specific_eoi_flag) begin
        // Specific EOI
        if (specific_irq < 8'b1000) begin
          next_inService_reg[specific_irq] <= 1'b0;
          next_serviced_idx <= specific_irq;
        end
      end
    end else begin // Cascading mode
      if (ack1) begin
        // First ack pulse
        next_inService_reg[highest_priority_idx] <= 1'b1;
      end if (AEOI && ack2) begin // rag3eha AEOI && ack2
        // Automatic EOI
        next_inService_reg[highest_priority_idx] <= 1'b0;
        next_serviced_idx <= highest_priority_idx;
      end if (SP) begin // Master
        if (eoi_current_state == first_eoi && ~AEOI && ~specific_eoi_flag) begin
          // Normal EOI non-specific
          next_inService_reg[highest_priority_idx] <= 1'b0;
          next_serviced_idx <= highest_priority_idx;
        end if (eoi_current_state == first_eoi && ~AEOI && specific_eoi_flag) begin
          // Specific EOI
          if (specific_irq < 8'b1000) begin
            next_inService_reg[specific_irq] <= 1'b0;
            next_serviced_idx <= specific_irq;
          end
        end
      end else begin // Slave
        if (eoi_current_state == second_eoi && ~AEOI && ~specific_eoi_flag) begin
          // Normal EOI non-specific
          next_inService_reg[highest_priority_idx] <= 1'b0;
          next_serviced_idx <= highest_priority_idx;
        end  if (eoi_current_state == second_eoi && ~AEOI && specific_eoi_flag) begin
          // Specific EOI
          if (specific_irq < 8'b1000) begin
            next_inService_reg[specific_irq] <= 1'b0;
            next_serviced_idx <= specific_irq;
          end
        end
      end
    end
  end

  always @* begin
    interrupts_in_service <= next_inService_reg;
    last_serviced_idx <= next_serviced_idx;
  end
  
  always @(posedge AEOI) begin
    eoi_prev_state <= eoi_current_state;
    eoi_current_state <= eoi_next_state;
  end

endmodule

