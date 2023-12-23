module Control_logic(
  input WD,
  input RD,
  input CS,
  input A0,
  input [7:0]IRR,
  input [7:0]ISR,
  input INTA,
  output reg INT,
  output reg ICW1_LTIM, //LTM 1 for level triggered and 0 for edge
  output reg ICW1_ADI, //1->4-bit interval,0->b-bit interval 
  output reg ICW1_SNGL, //1->for single controller, 0 for multiple,so ICW3 will be issued
  output reg ICW1_IC4, //1-> ICW4 needed 0-> not needed
  output reg ICW1_D4, //make it always 1 for ICW1
  output reg ICW4_SFNM,// 1->special fully nested mode is on
  output reg ICW4_BUF, // enable buffered mode
  output reg ICW4_M_OR_S, //master or slave, BUF should be set first
  output reg ICW4_AEOI, //1->auto EOI 
  output reg ICW4_uPM, // 1-> 8086 Mode
  output reg [7:0] vector_address,
  output reg [7:0]ICW1,
  output reg [7:0]ICW3_Master,
  output reg [7:0]ICW3_Slave,
  output reg [7:0] ICW4,
  output reg [7:0] ICW2,
  input wire [7:0]data_bus,
  input wire [2:0] highest_priority_ISR,
  output reg [2:0] reset_by_EOI,
  output reg [7:0]OCW1,
  output reg enable_read_IRR_ISR,
  output reg choose_IRR_ISR,
  output reg specific_rotate_status,
  output reg auto_rotate_status,
  output reg special_mask_mode_status,
  output reg begin_to_set_ISR,
  output reg send_ISR_to_data_bus);
  parameter CONFIG_ICW1 = 3'b000;
  parameter CONFIG_ICW2 = 3'b001;
  parameter CONFIG_ICW3 = 3'b010;
  parameter CONFIG_ICW4 = 3'b011;
  parameter ALL_ICW_CONFIG_DONE = 3'b011;
  parameter SPECIFIC_EOI = 2'b11;
  parameter NON_SPECIFIC_EOI = 2'b01;
  parameter ROTATE_IN_AEOI = 3'b100;
  parameter  DISABLE_ROTATE_IN_AEOI = 3'b000;
  parameter ROTATE_NON_SPECIFIC_EOI = 3'b101;
  parameter ROTATE_SPECIFIC_EOI = 3'b11x;
  parameter CTRL_INITIAL_STATE  = 2'b00;
  parameter FIRST_ACK  = 2'b01;
  parameter SECOND_ACK = 2'b10;
  
   
   
  reg[2:0] current_ICW_state  = CONFIG_ICW1;
  reg[2:0] next_ICW_state;
  

 wire ready_to_config_ICW1;
   wire ready_to_config_ICW2;
    wire ready_to_config_ICW3;
    wire ready_to_config_ICW4;
    wire ready_to_config_OCW1;
    wire ready_to_config_OCW2;
    wire ready_to_config_OCW3;


    assign ready_to_config_ICW1 = (current_ICW_state== CONFIG_ICW1) && ~WD && ~A0 && data_bus[4]&& ~CS;
    assign ready_to_config_ICW2 = (current_ICW_state== CONFIG_ICW2) && ~WD && A0 && ~CS;
    assign ready_to_config_ICW3 = (current_ICW_state== CONFIG_ICW3) && ~WD && A0 && ~CS;
    assign ready_to_config_ICW4 = (current_ICW_state==CONFIG_ICW4) && ~WD && A0 && ~CS;
    assign ready_to_config_OCW1 = (current_ICW_state == ALL_ICW_CONFIG_DONE) && ~WD && ~CS && A0;
    assign ready_to_config_OCW2 = (current_ICW_state == ALL_ICW_CONFIG_DONE) && ~WD && ~CS && ~A0 && ~data_bus[3] && ~data_bus[4];
   assign ready_to_config_OCW3 = (current_ICW_state == ALL_ICW_CONFIG_DONE) && ~WD && ~CS && ~A0 && data_bus[3] && ~data_bus[4] && ~data_bus[7];


  reg posedge_INTA;
   reg negedge_INTA;
  reg INTA_old=1;
  always@(INTA)
  begin
    posedge_INTA <= ~INTA_old && INTA;
    negedge_INTA <= INTA_old && ~INTA;
   end
   always@(*)
   begin
    INTA_old <=   INTA;
   end
   
 
   wire ready_to_process_interrupts = (current_ICW_state == ALL_ICW_CONFIG_DONE);
   
   reg [1:0]state_of_ctrl_logic =  CTRL_INITIAL_STATE;
   reg [1:0]next_state_of_ctrl_logic;

