all:
	$(MAKE) -C . uart_tx_tb
	$(MAKE) -C . uart_test_tb
	$(MAKE) -C . reset

uart_tx_tb: rtl/uart_tx.sv rtl/sim/uart_tx_tb.sv
	sed -i 's/always_ff/always/g' $^
	iverilog -g2012 -o $@ $^
	vvp $@

uart_test_tb: rtl/uart_tx.sv rtl/uart_test.sv rtl/sim/uart_test_tb.sv
	sed -i 's/always_ff/always/g' $^
	iverilog -g2012 -D SIM -o $@ $^
	vvp $@

reset:
	sed 's/always/always_ff/g' -i rtl/*.sv rtl/sim/*.sv

clean:
	rm -rf *.vcd uart_tx_tb uart_test_tb
