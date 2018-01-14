module uart_test_tb;
    localparam PERIOD = 2;
    logic       clkin;
    logic       resetn_in;
    logic       tx;

    initial begin
        clkin = 'b0;
        forever #(PERIOD/2.0) clkin = ~clkin;
    end

    uart_test dut (.*);

    initial begin
        $dumpfile("uart_test.vcd");
        $dumpvars;
        resetn_in = 'b0;
        @(negedge clkin) resetn_in = 'b1;
        #5000;
        $finish;
    end
endmodule
