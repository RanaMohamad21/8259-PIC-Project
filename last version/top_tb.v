// Code your testbench here
// or browse Examples
module top_tb;

reg sp;
reg [7:0]interrupt_requests = 8'b00000000;
reg INTA;
wire [2:0]cascade_lines;
wire [7:0]data_Bus;
reg [7:0] data_bus_container;
reg read_flag;

wire INT_Flag;

reg device1;
reg device2;
reg [1:0]cnt=2'b00;
reg A0;
reg chip_select;
reg write_flag;
top master (.data_Bus(data_Bus),.write_flag(write_flag),.read_flag(read_flag),.sp(sp),.INTA(INTA),.INT_Flag(INT_Flag),.interrupt_requests(interrupt_requests),.chip_select(chip_select),.A0(A0));



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
    data_bus_container=8'bzzzzzzzz;
  /*FOR MASTER*/
/*//ICW1
    #10 chip_select = 1'b0;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
     A0 =1'b0;
    data_bus_container = 8'b00010011;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
    //ICW2
    #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1; 
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00001000;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
     //ICW4
     #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00000010;
    #10 write_flag = 1'b1;
//OCW1
       #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
//OCW3
    #10 chip_select =1'b0;
        A0 = 1'b0;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00001011;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b0;
    #10 interrupt_requests=8'b00010000;
    #10 INTA =1'b0;
    #10 chip_select =1'b0;
    #10 read_flag=1'b0;
    #10 read_flag =1'b1;
    #10 INTA = 1'b1;
    #10 INTA = 1'b0;
    #10 INTA = 1'b1;
    #10 read_flag=1'b0;
    #10 read_flag =1'b1;*/

   //ICW1
    #10 chip_select = 1'b0;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
     A0 =1'b0;
    data_bus_container = 8'b00010011;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
    //ICW2
    #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1; 
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00001000;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
     //ICW4
     #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag = 1'b1;
//OCW1
       #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;


//OCW3 for 
     #10 chip_select =1'b0;
        A0 = 1'b0;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00001010;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b0;
    #10 interrupt_requests=8'b00000001;
    #10 INTA =1'b0;
    #10 INTA = 1'b1;
    #10 read_flag=1'b0;
    #10 read_flag = 1'b1;
    #10 INTA = 1'b0;
    #10 INTA = 1'b1;

    //ocw2
    #10 chip_select =1'b0;
        A0 = 1'b0;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00100000;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b0;
          
    
      #10 read_flag=1'b0;
    #10 read_flag = 1'b1;
  end



endmodule


