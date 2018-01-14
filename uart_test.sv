module uart_test (
    input       clkin,
    input       resetn_in,
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
    `endif
    uart_tx #(4) dut (.*);
    always_ff @(posedge clk or negedge resetn_in)
        if (~resetn_in) resetn <= 'b0;
        else            resetn <= 1'b1;

    always_ff @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            dvalid <= '0;
            data <= '0;
            count <= '0;
        end else begin
            if (count < 26) begin
                if (ready) begin
                    dvalid <= 1'b1;
                    data <= count + "A";
                    count <= count + 1'b1;
                end else begin
                    dvalid <= 'b0;
                    data <= '0;
                end
            end else begin
                dvalid <= 'b0;
                data <= '0;
            end
        end
    end

endmodule
