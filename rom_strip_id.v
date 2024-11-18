module rom_strip_id(
    input [3:0] addr,//height preprocessed into address, 0-9
    input clk,
    output reg[3:0]Id1,// most priority
    output reg[3:0]Id2,
    output reg[3:0]Id3
);
wire [11:0] DataID[9:0];

        
assign  DataID[0] = 12'h97D;//4
assign  DataID[1] = 12'h75D;//5
assign  DataID[2] = 12'h53D;//6
assign  DataID[3] = 12'h301;//7
assign  DataID[4] = 12'h012;//8
assign  DataID[5] = 12'h24D;//9
assign  DataID[6] = 12'h46D;//10
assign  DataID[7] = 12'h68D;//11
assign  DataID[8] = 12'h8DD;//12
assign  DataID[9] = 12'hCBA;//13,14,15,16.
//0 means strip id = 1;1 means strip id =2;
//D means strip id invalid


    
always@(posedge clk)begin
    begin
        Id1 <= DataID[addr][11:8];
        Id2 <= DataID[addr][7:4];
        Id3 <= DataID[addr][3:0];
    end
end


endmodule