module uart_tx #(
    parameter logic [31:0] BAUD_DIV = 868 // 100MHz / 115200 baud rate
)(
    input       clk, // 100 MHz clk
    input       resetn,
    input [7:0] data,
    input       dvalid,
    output      tx,
    output logic ready
);

    enum logic {READY, BUSY} state;
    localparam logic START = 1'b0;
    localparam logic STOP = 1'b1;
    localparam logic [31:0] DIV_VAL = BAUD_DIV-1; // Counter starts from zero

    logic [3:0]  count;
    logic        dvalid_d;
    logic        dvalid_re;
    logic [31:0] div_count;
    logic        tx_en;
    logic [9:0]  tx_frame;
    logic        load_next;

    assign ready = ~dvalid_re & (state == READY);

    assign dvalid_re = ~dvalid_d & dvalid;
    always_ff @(posedge clk or negedge resetn)
        if (~resetn) dvalid_d <= 'b0;
        else         dvalid_d <= dvalid;

    always_ff @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            state <= READY;
        end else begin
            case (state)
                READY: if (dvalid_re)
                            state <= BUSY;
                BUSY: if (count == 4'd8 & load_next)
                            state <= READY;
            endcase
        end
    end

    always_ff @(posedge clk or negedge resetn) begin
        if (~resetn)                    count <= 'b0;
        else if (dvalid_re)             count <= 'b0;
        else if (state == BUSY & tx_en) count <= count + 1'b1;
    end

    assign tx_en = div_count == DIV_VAL;
    assign load_next = div_count == (DIV_VAL-1);

    always_ff @(posedge clk or negedge resetn)
        if (~resetn)            div_count <= 'b0;
        else if (dvalid_re)     div_count <= 'b0;
        else if (tx_en)         div_count <= 'b0;
        else if (state == BUSY) div_count <= div_count + 1'b1;

    assign tx = tx_frame[0];

    always_ff @(posedge clk or negedge resetn)
        if (~resetn) tx_frame <= '1;
        else if (dvalid_re) tx_frame <= {STOP, data[7:0], START};
        else if (tx_en)     tx_frame <= {1'b1, tx_frame[9:1]};

endmodule
