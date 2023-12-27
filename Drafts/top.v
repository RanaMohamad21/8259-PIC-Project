


module top;
    
  
   wire [7:0]  IRQ_status;
   wire [7:0]interrupt_inservice;
   wire [2:0]  last_serviced;
   wire [2:0] PriorityID;
  wire [7:0]data_Bus;
  wire [2:0] cascade_lines;
  reg [7:0] data_bus_container;
  
    reg read_flag;
    reg write_flag;
    reg A0;
    reg chip_select;
    reg slave_program;
    reg INTA;
  	reg [7:0] interrupt_requests;
    wire INT;
    wire first_ack;
    wire second_ack;

// Instantiate internal signals
  // Interrupt requests from IRR

  wire [7:0]  IR_mask;    //Interrupt mask from OCW1
  wire        Rotating_priority;  //1 for rotating and 0 for fully nested
      //the last serviced priority in ISR

   //Selected Priority given to cascade and ISR
  reg       INTFLAG;      //interrupt flag given to control
  wire edge_level_trigger; // controller + IRQ
  wire AEOI; // controller + ISR 


  wire INT_Flag;
 /**
    Read/Write + Control
*/
wire read_Enable;
wire write_Enable;
wire [2:0]EOI_specific_IRQ_index;
wire single_or_cascade;
wire specific_eoi_flag;
wire [1:0] reading_status;
wire [2:0] slave_id;
wire vecFlag;
// Instantiate modules
reg sp = 1'b1;
    
 

Control_logic control_logic(.WD(write_Enable),.RD(read_Enable),.A0(A0),.IRR(IRQ_status),.ISR(interrupt_inservice),.INTA(INTA),.INT(INT),.ICW1_LTIM(edge_level_trigger),.ICW1_SNGL(single_or_cascade),.ICW4_AEOI(AEOI),.data_bus(data_Bus), .highest_priority_ISR(PriorityID),.reset_by_EOI(EOI_specific_IRQ_index),.OCW1(IR_mask),.reading_status(reading_status),.auto_rotate_status(Rotating_priority),.specific_eoi_status(specific_eoi_flag),.begin_to_set_ISR(first_ack),.send_ISR_to_data_bus(second_ack),.slave_id(slave_id),.vecFlag(vecFlag),.INT_Flag(INT_Flag),.sp(sp));


ISR isr(.AEOI(AEOI),.interrupts_in_service(interrupt_inservice),.last_serviced_idx(last_serviced),.specific_irq(EOI_specific_IRQ_index),.ack1(first_ack),.ack2(second_ack),.SP(slave_program),.SNGL(single_or_cascade),.specific_eoi_flag(specific_eoi_flag),.highest_priority_idx(PriorityID));


IRQs irqs(.irq_lines(interrupt_requests),.irq_status(IRQ_status),.trigger(edge_level_trigger),.inta(first_ack),.highest_priority_idx(PriorityID));

//INTFlag corresponds to What?
Priority_Resolver priority_resolver(.IRQ_status(IRQ_status),.IS_status(interrupt_inservice),.IR_mask(IR_mask),.Rotating_priority(Rotating_priority),.last_serviced(last_serviced),.PriorityID(PriorityID),.INTFLAG(INT_Flag));

Read_Write_Logic read_write(.read_enable(read_Enable),.write_enable(write_Enable),.read_flag(read_flag),
.write_flag(write_flag),.chip_select(chip_select));


cascade cscd (.SP(slave_program),.SNGL(single_or_cascade),.slaveReg(slave_id),.pulse1(begin_to_set_ISR),.pulse2(send_ISR_to_data_bus),.intrID(PriorityID),.casc(cascade_lines),.vecFlag(vecFlag));

   
  assign data_Bus = ( write_Enable==1'b0)? data_bus_container:8'bzzzzzzzz;
  
   initial begin
   sp = 1'b1;
    // Initialize inputs
    //ICW1
    read_flag = 1'b1;
    write_flag=1'b1;
    INTA = 1'b1;
    chip_select = 1'b1;
    
    #10 chip_select = 1'b0;
    
    
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
     A0 =1'b0;
    data_bus_container = 8'b00010001;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
    //ICW2
    #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1; 
    #10 write_flag = 1'b0;
        data_bus_container = 8'b11110000;
    #10 write_flag = 1'b1;
    //ICW3
    #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1; 
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00000111;
    #10 write_flag = 1'b1;
    //ICW4
     #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00001111;
    #10 write_flag = 1'b1;
    //OCW2  
    
       #10 chip_select =1'b0;
        A0 = 1'b0;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag = 1'b1;
    #10 interrupt_requests = 8'b0000001;
        #10 INTA =0;
        #10 INTA =1;
        #10 INTA = 0;
        #10 INTA = 1;
        #10 read_flag = 1'b0;
        #10 read_flag = 1'b1;
    
/*#10 interrupt_requests = 8'b11010000;
        #10 INTA =0;
        #10 INTA =1;
        #10 INTA = 0;
        #10 INTA = 1;
        #10 read_flag = 1'b0;
        #10 read_flag = 1'b1;
#10 interrupt_requests = 8'b00010110;
        #10 INTA =0;
        #10 INTA =1;
        #10 INTA = 0;
        #10 INTA = 1;
        #10 read_flag = 1'b0;
        #10 read_flag = 1'b1;*/
    
  end



    /*#10
    write_Enable = 1;
    #10
    write_Enable = 0;
    #10
    write_Enable = 1;
    
    A0 = 0;
    chip_select = 0;
    slave_program = 0;
    INTA = 0;
    interrupt_requests = 8'b00000001;
	#20
    data_bus_container = 8'b01100111;
    #100;*/

endmodule