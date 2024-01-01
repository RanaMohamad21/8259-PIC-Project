module Priority_Resolver
  (input wire [7:0]  IRQ_status, // Interrupt requests from IRR
   input wire [7:0]  IS_status,   //bits from ISR
   input wire [7:0]  IR_mask,    //Interrupt mask from OCW1 (from control)
   input wire        Rotating_priority ,  //1 for rotating and 0 for fully nested
   input wire [2:0]  last_serviced,       //the last serviced priority in ISR
   output reg [2:0] PriorityID,  //Selected Priority given to cascade and ISR and control
   output reg       INTFLAG      //interrupt flag given to control
  );
  //declare useful variables
  wire [7:0] masked_IRQ;    // to to take into account interrupt mask that might come from control module
  reg [7:0] priority_reg = 8'b00000000;  // Register to store selected priority
  reg [7:0] rotated_priority = 8'b00000000;            //Register to store rotated priority
  reg [7:0] priority_mask = 8'b11111111;  // to take into account bits that are already set in ISR
  
  assign masked_IRQ = IRQ_status & ~IR_mask;
     always @* begin
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
    
  always @(IRQ_status) begin
    //Rotating Priority mode
    if (Rotating_priority == 1'b1) begin 
          // Priority rotation logic
          case (last_serviced)
            3'b000:  rotated_priority = { masked_IRQ[0],   masked_IRQ[7:1] };
            3'b001:  rotated_priority = { masked_IRQ[1:0], masked_IRQ[7:2] };
            3'b010:  rotated_priority = { masked_IRQ[2:0], masked_IRQ[7:3] };
            3'b011:  rotated_priority = { masked_IRQ[3:0], masked_IRQ[7:4] };
            3'b100:  rotated_priority = { masked_IRQ[4:0], masked_IRQ[7:5] };
            3'b101:  rotated_priority = { masked_IRQ[5:0], masked_IRQ[7:6] };
            3'b110:  rotated_priority = { masked_IRQ[6:0], masked_IRQ[7]   };
            3'b111:  rotated_priority = masked_IRQ;    //if last priority serviced was also the lowest priority
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
            3'b000:  priority_reg = { priority_reg[6:0], priority_reg[7] };
            3'b001:  priority_reg = { priority_reg[5:0], priority_reg[7:6] };
            3'b010:  priority_reg = { priority_reg[4:0], priority_reg[7:5] };
            3'b011:  priority_reg = { priority_reg[3:0], priority_reg[7:4] };
            3'b100:  priority_reg = { priority_reg[2:0], priority_reg[7:3] };
            3'b101:  priority_reg = { priority_reg[1:0], priority_reg[7:2] };
            3'b110:  priority_reg = { priority_reg[0], priority_reg[7:1]   };
            3'b111:  priority_reg = priority_reg;    //if last priority serviced was also the lowest priority
            default: priority_reg = priority_reg;         //by default priority is normal (not rotated)
          endcase
   
        
      
            priority_reg = priority_reg & priority_mask;  
			
			if (|priority_reg == 1'b1)   //flag will fire only when an interrupt line wins
			   INTFLAG = 1'b1;
			else   
			   INTFLAG = 1'b0;
			   
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
            
          priority_reg = priority_reg & priority_mask;
		  
		  if (|priority_reg == 1'b1)   //flag will fire only when an interrupt line wins
			   INTFLAG = 1'b1;
		  else   
			   INTFLAG = 1'b0;
        
            
        end
        
		//convert selected priority into an ID for use in cascade and ISR
            if      (priority_reg[0] == 1'b1) PriorityID = 3'b000;
            else if (priority_reg[1] == 1'b1) PriorityID = 3'b001;
            else if (priority_reg[2] == 1'b1) PriorityID = 3'b010;
            else if (priority_reg[3] == 1'b1) PriorityID = 3'b011;
            else if (priority_reg[4] == 1'b1) PriorityID = 3'b100;
            else if (priority_reg[5] == 1'b1) PriorityID = 3'b101;
            else if (priority_reg[6] == 1'b1) PriorityID = 3'b110;
            else if (priority_reg[7] == 1'b1) PriorityID = 3'b111;
            else begin end
      
  end
endmodule


