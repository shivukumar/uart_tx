module uart_tx_tb;
    localparam PERIOD = 2;
    logic       clk;
    logic       resetn;
    logic [7:0] data;
    logic       dvalid;
    logic       ready;
    logic       tx;
    int         count = 'b0;

    initial begin
        clk = 'b0;
        forever #(PERIOD/2.0) clk = ~clk;
    end

    uart_tx #(3) dut (.*);

    initial begin
        $dumpfile("uart_tx.vcd");
        $dumpvars;
        resetn = 'b0;
        @(negedge clk) resetn = 'b1;
        while (count < 3) begin
            @(posedge clk)
            if (ready) begin
                data <= 8'hAA;
                dvalid <= 1'b1;
                count <= count + 1'b1;
            end else begin
                data <= 'b0;
                dvalid <= 'b0;
            end
        end
        $finish;
    end

endmodule
