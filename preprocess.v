module preprocess(
    input [4:0]height,
    output [3:0]addr
);
wire [3:0]sub4;
assign sub4 = height - 4;
assign addr = (sub4 >= 9)? 9 : sub4;

endmodule