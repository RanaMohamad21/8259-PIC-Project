module Read_Write_Logic_tb;

  wire read_enable_tb;
  wire write_enable_tb;
  reg chip_select_tb;
  reg Ao_tb;
  reg reset_tb;
  reg read_flag_tb;
  reg write_flag_tb;

  // Instantiate the module
  Read_Write_Logic dut (
    .read_enable(read_enable_tb),
    .write_enable(write_enable_tb),
    .chip_select(chip_select_tb),
    .read_flag(read_flag_tb),
    .write_flag(write_flag_tb)
  );

  // Clock generation
  reg clk = 0;
  always #5 clk = ~clk;

  // Test stimulus
  initial begin
    // Initialize inputs
    read_flag_tb = 1'b1;
    write_flag_tb = 1'b1;
    chip_select_tb = 1'b1;

    // Test Case 1: Perform a read operation
    #10 chip_select_tb = 1'b0;
    #10 read_flag_tb = 1'b0;
    #10;
    #10 read_flag_tb = 1'b1;

    // Test Case 2: Perform a write operation
    #10 chip_select_tb = 1'b0;
    #10 write_flag_tb = 1'b0;
    #10 write_flag_tb = 1'b1;
    #10 write_flag_tb = 1'b0;
    #10 write_flag_tb = 1'b1;
    #10 chip_select_tb = 1'b1;
    // Test Case 3: Perform write and read operations together
    #10 chip_select_tb = 1'b0;
    #10 write_flag_tb = 1'b0;
    #10 write_flag_tb = 1'b1;
    #10 write_flag_tb = 1'b0;
        read_flag_tb = 1'b0;
    #10;
    #10 read_flag_tb = 1'b1;
    #10 write_flag_tb = 1'b1;
    
    //Test Case 4: Test read and write with high CS 
    //Read operation 
    #10 chip_select_tb = 1'b1;
    #10 read_flag_tb = 1'b0;
    #10;
    #10 read_flag_tb = 1'b1;
  

    //Write operation
    #10 chip_select_tb = 1'b1;
    #10 write_flag_tb = 1'b0;
    #10 write_flag_tb = 1'b1;
    #10 write_flag_tb = 1'b0;
    #10 write_flag_tb = 1'b1;
    
    // Check if a read signal comes between two write signals
    #10 chip_select_tb = 1'b0;
    #10 write_flag_tb = 1'b0;
    #10 write_flag_tb = 1'b1;
    #10 read_flag_tb = 1'b0;
    #10 read_flag_tb = 1'b1;
    #10 write_flag_tb = 1'b0;
    #10 write_flag_tb = 1'b1;
    
  end


    initial begin
    // End simulation
    $dumpfile("uvm.vcd");
    $dumpvars;
    #1000 $finish; 
    
  end


endmodule
