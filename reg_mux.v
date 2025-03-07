module reg_mux (data_in,clk,rst,enable,data_out);
    parameter size = 1;
    parameter type = "sync";
    parameter sel = 1;

    input  [size-1:0] data_in;
    input  clk,rst,enable;
    output reg [size-1:0] data_out;


reg [size-1:0] register;


always @(*) begin
    if (sel == 1) 
        data_out = register;
    else 
        data_out = data_in;
end


generate 
    if (type == "SYNC") begin
        always @(posedge clk) begin
            if (rst) 
                register <= 0;
            else if (enable) 
                register <= data_in;
        end
    end 
    else begin
        always @(posedge clk or negedge rst) begin
            if (rst) 
                register <= 0;
            else if (enable) 
                register <= data_in;
        end
    end
endgenerate

endmodule

