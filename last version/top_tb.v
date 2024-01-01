module top_tb;
reg [7:0]interrupt_requests;
reg [7:0]interrupt_requests1;
reg [7:0]interrupt_requests2;
reg [7:0]interrupt_requests3;
reg [7:0]interrupt_requests4;
reg [7:0]interrupt_requests5;
reg [7:0]interrupt_requests6;
reg INTA;
wire [2:0]CAS;
wire [7:0]D;
reg [7:0] D_container;
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
reg RD;
reg WR;
reg RD1;
reg WR1;
reg RD2;
reg WR2;
reg RD3;
reg WR3;
reg RD4;
reg WR4;
reg RD5;
reg WR5;
reg RD6;
reg WR6;
wire INT_Flag;
wire INT_Flag1;
wire INT_Flag2;
wire INT_Flag3;
wire INT_Flag4;
wire INT_Flag5;
wire INT_Flag6;
reg device1;
reg device2;
reg SP;
reg SP1;
reg SP2;
reg SP3;
reg SP4;
reg SP5;
reg SP6;
reg [1:0]cnt=2'b00;

always@(*)
begin
    interrupt_requests <= {device2,device1, INT_Flag6,INT_Flag5,INT_Flag4,INT_Flag3,INT_Flag2,INT_Flag1};
end


