module preprocess(
    input [4:0]height,
    input clk,
    input en,
    input rst,
    output reg [3:0]addr
);

wire [4:0]sub4;
assign sub4 = height - 4;

always@(posedge clk)begin
    if(rst)
        addr <= 4'd0;
    else if (en)
        addr <= (sub4[3:0] >= 9)? 9 : sub4[3:0];
end

endmodule