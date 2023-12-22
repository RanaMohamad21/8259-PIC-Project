module Read_Write_Logic(
    input read_enable,
    input write_enable,
    input chip_select,
    input reset, // Active high
    output reg read_flag,
    output reg write_flag
);

    reg [1:0] count = 2'b00;

    always @(posedge reset) begin
        if (reset) begin
            count <= 2'b00;
            read_flag <= 1'b1;
            write_flag <= 1'b1;
        end
    end


  always @( chip_select , read_enable, write_enable) begin
       
         if (~chip_select) begin
           if(~read_enable & ~write_enable) begin 
           	    read_flag <= 1'b1;
                write_flag <=1'b1;
           end
            // Check for read operation
            else if ( ~ read_enable) begin
                read_flag <= 1'b0;
            end
            // Check for write operation
           else if (~ write_enable) begin
                // Write operation happens after two bytes of low signal
             if (count == 2'b10) begin
                    count <= 2'b00;
                end else begin
                    count <= count + 1;
                end
            end
            else begin 
                 // To avoid read and write operations hapenning simultaniously
                read_flag <= 1'b1;
                write_flag <=1'b1;
            end
        end
    end
  
  always@(count)begin
    if(count ==2)
       write_flag <= 1'b0;
    else
      write_flag <= 1'b1;
  end

endmodule
