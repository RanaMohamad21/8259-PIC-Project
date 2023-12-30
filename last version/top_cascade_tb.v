module top_cascad_tb;
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

always@(*)
begin
    interrupt_requests <= {device2,device1, INT_Flag6,INT_Flag5,INT_Flag4,INT_Flag3,INT_Flag2,INT_Flag1};
end


assign data_Bus = (cnt==2'b10)? data_bus_container:8'bzzzzzzzz;
always@(negedge write_flag1 or posedge write_flag1 )
begin
if(write_flag==1'b0)
cnt = cnt +1;
if(write_flag==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag2 or posedge write_flag2 )
begin
if(write_flag==1'b0)
cnt = cnt +1;
if(write_flag==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag3 or posedge write_flag3 )
begin
if(write_flag==1'b0)
cnt = cnt +1;
if(write_flag==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag4 or posedge write_flag4 )
begin
if(write_flag==1'b0)
cnt = cnt +1;
if(write_flag==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag5 or posedge write_flag5 )
begin
if(write_flag==1'b0)
cnt = cnt +1;
if(write_flag==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag6 or posedge write_flag6 )
begin
if(write_flag==1'b0)
cnt = cnt +1;
if(write_flag==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end
always@(negedge write_flag or posedge write_flag)
begin
if(write_flag==1'b0)
cnt = cnt +1;
if(write_flag==1'b1 && cnt ==2'b10)
cnt = 2'b00;
end


top master (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag),.read_flag(read_flag),.sp(1'b1),.INTA(INTA),.INT_Flag(INT_Flag));
top slave1 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag1),.read_flag(read_flag1),.sp(1'b0),.INT_Flag1(INT_Flag1));
top slave2 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag2),.read_flag(read_flag2),.sp(1'b0),.INT_Flag2(INT_Flag2));
top slave3 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag3),.read_flag(read_flag3),.sp(1'b0),.INT_Flag3(INT_Flag3));
top slave4 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag4),.read_flag(read_flag4),.sp(1'b0),.INT_Flag4(INT_Flag4));
top slave5 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag5),.read_flag(read_flag5),.sp(1'b0),.INT_Flag5(INT_Flag5));
top slave6 (.data_Bus(data_Bus),.cascade_lines(cascade_lines),.write_flag(write_flag6),.read_flag(read_flag6),.sp(1'b0),.INT_Flag6(INT_Flag6));





endmodule