module top(
  inout [7:0]data_Bus,
  inout [2:0] cascade_lines,
    input read_Enable,
    input write_Enable,
    input A0,
    input chip_select,
    input slave_program,
    input INTA,
  input [7:0] interrupt_requests,
    output INT);

// Instantiate internal signals
  wire [7:0]  IRQ_status; // Interrupt requests from IRR

  wire [7:0]  IR_mask;    //Interrupt mask from OCW1
  wire        Rotating_priority;  //1 for rotating and 0 for fully nested
  wire [2:0]  last_serviced;       //the last serviced priority in ISR

  reg  [2:0] PriorityID;  //Selected Priority given to cascade and ISR
reg       INTFLAG;      //interrupt flag given to control
wire edge_level_trigger; // controller + IRQ
wire AEOI; // controller + ISR 
wire [7:0]interrupt_inservice;
wire first_ack;
wire second_ack;
/**
    Read/Write + Control
*/
wire reset;
wire read_flag;
wire write_flag;
wire EOI_specific_IRQ_index;
wire single_or_cascade;
wire specific_eoi_flag;
wire [1:0] reading_status;
wire [2:0] slave_id;
wire vecFlag;
// Instantiate modules

Control_logic control_logic(.WD(write_flag),.RD(read_flag),.A0(A0),.IRR(IRQ_status),.ISR(interrupt_inservice),.INTA(INTA),.INT(INT),.ICW1_LTIM(edge_level_trigger),.ICW1_SNGL(single_or_cascade),.ICW4_AEOI(AEOI),.data_bus(data_Bus), .highest_priority_ISR(PriorityID),.reset_by_EOI(EOI_specific_IRQ_index),.OCW1(IR_mask),.reading_status(reading_status),.auto_rotate_status(Rotating_priority),.begin_to_set_ISR(first_ack),.send_ISR_to_data_bus(second_ack),.slave_id(slave_id),.vecFlag(vecFlag));


ISR isr(.AEOI(AEOI),.interrupts_in_service(interrupt_inservice),last_serviced_idx(last_serviced),specific_irq(EOI_specific_IRQ_index),ack1(first_ack),ack2(second_ack),.SP(slave_program),.SNGL(single_or_cascade),specific_eoi_flag(specific_eoi_flag),highest_priority_idx(PriorityID));


IRQs irqs(.irq_lines(interrupt_requests),.irq_status(IRQ_status),.trigger(edge_level_trigger),.inta(INTA));

//INTFlag corresponds to What?
Priority_Resolver priority_resolver(.IRQ_status(IRQ_status),.IS_status(interrupt_inservice),.IR_mask(IR_mask),.Rotating_priority(Rotating_priority),.last_serviced(last_serviced),.PriorityID(PriorityID),.INTFLAG(INT));

Read_Write_Logic read_write(.read_enable(read_Enable),.write_enable(write_Enable),.read_flag(read_flag),
.write_flag(write_flag),.chip_select(chip_select),.reset(reset));


cascade cscd (.SP(slave_program),.SNGL(single_or_cascade),.slaveReg(slave_id),.pulse1(begin_to_set_ISR),.pulse2(send_ISR_to_data_bus),.intrID(PriorityID),.casc(cascade_lines),.vecFlag(vecFlag));

endmodule