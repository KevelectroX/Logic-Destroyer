// CLK = 50_000_000 Hz
// baud UART = 9600
// CLKS_PER_BIT = CLK/baud = 5208

module UART_RX
#(parameter CLK_PER_BIT = 5208)
(
	input i_clock,
	input i_RX_Serial,
	output o_RX_DV,
	output [7:0] o_RX_Byte
);

	localparam IDLE = 3'b000;
	localparam RX_START_BIT = 3'b001;
	localparam RX_DATA_BITS = 3'b010;
	localparam RX_STOP_BIT = 3'b011;
	localparam CLEANUP = 3'b100;


	reg [12:0] r_Clock_Count = 0;
	reg [2:0] r_Bit_Index = 0;
	reg [7:0] r_RX_Byte = 0;
	reg 		 r_RX_DV = 0;
	reg [2:0] r_SM_Main = 0;
	reg r_RX_Data_R = 1'b1;
	reg r_RX_Data = 1'b1;

	assign o_RX_DV = r_RX_DV;
	assign o_RX_Byte = r_RX_Byte;

	always @(posedge i_clock)
	begin
		r_RX_Data_R <= i_RX_Serial;
		r_RX_Data <= r_RX_Data_R;
	end

// Controlar la maquina de estados RX
	always @(posedge i_clock)
	begin
		
		case(r_SM_Main)
			IDLE : 
			begin
				r_RX_DV <= 1'b0;
				r_Clock_Count <= 0;
				r_Bit_Index <= 0;
				
				if (r_RX_Data == 1'b0)
					r_SM_Main <= RX_START_BIT;
				else
					r_SM_Main <= IDLE;
					
			end
		
		
		// Comprobar si el bit de la mitad del incio sigue bajo
		RX_START_BIT : 
			begin 
				if (r_Clock_Count == (CLK_PER_BIT-1)/2)
				begin
				
					if (r_RX_Data == 1'b0)
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
					r_RX_Byte[r_Bit_Index] <= r_RX_Data;
					
					
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