module jk_flipflop(
	input wire j, k, q, rise,
	output wire q_next
);

assign q_next = rise ? ((~k & q) | (j & ~q)) : q;

endmodule


