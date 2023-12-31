module top_cascad_tb;
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
reg A0;
reg A01;
reg A02;
reg A03;
reg A04;
reg A05;
reg A06;
reg chip_select;
reg chip_select1;
reg chip_select2;
reg chip_select3;
reg chip_select4;
reg chip_select5;
reg chip_select6;
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
reg sp;
reg sp1;
reg sp2;
reg sp3;
reg sp4;
reg sp5;
reg sp6;
reg [1:0]cnt=2'b00;

always@(*)
begin
    interrupt_requests <= {device2,device1, INT_Flag6,INT_Flag5,INT_Flag4,INT_Flag3,INT_Flag2,INT_Flag1};
end


assign data_Bus = (cnt==2'b10)? data_bus_container:8'bzzzzzzzz;
always@(negedge write_flag1 or posedge write_flag1 )
begin
if(write_flag1==1'b0)
cnt = cnt +1;
if(write_flag1==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag2 or posedge write_flag2 )
begin
if(write_flag2==1'b0)
cnt = cnt +1;
if(write_flag2==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag3 or posedge write_flag3 )
begin
if(write_flag3==1'b0)
cnt = cnt +1;
if(write_flag3==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag4 or posedge write_flag4 )
begin
if(write_flag4==1'b0)
cnt = cnt +1;
if(write_flag4==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag5 or posedge write_flag5 )
begin
if(write_flag5==1'b0)
cnt = cnt +1;
if(write_flag5==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag6 or posedge write_flag6 )
begin
if(write_flag6==1'b0)
cnt = cnt +1;
if(write_flag6==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag or posedge write_flag)
begin
if(write_flag==1'b0)
cnt = cnt +1;
if(write_flag==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end


top master (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag),.read_flag(read_flag),.sp(sp),.INTA(INTA),.INT_Flag(INT_Flag),.interrupt_requests(interrupt_requests),.chip_select(chip_select),.A0(A0));
top slave1 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag1),.read_flag(read_flag1),.sp(sp1),.INTA(INTA),.INT_Flag(INT_Flag1),.interrupt_requests(interrupt_requests1),.chip_select(chip_select1),.A0(A01));
top slave2 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag2),.read_flag(read_flag2),.sp(sp2),.INTA(INTA),.INT_Flag(INT_Flag2),.interrupt_requests(interrupt_requests2),.chip_select(chip_select2),.A0(A02));
top slave3 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag3),.read_flag(read_flag3),.sp(sp3),.INTA(INTA),.INT_Flag(INT_Flag3),.interrupt_requests(interrupt_requests3),.chip_select(chip_select3),.A0(A03));
top slave4 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag4),.read_flag(read_flag4),.sp(sp4),.INTA(INTA),.INT_Flag(INT_Flag4),.interrupt_requests(interrupt_requests4),.chip_select(chip_select4),.A0(A04));
top slave5 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag5),.read_flag(read_flag5),.sp(sp5),.INTA(INTA),.INT_Flag(INT_Flag5),.interrupt_requests(interrupt_requests5),.chip_select(chip_select5),.A0(A05));
top slave6 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag6),.read_flag(read_flag6),.sp(sp6),.INTA(INTA),.INT_Flag(INT_Flag6),.interrupt_requests(interrupt_requests6),.chip_select(chip_select6),.A0(A06));

initial begin
    sp=1'b1;
    sp1=1'b0;
    sp2=1'b0;
    sp3=1'b0;
    sp4=1'b0;
    sp5=1'b0;
    sp6=1'b0;
   // data_bus_container=8'bzzzzzzzz;
    device1 = 1'b0;
    device2 = 1'b0;
    interrupt_requests=8'b00000000;
    interrupt_requests1 =8'b00000000;
    interrupt_requests2 =8'b00000000;
    interrupt_requests3 =8'b00000000;
    interrupt_requests4 =8'b00000000;
    interrupt_requests5 =8'b00000000;
    interrupt_requests6 =8'b00000000;
//master
    read_flag = 1'b1;
    write_flag=1'b1;
    INTA = 1'b1;
    chip_select = 1'b1;
    A0=1'b1;
//slave1

    read_flag1 = 1'b1;
    write_flag1=1'b1;
    chip_select1 = 1'b1;
    A01=1'b1;
