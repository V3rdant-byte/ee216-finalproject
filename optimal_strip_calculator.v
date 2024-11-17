module optimal_strip_calculator(
    input clk,
    input en,               // enable
    input [3:0] Id1,        // most priority
    input [3:0] Id2,
    input [3:0] Id3,
    input [6:0] Width1,
    input [6:0] Width2,
    input [6:0] Width3,
    output reg [3:0] Id_optimal,
    output reg [6:0] Width_optimal
);

    always @(posedge clk) begin
        if (en) begin
            // Default to Width1 and Id1
            Width_optimal = Width1;
            Id_optimal = Id1;

            // Compare Width2
            if (Width2 < Width_optimal) begin
                Width_optimal = Width2;
                Id_optimal = Id2;
            end

            // Compare Width3
            else if (Width3 < Width_optimal) begin
                Width_optimal = Width3;
                Id_optimal = Id3;
            end
        end
    end

endmodule