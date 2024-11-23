module index_calc(
    input clk,
    input en,
    input rst,
    input strike,
    input [3:0] strip_id,
    input [6:0] occupied_width,
    output [7:0] index_x_o,
    output [7:0] index_y_o,
    output [3:0] strike_o
);

wire rom_en = (~strike && en);
reg [3:0] strike_count;
wire [6:0] index_y;
reg [7:0] index_x_r;
reg [7:0] index_y_r;
reg strike_r;

always@(posedge clk)
    if (rst) strike_r <= 1'b0;
    else if (strike) strike_r <= 1'b1;
    else strike_r <= 1'b0;

rom_y_coord ROM_Y (.clk(clk),
                    .en(rom_en),
                    .addr(strip_id),
                    .index_y(index_y),
                    .rst(rst));

assign index_y_o = (strike_r == 1'b1) ? index_y_r : {1'b0, index_y};
assign index_x_o = index_x_r;
assign strike_o = strike_count;

always@(posedge clk) begin
    if (rst) index_y_r <= 0;
    else if (strike && en) index_y_r <= 8'd128;
end

always@(posedge clk) begin
    if (rst) index_x_r <= 8'b0;
    else if (en) begin
        if (strike) index_x_r <= 8'd128;
        else index_x_r <= {1'b0, occupied_width};
    end
end

always@(posedge clk) begin
    if (rst) begin
        strike_count <= 4'b0;
    end
    else begin
        if (strike && en) begin
            strike_count <= strike_count + 4'b1;
        end
    end
end
endmodule