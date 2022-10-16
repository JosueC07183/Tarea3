all: run 

run:
	iverilog tb.v
	vvp a.out
	gtkwave clause22.vcd


