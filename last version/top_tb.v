// Code your testbench here
// or browse Examples
module top_tb;

reg sp;
reg [7:0]interrupt_requests;
reg [7:0]interrupt_requests1;
reg [7:0]interrupt_requests2;
reg [7:0]interrupt_requests3;
reg [7:0]interrupt_requests4;
reg [7:0]interrupt_requests5;
reg [7:0]interrupt_requests6;
reg INTA;
wire [2:0]cascade_lines;
wire [7:0]data_Bus;
reg [7:0] data_bus_container;
reg read_flag;
reg write_flag;
reg read_flag1;
reg write_flag1;
reg read_flag2;
reg write_flag2;
reg read_flag3;
reg write_flag3;
reg read_flag4;
reg write_flag4;
reg read_flag5;
reg write_flag5;
reg read_flag6;
reg write_flag6;
wire INT_Flag;
wire INT_Flag1;
wire INT_Flag2;
wire INT_Flag3;
wire INT_Flag4;
wire INT_Flag5;
wire INT_Flag6;
reg device1;
reg device2;
reg [1:0]cnt=2'b00;
reg A0;
reg chip_select;

top master (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag),.read_flag(read_flag),.sp(sp),.INTA(INTA),.INT_Flag(INT_Flag),.A0(A0),.chip_select(chip_select),.interrupt_requests(interrupt_requests));



assign data_Bus = (cnt==2'b10)? data_bus_container:8'bzzzzzzzz;
always@(negedge write_flag or posedge write_flag )
begin
if(write_flag==1'b0)
cnt = cnt +1;
if(write_flag==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end

  initial begin
   sp = 1'b1;

    read_flag = 1'b1;
    write_flag=1'b1;
    INTA = 1'b1;
    chip_select = 1'b1;
    //ICWQ
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
     #10 interrupt_requests = 8'b0000010;
        #10 INTA =0;
        #10 INTA =1;
        #10 INTA = 0;
        #10 INTA = 1;
  end



endmodule


