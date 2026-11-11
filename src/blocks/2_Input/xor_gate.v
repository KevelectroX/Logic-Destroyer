module xor_gate(
	input wire a, b,
	output wire c
);

assign c = ((a & ~b) | (~a & b));

endmodule