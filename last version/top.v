module top(input wire SP,
input wire [7:0]IR,
input wire INTA,
inout[2:0] CAS,
inout [7:0] D,
input wire RD, 
input wire WR,
output wire INT,
input wire CS,
input wire A0);
    
  
   wire [7:0]  IRQ_status;
   wire [7:0]interrupt_inservice;
   wire [2:0]  last_serviced;
   wire [2:0] PriorityID;
   reg [7:0] data_bus_container;
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
 /**
    Read/Write + Control
*/
wire read_Enable;
wire write_Enable;
wire [2:0]EOI_SPecific_IRQ_index;
wire single_or_cascade;
wire SPecific_eoi_flag;
wire [1:0] reading_status;
wire [2:0] slave_id;
wire [2:0] intr_id;
wire vecFlag;



Control_logic control_logic(.WD(write_Enable),.RD(RD),.A0(A0),.IRR(IRQ_status),.ISR(interrupt_inservice),.INTA(INTA),.ICW1_LTIM(edge_level_trigger),.ICW1_SNGL(single_or_cascade),.ICW4_AEOI(AEOI),.data_bus(D), .highest_priority_ISR(PriorityID),.reset_by_EOI(EOI_SPecific_IRQ_index),.OCW1(IR_mask),.reading_status(reading_status),.auto_rotate_status(Rotating_priority),.SPecific_eoi_status(SPecific_eoi_flag),.begin_to_set_ISR(first_ack),.send_ISR_to_data_bus(second_ack),.slave_id(slave_id),.vecFlag(vecFlag),.INT(INT),.SP(SP),.intr_id(intr_id));


ISR isr(.AEOI(AEOI),.interrupts_in_service(interrupt_inservice),.last_serviced_idx(last_serviced),.SPecific_irq(EOI_SPecific_IRQ_index),.ack1(first_ack),.ack2(second_ack),.SP(slave_program),.SNGL(single_or_cascade),.SPecific_eoi_flag(SPecific_eoi_flag),.highest_priority_idx(PriorityID));


IRQs irqs(.irq_lines(IR),.irq_status(IRQ_status),.trigger(edge_level_trigger),.inta(first_ack),.highest_priority_idx(PriorityID));

//INTFlag correSPonds to What?
Priority_Resolver priority_resolver(.IRQ_status(IRQ_status),.IS_status(interrupt_inservice),.IR_mask(IR_mask),.Rotating_priority(Rotating_priority),.last_serviced(last_serviced),.PriorityID(PriorityID),.INTFLAG(INT));

Read_Write_Logic read_write(.read_enable(read_Enable),.write_enable(write_Enable),.RD(RD),
.WR(WR),.CS(CS));


cascade cscd (.SP(SP),.SNGL(single_or_cascade),.slaveReg(slave_id),.pulse1(first_ack),.pulse2(second_ack),.intrID(intr_id),.casc(CAS),.vecFlag(vecFlag));

   




  

endmodule
