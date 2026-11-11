
// CLK = 50_000_000 Hz
// baud UART = 115200
// CLKS_PER_BIT = CLK/baud = 435

module UART_RX
#(parameter CLK_PER_BIT = 435)
(
	input i_clock,
	input i_RX_Serial,
	output o_RX_DV,
	output [7:0] o_RX_Byte
);

	parameter IDLE = 3'b000;
	parameter RX_START_BIT = 3'b001;
	parameter RX_DATA	_BITS = 3'b010;
	parameter RX_STOP_BIT = 3'b011;
	parameter CLEANUP = 3'b100;


	reg [7:0] r_Clock_Count = 0;
	reg [2:0] r_Bit_Index = 0;
	reg [7:0] r_RX_Byte = 0;
	reg 		 r_RX_DV = 0;
	reg [2:0] r_SM_Main = 0;

// Controlar la maquina de estados RX
	always @(posedge i_Clock)
	begin
		
		case(r_SM_Main)
			IDLE : 
			begin
				r__RX_DV <= 1'b0;
				r_Clock_Count <= 0;
				r_Bit_Index <= 0;
				
				if (i_RX_Serial == 1'b0)
					r_SM_Main <= RX_START_BIT;
				else
					r_SM_Main <= IDLE;
					
			end
		
		
		// Comprobar si el bit de la mitad del incio sigue bajo
		RX_START_BIT : 
			begin 
				if (r_Clock_Count == (CLKS_PER_BIT-1)/2)
				begin
				
					if (i_RX_Serial == 1'b0)
					begin
						r_Clock_Count <= 0;	// Resetear el contador
						r_SM_Main 	  <= RX_DATA_BITS;
					end
					
					else
						r_SM_Main <= IDLE;
				end
				
				else
				begin
					r_Clock_Count <= r_Clock_Count + 1;
					r_SM_Main	  <= RX_START_BIT;
				end
			end
		
		
		// Espera CLK_PER_BIT - 1 ciclos de reloj para samplear la informacion
		RX_DATA_BITS : 
			begin
				if (r_Clock_Count < CLK_PER_BIT - 1)
				begin
					r_Clock_Count <= r_Clock_Count + 1;
					r_SM_Main     <= RX_DATA_BITS;
				end
				
				else
				begin
					r_Clock_Count <= 0;
					r_RX_Byte[r_Bit_Index] <= i_RX_Serial;
					
					
					// Revisa si se recibieron los 8 bits
					if (r_Bit_Index < 7)
					begin
						r_Bit_Index <= r_Bit_Index + 1;
						r_SM_Main   <= RX_DATA_BITS;
					end
					
					else
					begin
						r_Bit_Index <= 0;
						r_SM_Main	<= RX_STOP_BIT;
					end
				end
			end
		
		
		// Recibir el Stop Bit, siempre con el valor de 1
		RX_STOP_BIT :
			begin
			
			// Espera CLK_PER_BIT-1 ciclos de reloj para que el bit de stop finalice
			if (r_Clock_Count < CLK_PER_BIT-1)
			begin
				r_Clock_Count <= r_Clock_Count + 1;
				r_SM_Main     <= RX_STOP_BIT;
			end
			
			else
			begin
				r_RX_DV <= 1'b1;
				r_Clock_Count <= 0;
				r_SM_Main <= CLEANUP;
			end
		end
		
		
		// Se mantiene por 1 clock
		CLEANUP :
			begin
				r_SM_Main <= IDLE;
				r_RX_DV   <= 1'b0;
			end
			
			
		default:
			r_SM_Main <= IDLE;
		
		
		endcase
	end



endmodule