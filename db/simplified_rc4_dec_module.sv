module rc4_dec_module (
	input				clk,
	input 				rst_n,
	input	[7:0]		key [31:0],
	input	[7:0]		din, // Ciphertext
	input 				din_valid,
	output	reg			dout_ready,
	output	reg	[7:0]	dout, // Plaintext		
	output	reg			init_done
);

	reg	[7:0]	S_mem	[255:0];
	reg	[7:0]	S_ij;
	reg [2:0] 	state;
	reg [7:0] 	i;
	reg [7:0] 	j;

	always @ (posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			dout <= 8'b0; // NULL
			dout_ready <= 1'b0;
			init_done <= 1'b0;
			state <= 0;	
		end
		else begin
			case (state)
				0 : begin // Inizializzazione di S
					for (int k = 0; k < 256; k=k+1) begin
						S_mem[k] <= k;
					end
					state <= 1;
					i <= 0;
					j <= 0;
				end 
				1 : begin // Key-scheduling algorithm, assegno j
					j <= (j+ S_mem[i] + key[i % 32]) % 256;
					state <= 2;
				end
				2 : begin // Key-scheduling algorithm, swap di i e j
					S_mem[i] <= S_mem[j];
					S_mem[j] <= S_mem[i];

					if (i==255) begin
						state <= 3;
						i <= 1'b1;
						j <= 1'b0 + S_mem[1];
					end
					else begin
						i <= i + 1'b1;
						state <= 1;
					end
				end
				3 : begin // Pseudo-random Generation Algorithm, inizializzo swap e somma
					S_mem[i] <= S_mem[j];
					S_mem[j] <= S_mem[i];

					S_ij <= (S_mem[i] + S_mem[j]) % 256;

					i <= i + 1'b1;

					init_done <= 1;
					state <= 4;
				end
				4 : begin // Pseudo-random Generation Algorithm, output e ciclo
					if (din_valid == 1) begin
						dout <= S_mem[S_ij] ^ din;
						dout_ready <= 1'b1;

						j <= (j + S_mem[i]) % 256;

						S_mem[i] <= S_mem[j + S_mem[i]];
						S_mem[j + S_mem[i]] <= S_mem[i];

						S_ij <= (S_mem[i] + S_mem[j + S_mem[i]]) % 256;

						i <= i + 1'b1;
					end
					else begin
						dout_ready <= 1'b0;
						dout <= 8'b0; // NULL
					end

					state <= 4;
				end
				default: begin
					state <= 0;
				end
			endcase
		end
	end

endmodule