//slave2
    read_flag2 = 1'b1;
    write_flag2=1'b1;
    chip_select2 = 1'b1;
    A02=1'b1;
//slave3
    read_flag3= 1'b1;
    write_flag3=1'b1;
    chip_select3 = 1'b1;
    A03=1'b1;
//slave4
    read_flag4 = 1'b1;
    write_flag4=1'b1;
    chip_select4 = 1'b1;
    A04=1'b1;
//slave5
    read_flag5 = 1'b1;
    write_flag5=1'b1;
    chip_select5 = 1'b1;
    A05=1'b1;
//slave6
    read_flag6 = 1'b1;
    write_flag6=1'b1;
    chip_select6 = 1'b1;
    A06=1'b1;
/*FOR MASTER*/
//ICW1
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
        data_bus_container = 8'b00001000;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
    //ICW3
    #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1; 
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00111111;
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
/*FOR SLVAE1*/
//ICW1
    #10 chip_select1 = 1'b0;
    #10 write_flag1 = 1'b0;
    #10 write_flag1 = 1'b1;
    #10 write_flag1 = 1'b0;
     A01 =1'b0;
    data_bus_container = 8'b00010001;
    #10 write_flag1 = 1'b1;
        chip_select1 = 1'b1;
        A01 = 1'b1;
    //ICW2
    #10 chip_select1 =1'b0;
        A01 = 1'b1;
    #10 write_flag1 = 1'b0;
    #10 write_flag1 = 1'b1; 
    #10 write_flag1 = 1'b0;
        data_bus_container = 8'b00010000;
    #10 write_flag1 = 1'b1;
        chip_select1 = 1'b1;
        A01 = 1'b1;
    //ICW3
    #10 chip_select1 =1'b0;
        A01 = 1'b1;
    #10 write_flag1 = 1'b0;
    #10 write_flag1 = 1'b1; 
    #10 write_flag1 = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag1 = 1'b1;
        chip_select1 = 1'b1;
        A01 = 1'b1;
     //ICW4
     #10 chip_select1 =1'b0;
        A01 = 1'b1;
    #10 write_flag1 = 1'b0;
    #10 write_flag1 = 1'b1;
    #10 write_flag1 = 1'b0;
        data_bus_container = 8'b00000010;
    #10 write_flag1 = 1'b1;
    //OCW1
       #10 chip_select1 =1'b0;
        A01 = 1'b1;
    #10 write_flag1 = 1'b0;
    #10 write_flag1 = 1'b1;
    #10 write_flag1 = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag1 = 1'b1;
        chip_select1 = 1'b1;
        A01 = 1'b1;

/*FOR SLVAE2*/
//ICW1
    #10 chip_select2 = 1'b0;
    #10 write_flag2 = 1'b0;
    #10 write_flag2 = 1'b1;
    #10 write_flag2 = 1'b0;
     A02 =1'b0;
    data_bus_container = 8'b00010001;
    #10 write_flag2 = 1'b1;
        chip_select2 = 1'b1;
        A02 = 1'b1;
    //ICW2
    #10 chip_select2 =1'b0;
        A02 = 1'b1;
    #10 write_flag2 = 1'b0;
    #10 write_flag2 = 1'b1; 
    #10 write_flag2 = 1'b0;
        data_bus_container = 8'b00011000;
    #10 write_flag2 = 1'b1;
        chip_select2 = 1'b1;
        A02 = 1'b1;
    //ICW3
    #10 chip_select2 =1'b0;
        A02 = 1'b1;
    #10 write_flag2 = 1'b0;
    #10 write_flag2 = 1'b1; 
    #10 write_flag2 = 1'b0;
        data_bus_container = 8'b00000001;
    #10 write_flag2 = 1'b1;
        chip_select2 = 1'b1;
        A02 = 1'b1;
     //ICW4
     #10 chip_select2 =1'b0;
        A02 = 1'b1;
    #10 write_flag2 = 1'b0;
    #10 write_flag2 = 1'b1;
    #10 write_flag2 = 1'b0;
        data_bus_container = 8'b00000010;
    #10 write_flag2 = 1'b1;

//OCW1
 #10 chip_select2 =1'b0;
        A02 = 1'b1;
    #10 write_flag2 = 1'b0;
    #10 write_flag2 = 1'b1;
    #10 write_flag2 = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag2 = 1'b1;
        chip_select2 = 1'b1;
        A02 = 1'b1;

