module top_tb;
reg [7:0]IRRs;
reg [7:0]IRRs1;
reg [7:0]IRRs2;
reg [7:0]IRRs3;
reg [7:0]IRRs4;
reg [7:0]IRRs5;
reg [7:0]IRRs6;
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
reg CS;
reg CS1;
reg CS2;
reg CS3;
reg CS4;
reg CS5;
reg CS6;
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
wire INT;
wire INT1;
wire INT2;
wire INT3;
wire INT4;
wire INT5;
wire INT6;
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
    IRRs <= {device2,device1, INT6,INT5,INT4,INT3,INT2,INT1};
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


top master (.D(D),.CAS(CAS),.WR(WR),.RD(RD),.SP(SP),.INTA(INTA),.INT(INT),.IRRs(IRRs),.CS(CS),.A0(A0));
top slave1 (.D(D),.CAS(CAS),.WR(WR1),.RD(RD1),.SP(SP1),.INTA(INTA),.INT(INT1),.IRRs(IRRs1),.CS(CS1),.A0(A01));
top slave2 (.D(D),.CAS(CAS),.WR(WR2),.RD(RD2),.SP(SP2),.INTA(INTA),.INT(INT2),.IRRs(IRRs2),.CS(CS2),.A0(A02));
top slave3 (.D(D),.CAS(CAS),.WR(WR3),.RD(RD3),.SP(SP3),.INTA(INTA),.INT(INT3),.IRRs(IRRs3),.CS(CS3),.A0(A03));
top slave4 (.D(D),.CAS(CAS),.WR(WR4),.RD(RD4),.SP(SP4),.INTA(INTA),.INT(INT4),.IRRs(IRRs4),.CS(CS4),.A0(A04));
top slave5 (.D(D),.CAS(CAS),.WR(WR5),.RD(RD5),.SP(SP5),.INTA(INTA),.INT(INT5),.IRRs(IRRs5),.CS(CS5),.A0(A05));
top slave6 (.D(D),.CAS(CAS),.WR(WR6),.RD(RD6),.SP(SP6),.INTA(INTA),.INT(INT6),.IRRs(IRRs6),.CS(CS6),.A0(A06));

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
    IRRs=8'b00000000;
    IRRs1 =8'b00000000;
    IRRs2 =8'b00000000;
    IRRs3 =8'b00000000;
    IRRs4 =8'b00000000;
    IRRs5 =8'b00000000;
    IRRs6 =8'b00000000;
//master
    RD = 1'b1;
    WR=1'b1;
    INTA = 1'b1;
    CS = 1'b1;
    A0=1'b1;
//slave1

    RD1 = 1'b1;
    WR1=1'b1;
    CS1 = 1'b1;
    A01=1'b1;
//slave2
    RD2 = 1'b1;
    WR2=1'b1;
    CS2 = 1'b1;
    A02=1'b1;
//slave3
    RD3= 1'b1;
    WR3=1'b1;
    CS3 = 1'b1;
    A03=1'b1;
//slave4
    RD4 = 1'b1;
    WR4=1'b1;
    CS4 = 1'b1;
    A04=1'b1;
//slave5
    RD5 = 1'b1;
    WR5=1'b1;
    CS5 = 1'b1;
    A05=1'b1;
//slave6
    RD6 = 1'b1;
    WR6=1'b1;
    CS6 = 1'b1;
    A06=1'b1;
/*FOR MASTER*/
//ICW1
    #10 CS = 1'b0;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
     A0 =1'b0;
    D_container = 8'b00010001;
    #10 WR = 1'b1;
        CS = 1'b1;
        A0 = 1'b1;
    //ICW2
    #10 CS =1'b0;
        A0 = 1'b1;
    #10 WR = 1'b0;
    #10 WR = 1'b1; 
    #10 WR = 1'b0;
        D_container = 8'b00001000;
    #10 WR = 1'b1;
        CS = 1'b1;
        A0 = 1'b1;
    //ICW3
    #10 CS =1'b0;
        A0 = 1'b1;
    #10 WR = 1'b0;
    #10 WR = 1'b1; 
    #10 WR = 1'b0;
        D_container = 8'b00111111;
    #10 WR = 1'b1;
        CS = 1'b1;
        A0 = 1'b1;
     //ICW4
     #10 CS =1'b0;
        A0 = 1'b1;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
        D_container = 8'b00000000;
    #10 WR = 1'b1;
