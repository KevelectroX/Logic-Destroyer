module t_flipflop(
	input wire t, q, rise,
	output wire q_next
);

assign q_next = rise ? ((~t & q) | (t & ~q)) : q; 

endmodule