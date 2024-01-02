module Control_logic(
  input WD,
  input RD,
  input A0,
  input [7:0]IRR,
  input [7:0]ISR,
  input INTA,
  output reg INT,
  output reg ICW1_LTIM, //LTM 1 for level triggered and 0 for edge
  output reg ICW1_SNGL, //1->for single controller, 0 for multiple,so ICW3 will be issued
  output reg ICW4_AEOI, //1->auto EOI 
  inout wire [7:0]data_bus, //the  data bus buffer(output during reading, input during writing)
  input wire [2:0] highest_priority_ISR, //will be determined from the priority resolver.
  output reg [2:0] reset_by_EOI, //store the ID of the ISR bit that needs to be reset by the ISR.
  output reg [7:0]OCW1, //interrupt mask register
  output reg [1:0]reading_status, //determine which register needed to be read(IRR or ISR))
  output reg auto_rotate_status, //auto rotate mode
  output reg specific_eoi_status,
  output reg begin_to_set_ISR = 1'b0, //first ACK
  output reg send_ISR_to_data_bus = 1'b0, //second ACK
  output reg [2:0]slave_id,
  input wire vecFlag,
  input wire INT_Flag,
  input wire sp,
  output reg[2:0] intr_id ); 
  parameter CONFIG_ICW1 = 3'b000;
  parameter CONFIG_ICW2 = 3'b001;
  parameter CONFIG_ICW3 = 3'b010;
  parameter CONFIG_ICW4 = 3'b011;
  parameter ALL_ICW_CONFIG_DONE = 3'b100;
  parameter SPECIFIC_EOI = 2'b11;
  parameter NON_SPECIFIC_EOI = 2'b01;
  parameter ROTATE_IN_AEOI = 3'b100;
  parameter  DISABLE_ROTATE_IN_AEOI = 3'b000;
   reg [7:0]data_bus_container=8'bzzzzzzzz;
  reg ICW1_IC4; //1-> ICW4 needed 0-> not needed
  reg [7:0] vector_address; //vector address will be sent on the data bus
  reg [7:0] ICW2; //ICW2 register
  reg ICW4_BUF;
  reg ICW4_M_OR_S; //master or slave, BUF should be set first

  reg[2:0] current_ICW_state  = CONFIG_ICW1;
  reg[2:0] next_ICW_state;
 reg [7:0]ICW3;
 reg  cnt = 1'b0;



   wire ready_to_config_ICW1;
   wire ready_to_config_ICW2;
    wire ready_to_config_ICW3;
    wire ready_to_config_ICW4;
    wire ready_to_config_OCW1;
    wire ready_to_config_OCW2;
    wire ready_to_config_OCW3;


    assign ready_to_config_ICW1 = (current_ICW_state == CONFIG_ICW1) && ~WD && ~A0 && data_bus[4];
    assign ready_to_config_ICW2 = (current_ICW_state == CONFIG_ICW2) && ~WD && A0;
    assign ready_to_config_ICW3 = (current_ICW_state == CONFIG_ICW3) && ~WD && A0;
    assign ready_to_config_ICW4 = (current_ICW_state == CONFIG_ICW4) && ~WD && A0;
    assign ready_to_config_OCW1 = (current_ICW_state == ALL_ICW_CONFIG_DONE) && ~WD && A0;
    assign ready_to_config_OCW2 = (current_ICW_state == ALL_ICW_CONFIG_DONE) && ~WD && ~A0 && ~data_bus[3] && ~data_bus[4];
    assign ready_to_config_OCW3 = (current_ICW_state == ALL_ICW_CONFIG_DONE) && ~WD  && ~A0 && data_bus[3] && ~data_bus[4] && ~data_bus[7];


  
   wire ready_to_process_interrupts = (current_ICW_state == ALL_ICW_CONFIG_DONE);

   
   

   always@(posedge INTA)
   begin
    begin_to_set_ISR <= 1'b0;
    send_ISR_to_data_bus <= 1'b0;
   end
   

   always@(negedge INTA)
   begin
    if(cnt==1'b0)
    begin
      begin_to_set_ISR <= 1'b1;
      send_ISR_to_data_bus <= 1'b0;
      cnt <= 1'b1;
if( sp && ~ICW1_SNGL)
begin
if( (ICW3>>$bits(highest_priority_ISR)) & 1)
begin
intr_id = highest_priority_ISR[2:0];
end
end
    
    end
    else
    begin
    begin_to_set_ISR <= 1'b0;
    send_ISR_to_data_bus <= 1'b1;
    cnt = 1'b0;
    end
   end
   always@(posedge INT_Flag)
   begin
    INT<= 1'b1;
   end
   always@(negedge INTA)
   begin
    INT <= 1'b0;
   end


   

   
   
  always @(WD) begin 
    case (current_ICW_state)
      CONFIG_ICW1:
      begin
      if(ready_to_config_ICW1)
       begin
          ICW1_IC4 =data_bus[0];
          ICW1_SNGL =data_bus[1];
          ICW1_LTIM =data_bus[3];
          next_ICW_state = CONFIG_ICW2;
       end
     else
       begin
       ICW1_IC4= 1'b0;
       ICW1_SNGL =1'b1;
       ICW1_LTIM =1'b0;
       next_ICW_state = CONFIG_ICW1;
       end
     end
      CONFIG_ICW2:
      begin
      if(ready_to_config_ICW2)
        begin
          ICW2[3] =data_bus[3];
          ICW2[4] =data_bus[4];
          ICW2[5] =data_bus[5];
          ICW2[6] =data_bus[6];
          ICW2[7] =data_bus[7];
          vector_address[7:3] = data_bus[7:3];//starting address of interrupts
        if(ICW1_SNGL)
          begin
         if(ICW1_IC4)
           next_ICW_state = CONFIG_ICW4;
          else
           next_ICW_state = ALL_ICW_CONFIG_DONE;
         end
         else 
           next_ICW_state = CONFIG_ICW3;
        end
    else
       begin
       ICW2[7:3]  = 5'b00000;
       vector_address[7:3] = 5'b00000;
       next_ICW_state = CONFIG_ICW2;
       end
    end
      CONFIG_ICW3:
      begin
        if(ready_to_config_ICW3)
          begin
          ICW3[7:0] =data_bus[7:0];
          if(sp==1'b0)
          begin
          slave_id = data_bus[2:0];
          end
          else
          begin
          slave_id = 3'bzzz;
          end
        if(ICW1_IC4)
          next_ICW_state = CONFIG_ICW4;
        else
          next_ICW_state = ALL_ICW_CONFIG_DONE;
        end
      else
        begin
        ICW3 = 8'b00000000;
          next_ICW_state = CONFIG_ICW3;
        end
      end
      CONFIG_ICW4:
      begin
          if(ready_to_config_ICW4)
            begin
             
              ICW4_AEOI = data_bus[1];
              ICW4_M_OR_S = data_bus[2];
              ICW4_BUF = data_bus[3];
             
          next_ICW_state = ALL_ICW_CONFIG_DONE;
          end
          else
          begin
            
              ICW4_AEOI<= 1'b0;
              ICW4_M_OR_S<= 1'b0;
              ICW4_BUF <=1'b0;
             
          next_ICW_state <=CONFIG_ICW4;
          end
      end
      default:
      begin
    end
      
     
  endcase
  
end
 
always@(next_ICW_state)
begin
current_ICW_state = next_ICW_state;
end


//determine masked or unmasked interrupts.
always@(WD)
begin
if(ready_to_config_OCW1 == 1'b1 && WD == 1'b0)
  OCW1[7:0] <= data_bus[7:0];

end
/* determines which IS to be reset
/* for specific EOI we take the ID we act upon from the OCW2 register
* for non-specific EOI we reset the IS which has the highest priority and it will be known from the priority resolver*/
always@(negedge WD)
begin
if(ready_to_config_OCW2 == 1'b1)
  begin
  case(data_bus[6:5])
  SPECIFIC_EOI:
  begin
     reset_by_EOI = data_bus[2:0];
     specific_eoi_status = 1'b1;

  end
  NON_SPECIFIC_EOI:
  begin
     reset_by_EOI = highest_priority_ISR; //taken from the priority resolver
     specific_eoi_status = 1'b0;
  end
     endcase
     end
end

//auto rotate
always@(WD)
begin
 if(ready_to_config_OCW2 == 1'b1 && WD==1'b0)
  case(data_bus[7:5])
    ROTATE_IN_AEOI:
       auto_rotate_status = 1'b1;
    DISABLE_ROTATE_IN_AEOI:
       auto_rotate_status= 1'b0;
  endcase
 else
   auto_rotate_status <= 1'b0;
end





always@(negedge WD)
begin


 if(ready_to_config_OCW3 ==1'b1)
    begin     
        reading_status[1:0] = data_bus[1:0];
    end
else
    begin
     end  
end

always@(negedge RD)
begin
if (reading_status == 2'b10)
        begin
            data_bus_container = IRR;
        end 
        else if (reading_status == 2'b11)
        begin
           data_bus_container = ISR;
        end
end
always@(posedge RD or negedge send_ISR_to_data_bus)
begin
  data_bus_container=8'bzzzzzzzz;
end


always@(posedge vecFlag)
begin
if(sp ==1'b0)
begin

  vector_address[2:0] = highest_priority_ISR;
   data_bus_container = vector_address;
   
  end
end


always@(posedge send_ISR_to_data_bus)
begin

if(sp==1'b1   && ICW1_SNGL == 1'b0)
begin
if(ICW3>>highest_priority_ISR & 1==1'b0)
begin
 vector_address[2:0] = highest_priority_ISR;
 data_bus_container = vector_address;
end
end
else if(sp==1'b1   && ICW1_SNGL == 1'b1)
begin
 vector_address[2:0] = highest_priority_ISR;
 data_bus_container = vector_address;
end



end
 







assign data_bus = (WD==1'b1)?data_bus_container:(8'bzzzzzzzz);







endmodule


  