/*FOR SLVAE3*/
//ICW1
    #10 chip_select3 = 1'b0;
    #10 write_flag3 = 1'b0;
    #10 write_flag3 = 1'b1;
    #10 write_flag3 = 1'b0;
     A03 =1'b0;
    data_bus_container = 8'b00010001;
    #10 write_flag3 = 1'b1;
        chip_select3 = 1'b1;
        A03 = 1'b1;
    //ICW2
    #10 chip_select3 =1'b0;
        A03 = 1'b1;
    #10 write_flag3 = 1'b0;
    #10 write_flag3 = 1'b1; 
    #10 write_flag3 = 1'b0;
        data_bus_container = 8'b00100000;
    #10 write_flag3 = 1'b1;
        chip_select3 = 1'b1;
        A03 = 1'b1;
    //ICW3
    #10 chip_select3 =1'b0;
        A03 = 1'b1;
    #10 write_flag3 = 1'b0;
    #10 write_flag3 = 1'b1; 
    #10 write_flag3 = 1'b0;
        data_bus_container = 8'b00000010;
    #10 write_flag3 = 1'b1;
        chip_select3 = 1'b1;
        A03 = 1'b1;
     //ICW4
     #10 chip_select3 =1'b0;
        A03 = 1'b1;
    #10 write_flag3 = 1'b0;
    #10 write_flag3 = 1'b1;
    #10 write_flag3 = 1'b0;
        data_bus_container = 8'b00000010;
    #10 write_flag3 = 1'b1;
//OCW1
 #10 chip_select3 =1'b0;
        A03 = 1'b1;
    #10 write_flag3 = 1'b0;
    #10 write_flag3 = 1'b1;
    #10 write_flag3 = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag3 = 1'b1;
        chip_select3 = 1'b1;
        A03 = 1'b1;

/*FOR SLVAE4*/
//ICW1
    #10 chip_select4 = 1'b0;
    #10 write_flag4 = 1'b0;
    #10 write_flag4 = 1'b1;
    #10 write_flag4 = 1'b0;
     A04 =1'b0;
    data_bus_container = 8'b00010001;
    #10 write_flag4 = 1'b1;
        chip_select4 = 1'b1;
        A04 = 1'b1;
    //ICW2
    #10 chip_select4 =1'b0;
        A04 = 1'b1;
    #10 write_flag4 = 1'b0;
    #10 write_flag4 = 1'b1; 
    #10 write_flag4 = 1'b0;
        data_bus_container = 8'b00101000;
    #10 write_flag4 = 1'b1;
        chip_select4 = 1'b1;
        A04 = 1'b1;
    //ICW3
    #10 chip_select4 =1'b0;
        A04 = 1'b1;
    #10 write_flag4 = 1'b0;
    #10 write_flag4 = 1'b1; 
    #10 write_flag4 = 1'b0;
        data_bus_container = 8'b00000011;
    #10 write_flag4 = 1'b1;
        chip_select4 = 1'b1;
        A04 = 1'b1;

     //ICW4
     #10 chip_select4 =1'b0;
        A04 = 1'b1;
    #10 write_flag4 = 1'b0;
    #10 write_flag4 = 1'b1;
    #10 write_flag4 = 1'b0;
        data_bus_container = 8'b00000010;
    #10 write_flag4 = 1'b1;
        //OCW1
 #10 chip_select4 =1'b0;
        A04 = 1'b1;
    #10 write_flag4 = 1'b0;
    #10 write_flag4 = 1'b1;
    #10 write_flag4 = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag4 = 1'b1;
        chip_select4 = 1'b1;
        A04 = 1'b1;
