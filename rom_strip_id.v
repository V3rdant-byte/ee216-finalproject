module rom_strip_id(
    input [3:0] addr,//height preprocessed into address, 0-9
    input clk,
    input en,//enable
    output reg[3:0]Id1,// most priority
    output reg[3:0]Id2,
    output reg[3:0]Id3
);
wire [11:0] DataReg[9:0];

        
assign  DataReg[0] = 12'hA80;//4
assign  DataReg[1] = 12'h860;//5
assign  DataReg[2] = 12'h640;//6
assign  DataReg[3] = 12'h412;//7
assign  DataReg[4] = 12'h123;//8
assign  DataReg[5] = 12'h350;//9
assign  DataReg[6] = 12'h570;//10
assign  DataReg[7] = 12'h790;//11
assign  DataReg[8] = 12'h900;//12
assign  DataReg[9] = 12'hBCD;//13,14,15,16

    
always@(posedge clk)begin
    if(en)
        Id1 <= DataReg[addr][11:8];
        Id2 <= DataReg[addr][7:4];
        Id3 <= DataReg[addr][3:0];
end


endmodule