assign D = (cnt==2'b10)? D_container:8'bzzzzzzzz;
always@(negedge WR1 or posedge WR1 )
begin
if(WR1==1'b0)
cnt = cnt +1;
if(WR1==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge WR2 or posedge WR2 )
begin
if(WR2==1'b0)
cnt = cnt +1;
if(WR2==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge WR3 or posedge WR3 )
begin
if(WR3==1'b0)
cnt = cnt +1;
if(WR3==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge WR4 or posedge WR4 )
begin
if(WR4==1'b0)
cnt = cnt +1;
if(WR4==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge WR5 or posedge WR5 )
begin
if(WR5==1'b0)
cnt = cnt +1;
if(WR5==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge WR6 or posedge WR6 )
begin
if(WR6==1'b0)
cnt = cnt +1;
if(WR6==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge WR or posedge WR)
begin
if(WR==1'b0)
cnt = cnt +1;
if(WR==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end


top master (.D(D),.CAS(CAS),.WR(WR),.RD(RD),.SP(SP),.INTA(INTA),.INT_Flag(INT_Flag),.interrupt_requests(interrupt_requests),.chip_select(chip_select),.A0(A0));
top slave1 (.D(D),.CAS(CAS),.WR(WR1),.RD(RD1),.SP(SP1),.INTA(INTA),.INT_Flag(INT_Flag1),.interrupt_requests(interrupt_requests1),.chip_select(chip_select1),.A0(A01));
top slave2 (.D(D),.CAS(CAS),.WR(WR2),.RD(RD2),.SP(SP2),.INTA(INTA),.INT_Flag(INT_Flag2),.interrupt_requests(interrupt_requests2),.chip_select(chip_select2),.A0(A02));
top slave3 (.D(D),.CAS(CAS),.WR(WR3),.RD(RD3),.SP(SP3),.INTA(INTA),.INT_Flag(INT_Flag3),.interrupt_requests(interrupt_requests3),.chip_select(chip_select3),.A0(A03));
top slave4 (.D(D),.CAS(CAS),.WR(WR4),.RD(RD4),.SP(SP4),.INTA(INTA),.INT_Flag(INT_Flag4),.interrupt_requests(interrupt_requests4),.chip_select(chip_select4),.A0(A04));
top slave5 (.D(D),.CAS(CAS),.WR(WR5),.RD(RD5),.SP(SP5),.INTA(INTA),.INT_Flag(INT_Flag5),.interrupt_requests(interrupt_requests5),.chip_select(chip_select5),.A0(A05));
top slave6 (.D(D),.CAS(CAS),.WR(WR6),.RD(RD6),.SP(SP6),.INTA(INTA),.INT_Flag(INT_Flag6),.interrupt_requests(interrupt_requests6),.chip_select(chip_select6),.A0(A06));

initial begin
    SP=1'b1;
    SP1=1'b0;
    SP2=1'b0;
    SP3=1'b0;
    SP4=1'b0;
    SP5=1'b0;
    SP6=1'b0;
   // D_container=8'bzzzzzzzz;
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
    RD = 1'b1;
    WR=1'b1;
    INTA = 1'b1;
    chip_select = 1'b1;
    A0=1'b1;
//slave1

    RD1 = 1'b1;
    WR1=1'b1;
    chip_select1 = 1'b1;
    A01=1'b1;
//slave2
    RD2 = 1'b1;
    WR2=1'b1;
    chip_select2 = 1'b1;
    A02=1'b1;
//slave3
    RD3= 1'b1;
    WR3=1'b1;
    chip_select3 = 1'b1;
    A03=1'b1;
//slave4
    RD4 = 1'b1;
    WR4=1'b1;
    chip_select4 = 1'b1;
    A04=1'b1;
//slave5
    RD5 = 1'b1;
    WR5=1'b1;
    chip_select5 = 1'b1;
    A05=1'b1;
//slave6
    RD6 = 1'b1;
    WR6=1'b1;
    chip_select6 = 1'b1;
    A06=1'b1;
/*FOR MASTER*/
//ICW1
    #10 chip_select = 1'b0;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
     A0 =1'b0;
    D_container = 8'b00010001;
    #10 WR = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
    //ICW2
    #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 WR = 1'b0;
    #10 WR = 1'b1; 
    #10 WR = 1'b0;
        D_container = 8'b00001000;
    #10 WR = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
    //ICW3
    #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 WR = 1'b0;
    #10 WR = 1'b1; 
    #10 WR = 1'b0;
        D_container = 8'b00111111;
    #10 WR = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
     //ICW4
     #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
        D_container = 8'b00000000;
    #10 WR = 1'b1;
//OCW1
       #10 chip_select =1'b0;
        A0 = 1'b1;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
        D_container = 8'b00000000;
    #10 WR = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b1;
/*FOR SLVAE1*/
//ICW1
    #10 chip_select1 = 1'b0;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1;
    #10 WR1 = 1'b0;
     A01 =1'b0;
    D_container = 8'b00010001;
    #10 WR1 = 1'b1;
        chip_select1 = 1'b1;
        A01 = 1'b1;
    //ICW2
    #10 chip_select1 =1'b0;
        A01 = 1'b1;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1; 
    #10 WR1 = 1'b0;
        D_container = 8'b00010000;
    #10 WR1 = 1'b1;
        chip_select1 = 1'b1;
        A01 = 1'b1;
    //ICW3
    #10 chip_select1 =1'b0;
        A01 = 1'b1;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1; 
    #10 WR1 = 1'b0;
        D_container = 8'b00000000;
    #10 WR1 = 1'b1;
        chip_select1 = 1'b1;
        A01 = 1'b1;
     //ICW4
     #10 chip_select1 =1'b0;
        A01 = 1'b1;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1;
    #10 WR1 = 1'b0;
        D_container = 8'b00000000;
    #10 WR1 = 1'b1;
    //OCW1
       #10 chip_select1 =1'b0;
        A01 = 1'b1;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1;
    #10 WR1 = 1'b0;
        D_container = 8'b00000000;
    #10 WR1 = 1'b1;
        chip_select1 = 1'b1;
        A01 = 1'b1;

/*FOR SLVAE2*/
//ICW1
    #10 chip_select2 = 1'b0;
    #10 WR2 = 1'b0;
    #10 WR2 = 1'b1;
    #10 WR2 = 1'b0;
     A02 =1'b0;
    D_container = 8'b00010001;
    #10 WR2 = 1'b1;
        chip_select2 = 1'b1;
        A02 = 1'b1;
    //ICW2
    #10 chip_select2 =1'b0;
        A02 = 1'b1;
    #10 WR2 = 1'b0;
    #10 WR2 = 1'b1; 
    #10 WR2 = 1'b0;
        D_container = 8'b00011000;
    #10 WR2 = 1'b1;
        chip_select2 = 1'b1;
        A02 = 1'b1;
    //ICW3
    #10 chip_select2 =1'b0;
        A02 = 1'b1;
    #10 WR2 = 1'b0;
    #10 WR2 = 1'b1; 
    #10 WR2 = 1'b0;
        D_container = 8'b00000001;
    #10 WR2 = 1'b1;
        chip_select2 = 1'b1;
        A02 = 1'b1;
     //ICW4
     #10 chip_select2 =1'b0;
        A02 = 1'b1;
    #10 WR2 = 1'b0;
    #10 WR2 = 1'b1;
    #10 WR2 = 1'b0;
        D_container = 8'b00000010;
    #10 WR2 = 1'b1;

//OCW1
 #10 chip_select2 =1'b0;
        A02 = 1'b1;
    #10 WR2 = 1'b0;
    #10 WR2 = 1'b1;
    #10 WR2 = 1'b0;
        D_container = 8'b00000000;
    #10 WR2 = 1'b1;
        chip_select2 = 1'b1;
        A02 = 1'b1;

/*FOR SLVAE3*/
//ICW1
    #10 chip_select3 = 1'b0;
    #10 WR3 = 1'b0;
    #10 WR3 = 1'b1;
    #10 WR3 = 1'b0;
     A03 =1'b0;
    D_container = 8'b00010001;
    #10 WR3 = 1'b1;
        chip_select3 = 1'b1;
        A03 = 1'b1;
    //ICW2
    #10 chip_select3 =1'b0;
        A03 = 1'b1;
    #10 WR3 = 1'b0;
    #10 WR3 = 1'b1; 
    #10 WR3 = 1'b0;
        D_container = 8'b00100000;
    #10 WR3 = 1'b1;
        chip_select3 = 1'b1;
        A03 = 1'b1;
    //ICW3
    #10 chip_select3 =1'b0;
        A03 = 1'b1;
    #10 WR3 = 1'b0;
    #10 WR3 = 1'b1; 
    #10 WR3 = 1'b0;
        D_container = 8'b00000010;
    #10 WR3 = 1'b1;
        chip_select3 = 1'b1;
        A03 = 1'b1;
     //ICW4
     #10 chip_select3 =1'b0;
        A03 = 1'b1;
    #10 WR3 = 1'b0;
    #10 WR3 = 1'b1;
    #10 WR3 = 1'b0;
        D_container = 8'b00000010;
    #10 WR3 = 1'b1;
//OCW1
 #10 chip_select3 =1'b0;
        A03 = 1'b1;
    #10 WR3 = 1'b0;
    #10 WR3 = 1'b1;
    #10 WR3 = 1'b0;
        D_container = 8'b00000000;
    #10 WR3 = 1'b1;
        chip_select3 = 1'b1;
        A03 = 1'b1;

/*FOR SLVAE4*/
//ICW1
    #10 chip_select4 = 1'b0;
    #10 WR4 = 1'b0;
    #10 WR4 = 1'b1;
    #10 WR4 = 1'b0;
     A04 =1'b0;
    D_container = 8'b00010001;
    #10 WR4 = 1'b1;
        chip_select4 = 1'b1;
        A04 = 1'b1;
    //ICW2
    #10 chip_select4 =1'b0;
        A04 = 1'b1;
    #10 WR4 = 1'b0;
    #10 WR4 = 1'b1; 
    #10 WR4 = 1'b0;
        D_container = 8'b00101000;
    #10 WR4 = 1'b1;
        chip_select4 = 1'b1;
        A04 = 1'b1;
    //ICW3
    #10 chip_select4 =1'b0;
        A04 = 1'b1;
    #10 WR4 = 1'b0;
    #10 WR4 = 1'b1; 
    #10 WR4 = 1'b0;
        D_container = 8'b00000011;
    #10 WR4 = 1'b1;
        chip_select4 = 1'b1;
        A04 = 1'b1;

     //ICW4
     #10 chip_select4 =1'b0;
        A04 = 1'b1;
    #10 WR4 = 1'b0;
    #10 WR4 = 1'b1;
    #10 WR4 = 1'b0;
        D_container = 8'b00000010;
    #10 WR4 = 1'b1;
        //OCW1
 #10 chip_select4 =1'b0;
        A04 = 1'b1;
    #10 WR4 = 1'b0;
    #10 WR4 = 1'b1;
    #10 WR4 = 1'b0;
        D_container = 8'b00000000;
    #10 WR4 = 1'b1;
        chip_select4 = 1'b1;
        A04 = 1'b1;
/*FOR SLVAE5*/
//ICW1
    #10 chip_select5 = 1'b0;
    #10 WR5 = 1'b0;
    #10 WR5 = 1'b1;
    #10 WR5 = 1'b0;
     A05 =1'b0;
    D_container = 8'b00011001;
    #10 WR5 = 1'b1;
        chip_select5 = 1'b1;
        A05 = 1'b1;
    //ICW2
    #10 chip_select5 =1'b0;
        A05 = 1'b1;
    #10 WR5 = 1'b0;
    #10 WR5 = 1'b1; 
    #10 WR5 = 1'b0;
        D_container = 8'b00110000;
    #10 WR5 = 1'b1;
        chip_select5 = 1'b1;
        A05 = 1'b1;
    //ICW3
    #10 chip_select5 =1'b0;
        A05 = 1'b1;
    #10 WR5 = 1'b0;
    #10 WR5 = 1'b1; 
    #10 WR5 = 1'b0;
        D_container = 8'b00000100;
    #10 WR5 = 1'b1;
        chip_select5 = 1'b1;
        A05 = 1'b1;
     //ICW4
     #10 chip_select5 =1'b0;
        A0 = 1'b1;
    #10 WR5 = 1'b0;
    #10 WR5 = 1'b1;
    #10 WR5 = 1'b0;
        D_container = 8'b00000010;
    #10 WR5 = 1'b1;
    //OCW1
     #10 chip_select5 =1'b0;
        A05 = 1'b1;
    #10 WR5 = 1'b0;
    #10 WR5 = 1'b1;
    #10 WR5 = 1'b0;
        D_container = 8'b00000000;
    #10 WR5 = 1'b1;
        chip_select5 = 1'b1;
        A05 = 1'b1;
/*FOR SLVAE6*/
//ICW1
    #10 chip_select6 = 1'b0;
    #10 WR6 = 1'b0;
    #10 WR6 = 1'b1;
    #10 WR6 = 1'b0;
     A06 =1'b0;
    D_container = 8'b0011000;
    #10 WR6 = 1'b1;
        chip_select6 = 1'b1;
        A06 = 1'b1;
    //ICW2
    #10 chip_select6 =1'b0;
        A06 = 1'b1;
    #10 WR6 = 1'b0;
    #10 WR6 = 1'b1; 
    #10 WR6 = 1'b0;
        D_container = 8'b00111000;
    #10 WR6 = 1'b1;
        chip_select6 = 1'b1;
        A06 = 1'b1;
    //ICW3
    #10 chip_select6 =1'b0;
        A06 = 1'b1;
    #10 WR6 = 1'b0;
    #10 WR6 = 1'b1; 
    #10 WR6 = 1'b0;
        D_container = 8'b00000101;
    #10 WR6 = 1'b1;
        chip_select6 = 1'b1;
        A06 = 1'b1;

     //ICW4
     #10 chip_select6 =1'b0;
        A06 = 1'b1;
    #10 WR6 = 1'b0;
    #10 WR6 = 1'b1;
    #10 WR6 = 1'b0;
        D_container = 8'b00000010;
    #10 WR6 = 1'b1;
    //OCW1
     #10 chip_select6 =1'b0;
        A06 = 1'b1;
    #10 WR6 = 1'b0;
    #10 WR6 = 1'b1;
    #10 WR6 = 1'b0;
        D_container = 8'b00000000;
    #10 WR6 = 1'b1;
        chip_select6 = 1'b1;
        A06 = 1'b0;
    //OCW3 for master
     #10 chip_select =1'b0;
        A0 = 1'b0;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
        D_container = 8'b00001010;
    #10 WR = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b0;
      //OCW3 for slave1
     #10 chip_select1 =1'b0;
        A01 = 1'b0;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1;
    #10 WR1 = 1'b0;
        D_container = 8'b00001011;
    #10 WR1 = 1'b1;
        chip_select1 = 1'b1;
        A01 = 1'b0;
        //sending interrupts
    #10 interrupt_requests1=8'b00010000;
    #10 INTA = 1'b0;
    #10 INTA = 1'b1;
 
    #10 INTA = 1'b0;
    #10 INTA = 1'b1;
   

    //ocw2
    #10 chip_select =1'b0;
        A0 = 1'b0;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
        D_container = 8'b00100000;
    #10 WR = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b0;
    
    //ocw2
    #10 chip_select =1'b0;
        A0 = 1'b0;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
        D_container = 8'b00100000;
    #10 WR = 1'b1;
        chip_select = 1'b1;
        A0 = 1'b0;
          
    
      #10 RD =1'b0;
    #10 RD = 1'b1;

  




end




endmodule

