all:
	$(MAKE) -C . uart_tx_tb
	$(MAKE) -C . uart_test_tb

uart_tx_tb: rtl/uart_tx.sv rtl/sim/uart_test_tb.sv
	sed -i 's/always_ff/always/g' $@
	iverilog -g2012 -o $@ $^
	vvp $@

uart_test_tb: rtl/uart_tx.sv rtl/uart_test.sv rtl/sim/uart_test_tb.sv
	sed -i 's/always_ff/always/g' $@
	iverilog -g2012 -D SIM -o $@ 
	vvp $@
