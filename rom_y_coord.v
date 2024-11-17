module rom_y_coord(
    input [3:0] addr, //strip id
    input clk,
    input en,          //enable
    output reg[6:0] index_y // index_y of the selected strip
);

wire [6:0] DataReg[12:0];

assign  DataReg[0]  = 7'd0;
assign  DataReg[1]  = 7'd8;
assign  DataReg[2]  = 7'd16;
assign  DataReg[3]  = 7'd25;
assign  DataReg[4]  = 7'd32;
assign  DataReg[5]  = 7'd42;
assign  DataReg[6]  = 7'd48;
assign  DataReg[7]  = 7'd59;
assign  DataReg[8]  = 7'd64;
assign  DataReg[9]  = 7'd76;
assign  DataReg[10] = 7'd80;
assign  DataReg[11] = 7'd96;
assign  DataReg[12] = 7'd112;

always@(posedge clk)begin
    if(en) index_y <= DataReg[addr];
end

endmodule