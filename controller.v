module controller(
    input [4:0]height,
    input clk,
    input rst,
    input strike,
    output en1,
    output en2,
    output en3,
    output en4
);

wire start1;
assign start1 = (height!=5'b0);
reg start2;


reg [1:0]state;

always@(posedge clk or posedge rst)begin
    if(rst) begin
        state <= 2'b00;
        start2 <= 1'b0;
    end
    else if(start1 || start2) begin
        start2 <= 1'b1;
        case(state)
            2'b00:begin
                state <= 2'b01;
            end
            2'b01:begin
                state <= 2'b10;
            end
            2'b10:begin
                state <= 2'b11;
            end
            2'b11:begin
                state <= 2'b00;
            end
        endcase
    end
end

assign en1 = (state!=2'b00);
assign en2 = (state!=2'b01);
assign en3 = (state!=2'b10);
assign en4 = (state!=2'b11);
endmodule