//OCW1
       #10 CS =1'b0;
        A0 = 1'b1;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
        D_container = 8'b00000000;
    #10 WR = 1'b1;
        CS = 1'b1;
        A0 = 1'b1;
/*FOR SLVAE1*/
//ICW1
    #10 CS1 = 1'b0;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1;
    #10 WR1 = 1'b0;
     A01 =1'b0;
    D_container = 8'b00010001;
    #10 WR1 = 1'b1;
        CS1 = 1'b1;
        A01 = 1'b1;
    //ICW2
    #10 CS1 =1'b0;
        A01 = 1'b1;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1; 
    #10 WR1 = 1'b0;
        D_container = 8'b00010000;
    #10 WR1 = 1'b1;
        CS1 = 1'b1;
        A01 = 1'b1;
    //ICW3
    #10 CS1 =1'b0;
        A01 = 1'b1;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1; 
    #10 WR1 = 1'b0;
        D_container = 8'b00000000;
    #10 WR1 = 1'b1;
        CS1 = 1'b1;
        A01 = 1'b1;
     //ICW4
     #10 CS1 =1'b0;
        A01 = 1'b1;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1;
    #10 WR1 = 1'b0;
        D_container = 8'b00000000;
    #10 WR1 = 1'b1;
    //OCW1
       #10 CS1 =1'b0;
        A01 = 1'b1;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1;
    #10 WR1 = 1'b0;
        D_container = 8'b00000000;
    #10 WR1 = 1'b1;
        CS1 = 1'b1;
        A01 = 1'b1;

/*FOR SLVAE2*/
//ICW1
    #10 CS2 = 1'b0;
    #10 WR2 = 1'b0;
    #10 WR2 = 1'b1;
    #10 WR2 = 1'b0;
     A02 =1'b0;
    D_container = 8'b00010001;
    #10 WR2 = 1'b1;
        CS2 = 1'b1;
        A02 = 1'b1;
    //ICW2
    #10 CS2 =1'b0;
        A02 = 1'b1;
    #10 WR2 = 1'b0;
    #10 WR2 = 1'b1; 
    #10 WR2 = 1'b0;
        D_container = 8'b00011000;
    #10 WR2 = 1'b1;
        CS2 = 1'b1;
        A02 = 1'b1;
    //ICW3
    #10 CS2 =1'b0;
        A02 = 1'b1;
    #10 WR2 = 1'b0;
    #10 WR2 = 1'b1; 
    #10 WR2 = 1'b0;
        D_container = 8'b00000001;
    #10 WR2 = 1'b1;
        CS2 = 1'b1;
        A02 = 1'b1;
     //ICW4
     #10 CS2 =1'b0;
        A02 = 1'b1;
    #10 WR2 = 1'b0;
    #10 WR2 = 1'b1;
    #10 WR2 = 1'b0;
        D_container = 8'b00000010;
    #10 WR2 = 1'b1;

//OCW1
 #10 CS2 =1'b0;
        A02 = 1'b1;
    #10 WR2 = 1'b0;
    #10 WR2 = 1'b1;
    #10 WR2 = 1'b0;
        D_container = 8'b00000000;
    #10 WR2 = 1'b1;
        CS2 = 1'b1;
        A02 = 1'b1;

