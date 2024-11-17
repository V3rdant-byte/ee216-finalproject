module index_calc(
    input enclk,
    input rst,
    input strike,
    input [3:0] strip_id,
    input [6:0] occupied_width,
    output [7:0] index_x_o,
    output [7:0] index_y_o,
    output [3:0] strike_o
);

wire rom_en = (~strike && enclk);
reg [3:0] strike_count;
reg [6:0] index_y;

rom_y_coord ROM_Y (.enclk(rom_en),
                    .addr(strip_id),
                    .index_y(index_y));

assign index_y_o = (strike == 1'b1) ? 8'd128 : {1'b0, index_y};
assign index_x_o = (strike == 1'b1) ? 8'd128 : {1'b0, occupied_width};
assign strike_o = strike_count;

always@(posedge enclk or posedge rst) begin
    if (rst) begin
        strike_count <= 4'b0;
    end
    else begin
        if (strike) begin
            strike_count <= strike_count + 4'b1;
        end
    end
end
endmodule