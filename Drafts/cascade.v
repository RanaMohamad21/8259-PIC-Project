module cascade
  (
    input SP,
    input SNGL,
    input [2:0] slaveReg,
    input pulse1,
    input pulse2,
    input [2:0] intrID,
    inout [2:0] casc,
    output reg vecFlag
  );
  reg [2:0] cascReg;
  reg [3:0] count;
  reg flag;
  assign casc=(SP)?cascReg:3'bzzz;
  always @(posedge pulse1)
  begin
    if(!SNGL)
      if(SP)
        begin
         cascReg= intrID;vecFlag=1'b0;
        end
      else begin
        cascReg=3'b000;vecFlag=1'b0; end   
    else begin
     cascReg=3'b000;vecFlag=1'b0;
       end 
  end
  always @(posedge pulse2 or negedge pulse1)
      if(SP)
        begin
          cascReg=3'b000;
          vecFlag=1'b0;
        end
      else
        begin end
        
        
  
  always@(posedge pulse2)
  begin
    if(!SNGL)
      if(!SP)
        begin
          if(flag)
            vecFlag=1;
          else
            vecFlag=0;
        end
      else
        vecFlag=0;
    else
      vecFlag=0;                   
  end
  
  always@(posedge pulse1)
  begin
    if(!SNGL)
      if(!SP)
        begin
          if(slaveReg==casc)
            flag=1;
          else
            flag=0;
        end
      else
        flag=0;
    else
      flag=0;                   
  end
 

endmodule

