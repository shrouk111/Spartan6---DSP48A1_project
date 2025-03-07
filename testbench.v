
module testbench ();

reg [17:0] A , B , D , BCIN ;
reg [47:0] C , PCIN ;
reg [7:0] OPMODE ;
reg CARRYIN , clk , CEA , CEB , CEC , CED  , CECARRYIN , CEOPMODE , CEM , CEP , RSTA , RSTB , RSTC , RSTD , RSTCARRYIN , RSTOPMODE , RSTM , RSTP ;

wire  [17:0] BCOUT_DUT ;
wire  [35:0] M_DUT ;
wire [47:0] P_DUT , PCOUT_DUT ;
wire CARRYOUT_DUT , CARRYOUTF_DUT ;

DSP DUT (A, B, C, D, BCIN, PCIN, CARRYIN, OPMODE, clk, CEA, CEB, CEC, CED, CECARRYIN, CEOPMODE, CEM, CEP, 
         RSTA, RSTB, RSTC, RSTD, RSTCARRYIN, RSTOPMODE, RSTM, RSTP, 
         BCOUT_DUT, M_DUT, P_DUT, PCOUT_DUT, CARRYOUT_DUT, CARRYOUTF_DUT);

initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

initial begin
    
    A = 0; B = 0; C = 0; D = 0;
    BCIN = 0; PCIN = 0; CARRYIN = 0;
    OPMODE = 0;

    CEA = 0; CEB = 0; CEC = 0; CED = 0;
    CECARRYIN = 0; CEOPMODE = 0; CEM = 0; CEP = 0;

    RSTA = 1; RSTB = 1; RSTC = 1; RSTD = 1;
    RSTCARRYIN = 1; RSTOPMODE = 1; RSTM = 1; RSTP = 1;

    
    repeat (10) @(negedge clk);

    
    RSTA = 0; RSTB = 0; RSTC = 0; RSTD = 0;
    RSTCARRYIN = 0; RSTOPMODE = 0; RSTM = 0; RSTP = 0;

   
    repeat (5) @(negedge clk);

   
    CEA = 1; CEB = 1; CEC = 1; CED = 1;
    CECARRYIN = 1; CEOPMODE = 1; CEM = 1; CEP = 1;

    repeat(5) begin
        A = $random; B = $random; C = $random; D = $random;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        OPMODE = 8'b0011_1101;
        repeat(4) @(negedge clk);
    end

    $stop;
end
endmodule
