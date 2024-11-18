module optimal_strip_calculator(
    input enclk,              // enable clock
    input rst,
    input [3:0] Id1,        // most priority
    input [3:0] Id2,
    input [3:0] Id3,
    input [6:0] Width1,
    input [6:0] Width2,
    input [6:0] Width3,
    output reg [3:0] Id_optimal,
    output reg [6:0] Width_optimal
);
    reg [3:0] id;
    reg [6:0] wid;

    always @(*) begin
        // Default to Width1 and Id1
        wid = Width1;
        id = Id1;

        // Compare Width2
        if (Width2 < wid) begin
            wid = Width2;
            id = Id2;
        end

        // Compare Width3
        if (Width3 < wid) begin
            wid = Width3;
            id = Id3;
        end
    end

    always @(posedge enclk or posedge rst) begin
        if (rst) begin
            Id_optimal <= 4'd0;
            Width_optimal <= 7'd0;
        end
        else begin
            Id_optimal <= id;
            Width_optimal <= wid;
        end
    end

endmodule