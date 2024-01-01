module Read_Write_Logic(
    output reg read_enable,
    output reg write_enable,
    input chip_select,
    input read_flag,
    input write_flag
);


    reg [1:0] count = 2'b00;
  initial begin
    read_enable =1;
    write_enable =1;
  end

  always @( chip_select , read_flag, write_flag) begin
       
         if (~chip_select) begin
           if(~read_flag & ~write_flag) begin 
           	    read_enable <= 1'b1;
                write_enable <=1'b1;
             	count <= 2'b00;
           end
            // Check for read operation
           else if ( ~ read_flag) begin
                read_enable <= 1'b0;
             	write_enable <=1'b1;
             	count <= 2'b00;
            end
            // Check for write operation
           else if (~ write_flag) begin
             read_enable <= 1'b1;
                // Write operation happens after two bytes of low signal
             if (count == 2'b01) begin
               		write_enable <= 1'b0;
               		read_enable <=1'b1;
                    count <= 2'b00;
                end 
             else begin
                    count <= count + 1;
               		write_enable <= 1'b1;
               		read_enable <=1'b1;
                end
            end
            
           else begin 
           		read_enable <= 1'b1;
                write_enable <=1'b1;
           end
        end
    	else begin 
                 // To avoid read and write operations hapenning at set CS
                read_enable <= 1'b1;
                write_enable <=1'b1;
          		count <=2'b00;
        end
    end

endmodule