always @(state_of_ctrl_logic,INTA)
begin
     begin_to_set_ISR <= (state_of_ctrl_logic==FIRST_ACK);
     send_ISR_to_data_bus <= (state_of_ctrl_logic==SECOND_ACK); 
end
 
   always @(INTA)
begin
  if (ready_to_process_interrupts)
  begin
    case (state_of_ctrl_logic)
      CTRL_INITIAL_STATE:
      begin
        
        if (negedge_INTA == 1'b1) 
          next_state_of_ctrl_logic <= FIRST_ACK;
        else
         next_state_of_ctrl_logic <= CTRL_INITIAL_STATE;
      end
      FIRST_ACK:
      begin
        if (negedge_INTA == 1'b1 )
          next_state_of_ctrl_logic <= SECOND_ACK;
        else
        next_state_of_ctrl_logic <= FIRST_ACK;
      end
      SECOND_ACK:
      begin
        if (posedge_INTA == 1'b1)
          next_state_of_ctrl_logic <= CTRL_INITIAL_STATE;
      end
      default:
      begin
        next_state_of_ctrl_logic <= CTRL_INITIAL_STATE;
      end
    endcase
    
  end
end

      
   always@(*)
   begin
   if(ready_to_process_interrupts)
    begin
      state_of_ctrl_logic <= next_state_of_ctrl_logic;  
    end
   end

   
   
  always @(data_bus) begin 
    case (current_ICW_state)
      CONFIG_ICW1:
      begin
      if(ready_to_config_ICW1)
       begin
          ICW1_IC4 <=data_bus[0];
          ICW1_SNGL <=data_bus[1];
          ICW1_ADI <=data_bus[2];
          ICW1_LTIM <=data_bus[3];
          next_ICW_state <= CONFIG_ICW2;
       end
     else
       begin
       ICW1_IC4<= 1'b0;
       ICW1_SNGL <=1'b1;
       ICW1_ADI <=1'b0;
       ICW1_LTIM <=1'b0;
       next_ICW_state <= CONFIG_ICW1;
       end
     end
      CONFIG_ICW2:
      begin
      if(ready_to_config_ICW2)
        begin
          ICW2[3] <=data_bus[3];
          ICW2[4] <=data_bus[4];
          ICW2[5] <=data_bus[5];
          ICW2[6] <=data_bus[6];
          ICW2[7] <=data_bus[7];
          vector_address[7:3] <= data_bus[7:3];//starting address of interrupts
        if(ICW1_SNGL)
          begin
         if(ICW1_IC4)
           next_ICW_state <= CONFIG_ICW4;
          else
           next_ICW_state <= ALL_ICW_CONFIG_DONE;
         end
         else 
           next_ICW_state <= CONFIG_ICW3;
        end
    else
       begin
       ICW2[7:3]  = 5'b00000;
       vector_address[7:3] = 5'b00000;
       next_ICW_state <= CONFIG_ICW2;
       end
    end
      CONFIG_ICW3:
      begin
        if(ready_to_config_ICW3)
          begin
          ICW3_Master[7:0] <=data_bus[7:0];
          ICW3_Slave[3:0] <=data_bus[3:0];
          ICW3_Slave[7:4] <= 4'b0000;
        if(ICW1_IC4)
          next_ICW_state <= CONFIG_ICW4;
        else
          next_ICW_state <= ALL_ICW_CONFIG_DONE;
        end
      else
        begin
        ICW3_Master[7:0] <=8'b00000000;
          ICW3_Slave[3:0] <=4'b0000;
          ICW3_Slave[7:4] <= 4'b0000;
          next_ICW_state <= CONFIG_ICW3;
        end
      end
      CONFIG_ICW4:
      begin
          if(ready_to_config_ICW4)
            begin
              ICW4_uPM<= data_bus[0];
              ICW4_AEOI<= data_bus[1];
              ICW4_M_OR_S<= data_bus[2];
              ICW4_BUF<= data_bus[3];
          next_ICW_state <= ALL_ICW_CONFIG_DONE;
          end
        else
          begin
            ICW4_uPM<= 1'b0;
            ICW4_AEOI<= 1'b0;
              ICW4_M_OR_S<= 1'b0;
              ICW4_BUF<= 1'b0;
              next_ICW_state <= CONFIG_ICW4;
          end
      end
      default:
      begin
    end
      
     
  endcase
  
end
 
always@(next_ICW_state)
begin
current_ICW_state <= next_ICW_state;
end


//determine masked or unmasked interrupts.
always@(ready_to_config_OCW1)
begin
if(ALL_ICW_CONFIG_DONE && ready_to_config_OCW1)
  OCW1[7:0] <= data_bus[7:0];
else
  OCW1[7:0] <= 8'b00000000;
end
/* determines which IS to be reset
/* for specific EOI we take the ID we act upon from the OCW2 register
* for non-specific EOI we reset the IS which has the highest priority and it will be known from the priority resolver*/
always@(ready_to_config_OCW2)
begin
if(ready_to_config_OCW2)
  begin
  case(data_bus[6:5])
  SPECIFIC_EOI:
     reset_by_EOI = data_bus[2:0];
  NON_SPECIFIC_EOI:
     reset_by_EOI = highest_priority_ISR; //taken from the priority resolver
     endcase
     end
else
  OCW1[7:0] <= 8'b00000000;
end

//auto rotate
always@(ready_to_config_OCW2)
begin
 if(ready_to_config_OCW2)
  case(data_bus[7:5])
    ROTATE_IN_AEOI:
       auto_rotate_status = 1'b1;
    DISABLE_ROTATE_IN_AEOI:
       auto_rotate_status= 1'b0;
  endcase
 else
   auto_rotate_status <= 1'b0;
end

//specific rotate
always@(ready_to_config_OCW2)
begin
 if(ready_to_config_OCW2)
  case(data_bus[7:5])
  ROTATE_NON_SPECIFIC_EOI:
       specific_rotate_status = 1'b1;
    ROTATE_SPECIFIC_EOI:
       specific_rotate_status= 1'b0;
  endcase
 else
   specific_rotate_status <= 1'b0;
end

always@(ready_to_config_OCW3)
begin
  if(ready_to_config_OCW3 && data_bus[6])
    special_mask_mode_status<= data_bus[5]; //there is two modes, special and not special
  else
    special_mask_mode_status <=1'b0;
end

always@(ready_to_config_OCW3)
begin


 if(ready_to_config_OCW3)
    begin
        enable_read_IRR_ISR <= data_bus[1];
        choose_IRR_ISR <= data_bus[0];
    end
else
    begin
    enable_read_IRR_ISR <= 1'b0;
    choose_IRR_ISR <= 1'b0;
    
    end
    
end




always@(IRR)
begin
if(IRR !=8'b00000000)
INT<=1'b1;
else
INT<=1'b0;
end


/*needed to be done: sending the vector address to the data bus*/

endmodule


  



