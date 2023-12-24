module top(
    inout [7:0] data_Bus;
    inout [2:0] cascade_lines;
    input read_Enable;
    input write_Enable;
    input A0;
    input chip_select,
    input slave_program;
    input INTA;
    input [7:0] interrupt_requests;
    output INT;
);

// Instantiate internal signals
wire [7:0]  IRQ_status, // Interrupt requests from IRR
//wire [7:0]  IS_status,   //bits from ISR
wire [7:0]  IR_mask,    //Interrupt mask from OCW1
//wire        Rotating_priority ,  //1 for rotating and 0 for fully nested
//wire [2:0]  last_serviced,       //the last serviced priority in ISR
reg  [2:0] PriorityID,  //Selected Priority given to cascade and ISR
reg       INTFLAG      //interrupt flag given to control


// Instantiate modules
Control_logic control_logic(.INTA(INTA),.INT(INT),.special_mask_mode_status(IR_mask),.);
ISR isr();
IRQs irqs(.irq_lines(interrupt_requests),.irq_status(IRQ_status),);

Priority_Resolver priority_resolver(.IRQ_status(IRQ_status),.IS_status(IS_status),.IR_mask(IR_mask),.Rotating_priority(Rotating_priority),.last_serviced(last_serviced),.PriorityID(PriorityID),.INTFLAG(INTFLAG));

Read_Write_Logic read_write(.read_enable(read_Enable),.write_enable(write_Enable));
cascade cscd (.SP(slave_program),.casc(cascade_lines));

endmodule