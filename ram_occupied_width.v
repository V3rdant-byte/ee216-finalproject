module ram_occupied_width(
    input rst,
    input enclk,            // enable clk
    input we,               // write enable
    input [3:0] write_id,   // ID to update
    input [4:0] write_width,// New width value to add, 5 bits range from 4-16
    input [3:0] Id1,        // most priority
    input [3:0] Id2,
    input [3:0] Id3,
    output reg [6:0] Width1,
    output reg [6:0] Width2,
    output reg [6:0] Width3
);

    // Memory array to store the occupied width for each ID
    // ID = 13, Width = 127
    reg [6:0] mem [0:13];
    integer i;

    always @(posedge enclk or posedge rst or posedge we) begin
        // Reset operation (occupied width to 0)
        if (rst) begin
            mem[13] <= 7'd127;
            for (i = 0; i <= 12; i = i + 1) begin
                mem[i] <= 7'b0;
            end
        end 
        else begin
            // Write operation
            if (~we) begin
                mem[write_id] <= mem[write_id] + write_width;
            end
            // Read operation
            else begin
                Width1 <= mem[Id1];
                Width2 <= mem[Id2];
                Width3 <= mem[Id3];
            end 
        end
    end

endmodule
