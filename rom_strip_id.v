module rom_strip_id(
    input [3:0] addr,//height preprocessed into address, 0-9
    input clk,
    input en,//enable
    output reg [3:0]Id1,// most priority
    output reg [3:0]Id2,
    output reg [3:0]Id3
);
    reg [11:0] DataReg[9:0];

        
    always@(*)begin           
        DataReg[0] = 12'hA80;//4
        DataReg[1] = 12'h860;//5
        DataReg[2] = 12'h640;//6
        DataReg[3] = 12'h412;//7
        DataReg[4] = 12'h123;//8
        DataReg[5] = 12'h350;//9
        DataReg[6] = 12'h570;//10
        DataReg[7] = 12'h790;//11
        DataReg[8] = 12'h900;//12
        DataReg[9] = 12'hBCD;//13,14,15,16
    end
    
    always@(posedge clk)begin
        if(en)
            Id1 <= DataReg[addr][11:8];
            Id2 <= DataReg[addr][7:4];
            Id3 <= DataReg[addr][3:0];
    end


endmodule