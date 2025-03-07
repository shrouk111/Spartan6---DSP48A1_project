module DSP #(
    parameter A0REG = 0, A1REG = 1,
    parameter B0REG = 0, B1REG = 1,
    parameter CREG = 1, DREG = 1, 
    parameter MREG = 1, PREG = 1, 
    parameter CARRYINREG = 1, CARRYOUTREG = 1,
    parameter OPMODEREG = 1, 
    parameter CARRYINSEL = "OPMODE5", 
    parameter B_INPUT = "DIRECT",
    parameter RSTTYPE = "SYNC"
)(
    input [17:0] A, B, D, BCIN,
    input [47:0] C, PCIN,
    input [7:0] OPMODE,
    input CARRYIN, clk, CEA, CEB, CEC, CED,
    input CECARRYIN, CEOPMODE, CEM, CEP,
    input RSTA, RSTB, RSTC, RSTD,
    input RSTCARRYIN, RSTOPMODE, RSTM, RSTP,
    
    output reg [17:0] BCOUT,
    output reg [35:0] M,
    output reg [47:0] P, PCOUT,
    output reg CARRYOUT, CARRYOUTF
);


reg [17:0] B0REG_IN, PRE_OUT, MUX2_OUT;
reg [47:0] MULTIP_OUT, MUX_X, MUX_Z, result;
reg CARRY_MUX_OUT, cout;
reg [48:0] POST_OUT;

wire [17:0] A0, B0, D0, B1, A1;
wire [47:0] C0, M0, P0;
wire CIN;
wire [7:0] OPMODE_reg;


always @(*) begin
    B0REG_IN = (B_INPUT == "DIRECT") ? B : BCIN;
end


always @(*) begin
    CARRY_MUX_OUT = (CARRYINSEL == "OPMODE5") ? OPMODE_reg[5] : CARRYIN;
end


reg_mux #(.size(18), .type(RSTTYPE), .sel(A0REG)) RM1 (A, clk, RSTA, CEA, A0);
reg_mux #(.size(18), .type(RSTTYPE), .sel(B0REG)) RM2 (B0REG_IN, clk, RSTB, CEB, B0);
reg_mux #(.size(48), .type(RSTTYPE), .sel(CREG)) RM3 (C, clk, RSTC, CEC, C0);
reg_mux #(.size(18), .type(RSTTYPE), .sel(DREG)) RM4 (D, clk, RSTD, CED, D0);
reg_mux #(.size(8), .type(RSTTYPE), .sel(PREG)) RM5 (OPMODE, clk, RSTOPMODE, CEOPMODE, OPMODE_reg);
reg_mux #(.size(18), .type(RSTTYPE), .sel(A1REG)) RM6 (A0, clk, RSTA, CEA, A1);
reg_mux #(.size(18), .type(RSTTYPE), .sel(B1REG)) RM7 (MUX2_OUT, clk, RSTB, CEB, B1);
reg_mux #(.size(48), .type(RSTTYPE), .sel(MREG)) RM8 (MULTIP_OUT, clk, RSTM, CEM, M0);
reg_mux #(.size(1), .type(RSTTYPE), .sel(CARRYINREG)) RM9 (CARRY_MUX_OUT, clk, RSTCARRYIN, CECARRYIN, CIN);
reg_mux #(.size(1), .type(RSTTYPE), .sel(CARRYOUTREG)) RM10 (cout, clk, RSTCARRYIN, CECARRYIN, CYO);
reg_mux #(.size(48), .type(RSTTYPE), .sel(PREG)) RM11 (result, clk, RSTP, CEP, P0);


always @(*) begin
    case (OPMODE_reg[1:0])
        2'b00: MUX_X = 0;
        2'b01: MUX_X = M0;
        2'b10: MUX_X = PCOUT;
        2'b11: MUX_X = {D0[11:0], A1, B1};
    endcase

    case (OPMODE_reg[3:2])
        2'b00: MUX_Z = 0;
        2'b01: MUX_Z = PCIN;
        2'b10: MUX_Z = P;
        2'b11: MUX_Z = C0;
    endcase
end


always @(*) begin
  
    PRE_OUT = (OPMODE_reg[6]) ? (D0 - B0) : (D0 + B0);

  
    MUX2_OUT = (OPMODE_reg[4]) ? PRE_OUT : B0;


    POST_OUT = (OPMODE_reg[7]) ? (MUX_Z - (MUX_X + CIN)) : (MUX_Z + (MUX_X + CIN));

 
    result = POST_OUT[47:0];
    cout = POST_OUT[48];

   
    BCOUT = B1;
    MULTIP_OUT = A1 * B1;
    M = M0[35:0];
    P = P0;
    PCOUT = P0;
    CARRYOUT = cout;
    CARRYOUTF = cout;
end

endmodule
