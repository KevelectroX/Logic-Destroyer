module semi_sum(
	input wire a, b,
	output s, c_out
);

assign s = ((a & ~b) | (~a & b));
assign c_out = a & b;

endmodule