/*FOR SLVAE3*/
//ICW1
    #10 CS3 = 1'b0;
    #10 WR3 = 1'b0;
    #10 WR3 = 1'b1;
    #10 WR3 = 1'b0;
     A03 =1'b0;
    D_container = 8'b00010001;
    #10 WR3 = 1'b1;
        CS3 = 1'b1;
        A03 = 1'b1;
    //ICW2
    #10 CS3 =1'b0;
        A03 = 1'b1;
    #10 WR3 = 1'b0;
    #10 WR3 = 1'b1; 
    #10 WR3 = 1'b0;
        D_container = 8'b00100000;
    #10 WR3 = 1'b1;
        CS3 = 1'b1;
        A03 = 1'b1;
    //ICW3
    #10 CS3 =1'b0;
        A03 = 1'b1;
    #10 WR3 = 1'b0;
    #10 WR3 = 1'b1; 
    #10 WR3 = 1'b0;
        D_container = 8'b00000010;
    #10 WR3 = 1'b1;
        CS3 = 1'b1;
        A03 = 1'b1;
     //ICW4
     #10 CS3 =1'b0;
        A03 = 1'b1;
    #10 WR3 = 1'b0;
    #10 WR3 = 1'b1;
    #10 WR3 = 1'b0;
        D_container = 8'b00000010;
    #10 WR3 = 1'b1;
//OCW1
 #10 CS3 =1'b0;
        A03 = 1'b1;
    #10 WR3 = 1'b0;
    #10 WR3 = 1'b1;
    #10 WR3 = 1'b0;
        D_container = 8'b00000000;
    #10 WR3 = 1'b1;
        CS3 = 1'b1;
        A03 = 1'b1;

/*FOR SLVAE4*/
//ICW1
    #10 CS4 = 1'b0;
    #10 WR4 = 1'b0;
    #10 WR4 = 1'b1;
    #10 WR4 = 1'b0;
     A04 =1'b0;
    D_container = 8'b00010001;
    #10 WR4 = 1'b1;
        CS4 = 1'b1;
        A04 = 1'b1;
    //ICW2
    #10 CS4 =1'b0;
        A04 = 1'b1;
    #10 WR4 = 1'b0;
    #10 WR4 = 1'b1; 
    #10 WR4 = 1'b0;
        D_container = 8'b00101000;
    #10 WR4 = 1'b1;
        CS4 = 1'b1;
        A04 = 1'b1;
    //ICW3
    #10 CS4 =1'b0;
        A04 = 1'b1;
    #10 WR4 = 1'b0;
    #10 WR4 = 1'b1; 
    #10 WR4 = 1'b0;
        D_container = 8'b00000011;
    #10 WR4 = 1'b1;
        CS4 = 1'b1;
        A04 = 1'b1;

     //ICW4
     #10 CS4 =1'b0;
        A04 = 1'b1;
    #10 WR4 = 1'b0;
    #10 WR4 = 1'b1;
    #10 WR4 = 1'b0;
        D_container = 8'b00000010;
    #10 WR4 = 1'b1;
        //OCW1
 #10 CS4 =1'b0;
        A04 = 1'b1;
    #10 WR4 = 1'b0;
    #10 WR4 = 1'b1;
    #10 WR4 = 1'b0;
        D_container = 8'b00000000;
    #10 WR4 = 1'b1;
        CS4 = 1'b1;
        A04 = 1'b1;
/*FOR SLVAE5*/
//ICW1
    #10 CS5 = 1'b0;
    #10 WR5 = 1'b0;
    #10 WR5 = 1'b1;
    #10 WR5 = 1'b0;
     A05 =1'b0;
    D_container = 8'b00011001;
    #10 WR5 = 1'b1;
        CS5 = 1'b1;
        A05 = 1'b1;
    //ICW2
    #10 CS5 =1'b0;
        A05 = 1'b1;
    #10 WR5 = 1'b0;
    #10 WR5 = 1'b1; 
    #10 WR5 = 1'b0;
        D_container = 8'b00110000;
    #10 WR5 = 1'b1;
        CS5 = 1'b1;
        A05 = 1'b1;
    //ICW3
    #10 CS5 =1'b0;
        A05 = 1'b1;
    #10 WR5 = 1'b0;
    #10 WR5 = 1'b1; 
    #10 WR5 = 1'b0;
        D_container = 8'b00000100;
    #10 WR5 = 1'b1;
        CS5 = 1'b1;
        A05 = 1'b1;
     //ICW4
     #10 CS5 =1'b0;
        A0 = 1'b1;
    #10 WR5 = 1'b0;
    #10 WR5 = 1'b1;
    #10 WR5 = 1'b0;
        D_container = 8'b00000010;
    #10 WR5 = 1'b1;
    //OCW1
     #10 CS5 =1'b0;
        A05 = 1'b1;
    #10 WR5 = 1'b0;
    #10 WR5 = 1'b1;
    #10 WR5 = 1'b0;
        D_container = 8'b00000000;
    #10 WR5 = 1'b1;
        CS5 = 1'b1;
        A05 = 1'b1;
