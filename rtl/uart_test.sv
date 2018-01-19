module uart_test (
    input       clkin,
    input       resetn_in,
    input       pb,
    output      tx
);
    logic        clk;
    logic        resetn;
    logic [7:0]  data;
    logic        dvalid;
    logic        ready;
    logic [4:0]  count;

    `ifdef SIM
        assign clk = clkin;
    `else
        pll_2x  u_pll(
           .c0(clk),
           .inclk0(clkin),
           .locked());
    `endif
    uart_tx dut (.*);
    always_ff @(negedge clk or negedge resetn_in)
        if (~resetn_in) resetn <= 'b0;
        else            resetn <= 1'b1;

    logic pb_d, pb_fe;
    always_ff @(posedge clk or negedge resetn)
        if (~resetn) pb_d <= 'b0;
        else         pb_d <= pb;

    assign pb_fe = ~pb & pb_d;

    always_ff @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            dvalid <= '0;
            data <= '0;
            count <= '0;
        end else begin
            if (count < 26 & ready) begin
            //if (count < 26 & ready & pb_fe) begin
                dvalid <= 1'b1;
                data <= count + "A";
                count <= count + 1'b1;
            end else begin
                dvalid <= 'b0;
                data <= '0;
            end
        end
    end

endmodule
