module d_flipflop(
	input wire d, q, rise,
	output wire q_next
);

assign q_next = rise ? d : q;

endmodule