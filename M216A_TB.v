`timescale 10ps/1ps

module M216A_TB;

// Parameters
parameter hp = 72;
parameter TEST_FILE_INPUT = "input_test.txt";
parameter TEST_FILE_OUTPUT = "output_test.txt";

// Inputs
reg clk;
reg rst;
reg [4:0] height_i;
reg [4:0] width_i;

// Outputs
wire [3:0] strike_o;
wire [7:0] index_x_o;
wire [7:0] index_y_o;
integer input_file, output_file;
integer expected_index_x,expected_index_y;
integer count;
integer latency_check;
reg [31:0] file_data_input;
reg [31:0] file_data_output;
reg first_iteration = 1'b1;

M216A_TopModule uut (
  .clk_i(clk),
  .rst_i(rst),
  .height_i(height_i),
  .width_i(width_i),
  .strike_o(strike_o),
  .index_x_o(index_x_o),
  .index_y_o(index_y_o)
);

// Clock generation
always begin
  #hp clk = ~clk;
end

// Test stimulus
initial begin
  // Initialize inputs
  clk = 1'b0;
  rst = 1'b1;
  height_i = 5'b00000;
  width_i  = 5'b00000;
  count = 0;
  latency_check = 1;

  // Apply reset
  #(20*hp) rst = 1'b0;

  // Open files for input and output
  input_file = $fopen(TEST_FILE_INPUT, "r");

  fork
    forever @(posedge clk) begin
      if ($feof(input_file)) begin
        height_i = 5'b00000;
        width_i = 5'b00000;
      end
      else begin
        file_data_input = $fscanf(input_file, "%d %d\n", height_i, width_i);
      end
      #(8*hp); // Wait for 4 clock cycles
    end
  join
end

initial begin
  // Loop to check outputs with 8 clock cycle delay for the first output and then every 4 clock cycles
  expected_index_x = 5'b00000;
  expected_index_y = 5'b00000;
  
  #(20*hp);
  output_file = $fopen(TEST_FILE_OUTPUT, "r");
  
  fork
    forever @(posedge clk) begin
      if (first_iteration) begin
        #(16*hp); // Wait for 8 clock cycles only for the first iteration
        first_iteration = 1'b0; // Set to 0 after the first iteration
      end

      if ($feof(output_file)) begin
        // Stop simulation if end of file is reached
	if(count!=0) begin
	$display("No of failed tests: %d\n", count);
	end
	else if (count==0) begin
	  if (latency_check!=1) begin
		$display("Output latency is NOT correct!");
		$display("No of Strikes: %d\n", strike_o);
		$display("Output values are correct BUT latency is NOT correct!");
	  end
	  else begin
	  	$display("No of Strikes: %d\n", strike_o);
	  	$display("Congratulations: All tests passed");
	  end
	end
        $stop;
      end

      // Check output values and compare with expected output
      file_data_output = $fscanf(output_file, "%d %d\n", expected_index_x, expected_index_y);
      #(8*hp);
    end
  join
end

initial begin
  #(38*hp);
  fork
    forever begin
      if ((index_x_o != expected_index_x) || (index_y_o != expected_index_y)) begin
        $display("Test failed! Expected: %d %d, Actual: %d %d\n", expected_index_x, expected_index_y, index_x_o, index_y_o);
	count = count + 1;
      end
      #(8*hp);
    end
  join
end

initial begin
  fork
    forever begin
	if (rst == 1'b0) begin
		if ((index_x_o != expected_index_x) || (index_y_o != expected_index_y)) begin
			latency_check = 0;
		end
	end
	#(2*hp);
    end
  join
end

endmodule
