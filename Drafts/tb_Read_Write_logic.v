// Code your testbench here
// or browse Examples
module Read_Write_Logic_tb;

  reg read_enable_tb;
  reg write_enable_tb;
  reg chip_select_tb;
  reg Ao_tb;
  reg reset_tb;
  wire read_flag_tb;
  wire write_flag_tb;

  // Instantiate the module
  Read_Write_Logic dut (
    .read_enable(read_enable_tb),
    .write_enable(write_enable_tb),
    .chip_select(chip_select_tb),
    .reset(reset_tb),
    .read_flag(read_flag_tb),
    .write_flag(write_flag_tb)
  );

  // Clock generation
  reg clk = 0;
  always #5 clk = ~clk;

  // Test stimulus
  initial begin
    // Initialize inputs
    read_enable_tb = 1'b1;
    write_enable_tb = 1'b1;
    chip_select_tb = 1'b1;
    reset_tb = 1'b1;

    // Apply reset
    #10 reset_tb = 1'b0;

    // Test Case 1: Perform a read operation
    #10 chip_select_tb = 1'b0;
    #10 read_enable_tb = 1'b0;
    #10;
    #10 read_enable_tb = 1'b1;

    // Test Case 2: Perform a write operation
    #10 chip_select_tb = 1'b0;
    #10 write_enable_tb = 1'b0;
    #10 write_enable_tb = 1'b1;
    #10 write_enable_tb = 1'b0;
    #10 write_enable_tb = 1'b1;
    #10 chip_select_tb = 1'b1;
    // Test Case 3: Perform write and read operations together
    #10 chip_select_tb = 1'b0;
    #10 write_enable_tb = 1'b0;
    #10 write_enable_tb = 1'b1;
    #10 write_enable_tb = 1'b0;
        read_enable_tb = 1'b0;
    #10;
    #10 read_enable_tb = 1'b1;
    #10 write_enable_tb = 1'b1;
    
    //Test Case 4: Test read and write with high CS 
    //Read operation 
    #10 chip_select_tb = 1'b1;
    #10 read_enable_tb = 1'b0;
    #10;
    #10 read_enable_tb = 1'b1;
    


    //Write operation
    #10 chip_select_tb = 1'b1;
    #10 write_enable_tb = 1'b0;
    #10 write_enable_tb = 1'b1;
    #10 write_enable_tb = 1'b0;
    #10 write_enable_tb = 1'b1;
    
    //Test Reset:
    #10 reset_tb = 1'b0;
    #10 reset_tb = 1'b1;
  end


    initial begin
    // End simulation
    $dumpfile("uvm.vcd");
    $dumpvars;
    #1000 $finish; 
    
  end


endmodule