/*FOR SLVAE5*/
//ICW1
    #10 chip_select5 = 1'b0;
    #10 write_flag5 = 1'b0;
    #10 write_flag5 = 1'b1;
    #10 write_flag5 = 1'b0;
     A05 =1'b0;
    data_bus_container = 8'b00011001;
    #10 write_flag5 = 1'b1;
        chip_select5 = 1'b1;
        A05 = 1'b1;
    //ICW2
    #10 chip_select5 =1'b0;
        A05 = 1'b1;
    #10 write_flag5 = 1'b0;
    #10 write_flag5 = 1'b1; 
    #10 write_flag5 = 1'b0;
        data_bus_container = 8'b00110000;
    #10 write_flag5 = 1'b1;
        chip_select5 = 1'b1;
        A05 = 1'b1;
    //ICW3
    #10 chip_select5 =1'b0;
        A05 = 1'b1;
    #10 write_flag5 = 1'b0;
    #10 write_flag5 = 1'b1; 
    #10 write_flag5 = 1'b0;
        data_bus_container = 8'b00000100;
    #10 write_flag5 = 1'b1;
        chip_select5 = 1'b1;
        A05 = 1'b1;
     //ICW4
     #10 chip_select5 =1'b0;
        A0 = 1'b1;
    #10 write_flag5 = 1'b0;
    #10 write_flag5 = 1'b1;
    #10 write_flag5 = 1'b0;
        data_bus_container = 8'b00000010;
    #10 write_flag5 = 1'b1;
    //OCW1
     #10 chip_select5 =1'b0;
        A05 = 1'b1;
    #10 write_flag5 = 1'b0;
    #10 write_flag5 = 1'b1;
    #10 write_flag5 = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag5 = 1'b1;
        chip_select5 = 1'b1;
        A05 = 1'b1;
/*FOR SLVAE6*/
//ICW1
    #10 chip_select6 = 1'b0;
    #10 write_flag6 = 1'b0;
    #10 write_flag6 = 1'b1;
    #10 write_flag6 = 1'b0;
     A06 =1'b0;
    data_bus_container = 8'b0011000;
    #10 write_flag6 = 1'b1;
        chip_select6 = 1'b1;
        A06 = 1'b1;
    //ICW2
    #10 chip_select6 =1'b0;
        A06 = 1'b1;
    #10 write_flag6 = 1'b0;
    #10 write_flag6 = 1'b1; 
    #10 write_flag6 = 1'b0;
        data_bus_container = 8'b00111000;
    #10 write_flag6 = 1'b1;
        chip_select6 = 1'b1;
        A06 = 1'b1;
    //ICW3
    #10 chip_select6 =1'b0;
        A06 = 1'b1;
    #10 write_flag6 = 1'b0;
    #10 write_flag6 = 1'b1; 
    #10 write_flag6 = 1'b0;
        data_bus_container = 8'b00000101;
    #10 write_flag6 = 1'b1;
        chip_select6 = 1'b1;
        A06 = 1'b1;

     //ICW4
     #10 chip_select6 =1'b0;
        A06 = 1'b1;
    #10 write_flag6 = 1'b0;
    #10 write_flag6 = 1'b1;
    #10 write_flag6 = 1'b0;
        data_bus_container = 8'b00000010;
    #10 write_flag6 = 1'b1;
    //OCW1
     #10 chip_select6 =1'b0;
        A06 = 1'b1;
    #10 write_flag6 = 1'b0;
    #10 write_flag6 = 1'b1;
    #10 write_flag6 = 1'b0;
        data_bus_container = 8'b00000000;
    #10 write_flag6 = 1'b1;
        chip_select6 = 1'b1;
        A06 = 1'b0;
    //OCW3 for master
     #10 chip_select =1'b0;
        A0 = 1'b0;
    #10 write_flag = 1'b0;
    #10 write_flag = 1'b1;
    #10 write_flag = 1'b0;
        data_bus_container = 8'b00001011;
    #10 write_flag = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b0;
      //OCW3 for slave1
     #10 chip_select1 =1'b0;
        A01 = 1'b0;
    #10 write_flag1 = 1'b0;
    #10 write_flag1 = 1'b1;
    #10 write_flag1 = 1'b0;
        data_bus_container = 8'b00001011;
    #10 write_flag1 = 1'b1;
        chip_select1 = 1'b1;
        A01 = 1'b0;
        //sending interrupts
    #10 interrupt_requests1=8'b00010000;
    #10 INTA = 1'b0;
   
    #10 read_flag1 =1'b0;
    #10 read_flag1 = 1'b1;
   
    #10 INTA = 1'b1;
    #10 INTA = 1'b0;
    #10 INTA = 1'b1;
    #10 read_flag1 =1'b0;
    #10 read_flag1 = 1'b1;
  




end




endmodule