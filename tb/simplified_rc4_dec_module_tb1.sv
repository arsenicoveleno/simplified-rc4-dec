module rc4_dec_module_tb1;
	
	// Clock declaration
	reg clk = 1'b0;
	always #5 clk = !clk;

	// Reset declaration
	reg rst_n = 1'b0;
	initial #12.8 rst_n = 1'b1;

	// Variabili
	reg	din_valid;
	reg	[7:0]	key	[31:0];
	reg	[7:0]	ciphertext0 [26:0]; // cifrato
    reg	[7:0]	plaintext0  [26:0]; // plain
    reg [7:0]	din; // Cipher x byte
	reg	[8:0]	index1 = 0;
	reg	[8:0]	index2 = 0;

    wire	[7:0]	dout;
    wire	dout_ready;
    wire	init_done;

	rc4_dec_module tb(
		.clk		(clk),
		.rst_n		(rst_n),
		.key		(key),
		.din       	(din),
		.din_valid 	(din_valid),
		.dout_ready	(dout_ready),
		.dout      	(dout),
		.init_done 	(init_done)
	);

	// Strutture dati
	reg	[8:0]	byte_index [$];
	// Contatore
	reg [8:0]	i;
	reg	[8:0]	j;

	initial begin
		@(posedge rst_n)
		$readmemb("tv/key1.txt", key);
		$readmemb("tv/cipher1.txt", ciphertext0);
		$readmemb("tv/plain1.txt", plaintext0);

		@(posedge clk);
		din_valid = 0;

		@(posedge init_done);

		fork
			begin
				for(i = 0; i < 27; i++) begin
					din_valid = 1;
					din = ciphertext0[index1];

					@(posedge clk);
					wait (dout_ready == 1);

					byte_index.push_back(index1);
					index1 += 1;
				end
				din_valid = 0; // Finito la lettura
			end

			begin
				@(posedge clk);
				wait (dout_ready == 1);
				for(j = 0; j < 27; j++) begin
					@(posedge clk);

					if (byte_index.size() > 0) begin
						index2 = byte_index.pop_front();
					end
					else begin
						$display("Errore: byte_index è vuoto!");
						$stop;
					end

					// Display per il confronto
					$display("%2d| Cipher: %-8b  Decoded: %-8b  Expected: %-8b  dout_ready: %1d %-5s",
						index2, ciphertext0[index2], dout, plaintext0[index2],
						dout_ready, (plaintext0[index2] === dout && dout_ready) ? "OK" : "ERROR");

					// Verifica se l'output è corretto
					if(plaintext0[index2] !== dout || 1 != dout_ready) begin
						$display("Errore al byte %2d: Decodifica errata!", index2);
						$stop;
					end
				end
				$display("Test completato con successo!");
				$stop;
			end
		join
	end

endmodule