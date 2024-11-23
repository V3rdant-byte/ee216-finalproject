`timescale 1ns / 100ps

//Do NOT Modify This Module
module P1_Reg_8_bit (DataIn, DataOut, rst, clk);

    input [7:0] DataIn;
    output [7:0] DataOut;
    input rst;
    input clk;
    reg [7:0] DataReg;
   
    always @(posedge clk)
  	if(rst)
            DataReg <= 8'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule

//Do NOT Modify This Module
module P1_Reg_5_bit (DataIn, DataOut, rst, clk);

    input [4:0] DataIn;
    output [4:0] DataOut;
    input rst;
    input clk;
    reg [4:0] DataReg;
    
    always @(posedge clk or posedge rst)
        if(rst)
            DataReg <= 5'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule

//Do NOT Modify This Module
module P1_Reg_4_bit (DataIn, DataOut, rst, clk);

    input [3:0] DataIn;
    output [3:0] DataOut;
    input rst;
    input clk;
    reg [3:0] DataReg;
    
    always @(posedge clk)
        if(rst)
            DataReg <= 4'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule

//Do NOT Modify This Module's I/O Definition
module M216A_TopModule(
    clk_i,
    width_i,
    height_i,
    index_x_o,
    index_y_o,
    strike_o,
    rst_i
);

input clk_i;
input [4:0] width_i;
input [4:0] height_i;
output [7:0] index_x_o;
output [7:0] index_y_o;
output [3:0] strike_o;
input rst_i;

//Add your code below 
//Make sure to Register the outputs using the Register modules given above

wire [4:0] width;
wire [4:0] height;

wire en1;
wire en2;
wire en3;
wire en4;

wire [3:0] strip_ID_addr;
wire [3:0] Id1;
wire [3:0] Id2;
wire [3:0] Id3;

wire [3:0] write_id;
wire [4:0] write_width;
wire [7:0] Width1;
wire [7:0] Width2;
wire [7:0] Width3;

wire [3:0] Id_optimal;
wire [7:0] Width_optimal;

wire strike;

wire [7:0] index_x_o_w;
wire [7:0] index_y_o_w;
wire [3:0] strike_o_w;

reg [4:0] width_reg;

// fsm controller
controller controller_inst(
    .height(height_i),
    .clk(clk_i),
    .rst(rst_i),
    .strike(strike),
    .en1(en1),
    .en2(en2),
    .en3(en3),
    .en4(en4)
);

// cycle 0
P1_Reg_5_bit input_height_reg_5(
    .DataIn(height_i),
    .DataOut(height),
    .rst(rst_i),
    .clk(en1)
);

P1_Reg_5_bit input_width_reg_5(
    .DataIn(width_i),
    .DataOut(width),
    .rst(rst_i),
    .clk(en1)
);

// cycle 1
preprocess p1(
    .clk(en2),
    .rst(rst_i),
    .height(height),
    .addr(strip_ID_addr)
);

// cycle 2
rom_strip_id rom_strip_id_inst(
    .addr(strip_ID_addr),//height preprocessed into address, 0-9
    .clk(en3),
    .Id1(Id1),// most priority
    .Id2(Id2),
    .Id3(Id3),
    .rst(rst_i)
);

// cycle 3
ram_occupied_width ram_occupied_width_inst(
    .rst(rst_i),
    .enclk(en4),            // enable clk
    .we(en3),               // write enable
    .write_id(Id_optimal),   // ID to update
    .write_width(width_reg),// New width value to add, 5 bits range from 4-16
    .Id1(Id1),        // most priority
    .Id2(Id2),
    .Id3(Id3),
    .Width1(Width1),
    .Width2(Width2),
    .Width3(Width3),
    .strike(strike)
);

// cycle 4
optimal_strip_calculator optimal_strip_calculator_inst(
    .rst(rst_i),
    .enclk(en1),              // enable clock
    .Id1(Id1),        // most priority
    .Id2(Id2),
    .Id3(Id3),
    .Width1(Width1),
    .Width2(Width2),
    .Width3(Width3),
    .Id_optimal(Id_optimal),
    .Width_optimal(Width_optimal)
);

// forward old width to cycle 5
always@(posedge en1 or posedge rst_i) begin
    if (rst_i) width_reg <= 5'b0;
    else width_reg <= width;
end

// cycle 5
max_wdith_checker max_wdith_checker_inst(
    .enclk(en2),
    .rst(rst_i),
    .width_i(width_reg),
    .occupied_width(Width_optimal),
    .strike(strike)
);

// cycle 6
index_calc index_calc_inst(
    .enclk(en3),
    .rst(rst_i),
    .strike(strike),
    .strip_id(Id_optimal),
    .occupied_width(Width_optimal),
    .index_x_o(index_x_o_w),
    .index_y_o(index_y_o_w),
    .strike_o(strike_o_w)
);

// cycle 7
P1_Reg_8_bit output_width_reg_8(
    .DataIn(index_x_o_w), 
    .DataOut(index_x_o), 
    .rst(rst_i), 
    .clk(en4)
);

P1_Reg_8_bit output_height_reg_8(
    .DataIn(index_y_o_w), 
    .DataOut(index_y_o), 
    .rst(rst_i), 
    .clk(en4)
);

P1_Reg_4_bit output_strike_reg_4(
    .DataIn(strike_o_w), 
    .DataOut(strike_o), 
    .rst(rst_i), 
    .clk(en4)
);

endmodule
