module max_wdith_checker(
    input enclk,
    input rst,
    input [4:0] width_i,
    input [6:0] occupied_width,
    output reg strike
);

wire [7:0] sum_w = width_i + occupied_width;
wire strike_w = (sum_w > 8'd128) ? 1'b1 : 1'b0;

always @(posedge enclk or posedge rst) begin
    if (rst) strike <= 1'b0;
    else strike <= strike_w;
end

endmodule