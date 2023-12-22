module cascade
  (
    input SP,
    input SNGL,
    input [2:0] slaveReg,
    input intrFlag,
    input [2:0] intrID,
    inout [2:0] casc,
    output reg vecFlag
  );
  reg [2:0] cascReg;
  reg [3:0] count;
  assign casc=cascReg; 
  always @(SNGL or SP or intrFlag)
  begin
    if(!SNGL)
      if(SP)
        begin
         cascReg= intrID;
         for (count = 0; count < 10; count = count + 1)
         cascReg=3'b000;
        end
      else
      cascReg=3'bzzz;   
    else
     cascReg=3'b000;    
  end
  always@(SNGL or SP or slaveReg or casc)
  begin
    if(!SNGL)
      if(!SP)
        begin
          if(slaveReg==casc)
            vecFlag=1;
          else
            vecFlag=0;
        end
      else
        vecFlag=0;
    else
      vecFlag=0;                   
  end
endmodule


