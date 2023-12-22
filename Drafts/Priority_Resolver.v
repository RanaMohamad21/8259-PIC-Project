module Priority_Resolver
  (input wire        INTA,       //Interrupt acknowledge signal (active low)
   input wire [7:0]  IRQ_status, // Interrupt requests from IRR
   input wire [7:0]  IS_status,   //bits from ISR
   input wire [7:0]  IR_mask,    //Interrupt mask from OCW1
   input wire        Rotating_priority ,  //1 for rotating and 0 for fully nested
   input wire [7:0]  last_serviced,       //the last serviced priority in ISR
   output reg [7:0] Priority   // Selected priority given to ISR
   
  );
  //declare useful variables
  wire [7:0] masked_IRQ;
  assign masked_IRQ = IRQ_status & ~IR_mask;
  reg [7:0] priority_reg = 8'b00000000;  // Register to store selected priority
  reg [7:0] rotated_priority;            //Register to store rotated priority
  reg [7:0] priority_mask;  // to take into account bits that are already set in ISR
      always@* begin
        if      (IS_status[0] == 1'b1) priority_mask = 8'b00000000;
        else if (IS_status[1] == 1'b1) priority_mask = 8'b00000001;
        else if (IS_status[2] == 1'b1) priority_mask = 8'b00000011;
        else if (IS_status[3] == 1'b1) priority_mask = 8'b00000111;
        else if (IS_status[4] == 1'b1) priority_mask = 8'b00001111;
        else if (IS_status[5] == 1'b1) priority_mask = 8'b00011111;
        else if (IS_status[6] == 1'b1) priority_mask = 8'b00111111;
        else if (IS_status[7] == 1'b1) priority_mask = 8'b01111111;
        else                           priority_mask = 8'b11111111;
    end
    
  always @* begin
    //Rotating Priority mode
    if (Rotating_priority == 1'b1) begin 
          // Priority rotation logic
          case (last_serviced) // how to know what was the last priority that was serviced? (assume its an input for now)
            8'b00000001:  rotated_priority = { masked_IRQ[0],   masked_IRQ[7:1] };
            8'b00000010:  rotated_priority = { masked_IRQ[1:0], masked_IRQ[7:2] };
            8'b00000100:  rotated_priority = { masked_IRQ[2:0], masked_IRQ[7:3] };
            8'b00001000:  rotated_priority = { masked_IRQ[3:0], masked_IRQ[7:4] };
            8'b00010000:  rotated_priority = { masked_IRQ[4:0], masked_IRQ[7:5] };
            8'b00100000:  rotated_priority = { masked_IRQ[5:0], masked_IRQ[7:6] };
            8'b01000000:  rotated_priority = { masked_IRQ[6:0], masked_IRQ[7]   };
            8'b10000000:  rotated_priority = masked_IRQ;    //if last priority serviced was also the lowest priority
            default: rotated_priority = masked_IRQ;         //by default priority is normal (not rotated)
          endcase
        
        //priority resolution logic
          if      (rotated_priority[0] == 1'b1)    priority_reg = rotated_priority & 8'b00000001;
          else if (rotated_priority[1] == 1'b1)    priority_reg = rotated_priority & 8'b00000010;
          else if (rotated_priority[2] == 1'b1)    priority_reg = rotated_priority & 8'b00000100;
          else if (rotated_priority[3] == 1'b1)    priority_reg = rotated_priority & 8'b00001000;
          else if (rotated_priority[4] == 1'b1)    priority_reg = rotated_priority & 8'b00010000;
          else if (rotated_priority[5] == 1'b1)    priority_reg = rotated_priority & 8'b00100000;
          else if (rotated_priority[6] == 1'b1)    priority_reg = rotated_priority & 8'b01000000;
          else if (rotated_priority[7] == 1'b1)    priority_reg = rotated_priority & 8'b10000000;
          else                               priority_reg = rotated_priority & 8'b00000000;
            
         //we need to return to normal unrotated output
         case (last_serviced)
            8'b00000001:  priority_reg = { priority_reg[6:0], priority_reg[7] };
            8'b00000010:  priority_reg = { priority_reg[5:0], priority_reg[7:6] };
            8'b00000100:  priority_reg = { priority_reg[4:0], priority_reg[7:5] };
            8'b00001000:  priority_reg = { priority_reg[3:0], priority_reg[7:4] };
            8'b00010000:  priority_reg = { priority_reg[2:0], priority_reg[7:3] };
            8'b00100000:  priority_reg = { priority_reg[1:0], priority_reg[7:2] };
            8'b01000000:  priority_reg = { priority_reg[0], priority_reg[7:1]   };
            8'b10000000:  priority_reg = priority_reg;    //if last priority serviced was also the lowest priority
            default: priority_reg = priority_reg;         //by default priority is normal (not rotated)
          endcase
   
        
      
          if (INTA == 1'b0)   Priority = priority_reg & priority_mask;  //someting is wrong here

    end else begin
    //Fully nested Mode
        // Priority resolution logic
          if      (IRQ_status[0] == 1'b1)    priority_reg = masked_IRQ & 8'b00000001;
          else if (IRQ_status[1] == 1'b1)    priority_reg = masked_IRQ & 8'b00000010;
          else if (IRQ_status[2] == 1'b1)    priority_reg = masked_IRQ & 8'b00000100;
          else if (IRQ_status[3] == 1'b1)    priority_reg = masked_IRQ & 8'b00001000;
          else if (IRQ_status[4] == 1'b1)    priority_reg = masked_IRQ & 8'b00010000;
          else if (IRQ_status[5] == 1'b1)    priority_reg = masked_IRQ & 8'b00100000;
          else if (IRQ_status[6] == 1'b1)    priority_reg = masked_IRQ & 8'b01000000;
          else if (IRQ_status[7] == 1'b1)    priority_reg = masked_IRQ & 8'b10000000;
          else                               priority_reg = masked_IRQ & 8'b00000000;
            
          if (INTA == 1'b0)  Priority = priority_reg & priority_mask;
       //should I only output the priority if I receive interrupt acknowldge?  
            
        end
      
      
  end
endmodule

