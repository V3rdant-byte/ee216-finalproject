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

wire start_w;
assign start_w = (height!=5'b0);
reg start_r;

reg [1:0]state;

always@(posedge clk) begin
    if (rst) start_r <= 1'b0;
    if (start_w) start_r <= 1'b1;
end

always@(posedge clk)begin
    if(rst) begin
        state <= 2'b00;
    end
    else if(start_w || start_r) begin
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

assign en1 = (state==2'b00);
assign en2 = (state==2'b01);
assign en3 = (state==2'b10);
assign en4 = (state==2'b11);
endmodule