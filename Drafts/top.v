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



// Instantiate modules
Control_logic control_logic(.INTA(INTA),.(INT));
ISR isr();
IRQs irqs(.irq_lines(interrupt_requests));
Priority_Resolver priority_resolver();
Read_Write_Logic read_write(.read_enable(read_Enable),.write_enable(write_Enable));
cascade cscd (.SP(slave_program),.casc(cascade_lines));

endmodule