/*FOR SLVAE6*/
//ICW1
    #10 CS6 = 1'b0;
    #10 WR6 = 1'b0;
    #10 WR6 = 1'b1;
    #10 WR6 = 1'b0;
     A06 =1'b0;
    D_container = 8'b0011000;
    #10 WR6 = 1'b1;
        CS6 = 1'b1;
        A06 = 1'b1;
    //ICW2
    #10 CS6 =1'b0;
        A06 = 1'b1;
    #10 WR6 = 1'b0;
    #10 WR6 = 1'b1; 
    #10 WR6 = 1'b0;
        D_container = 8'b00111000;
    #10 WR6 = 1'b1;
        CS6 = 1'b1;
        A06 = 1'b1;
    //ICW3
    #10 CS6 =1'b0;
        A06 = 1'b1;
    #10 WR6 = 1'b0;
    #10 WR6 = 1'b1; 
    #10 WR6 = 1'b0;
        D_container = 8'b00000101;
    #10 WR6 = 1'b1;
        CS6 = 1'b1;
        A06 = 1'b1;

     //ICW4
     #10 CS6 =1'b0;
        A06 = 1'b1;
    #10 WR6 = 1'b0;
    #10 WR6 = 1'b1;
    #10 WR6 = 1'b0;
        D_container = 8'b00000010;
    #10 WR6 = 1'b1;
    //OCW1
     #10 CS6 =1'b0;
        A06 = 1'b1;
    #10 WR6 = 1'b0;
    #10 WR6 = 1'b1;
    #10 WR6 = 1'b0;
        D_container = 8'b00000000;
    #10 WR6 = 1'b1;
        CS6 = 1'b1;
        A06 = 1'b0;
    //OCW3 for master
     #10 CS =1'b0;
        A0 = 1'b0;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
        D_container = 8'b00001010;
    #10 WR = 1'b1;
        CS = 1'b1;
        A0 = 1'b0;
      //OCW3 for slave1
     #10 CS1 =1'b0;
        A01 = 1'b0;
    #10 WR1 = 1'b0;
    #10 WR1 = 1'b1;
    #10 WR1 = 1'b0;
        D_container = 8'b00001011;
    #10 WR1 = 1'b1;
        CS1 = 1'b1;
        A01 = 1'b0;
        //sending interrupts
    #10 IRRs1=8'b00010000;
    #10 INTA = 1'b0;
    #10 INTA = 1'b1;
 
    #10 INTA = 1'b0;
    #10 INTA = 1'b1;
   

    //ocw2
    #10 CS =1'b0;
        A0 = 1'b0;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
        D_container = 8'b00100000;
    #10 WR = 1'b1;
        CS = 1'b1;
        A0 = 1'b0;
    
    //ocw2
    #10 CS =1'b0;
        A0 = 1'b0;
    #10 WR = 1'b0;
    #10 WR = 1'b1;
    #10 WR = 1'b0;
        D_container = 8'b00100000;
    #10 WR = 1'b1;
        CS = 1'b1;
        A0 = 1'b0;
          
    
      #10 RD =1'b0;
    #10 RD = 1'b1;

  




end




endmodule

