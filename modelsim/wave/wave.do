onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rc4_dec_module_tb1/clk
add wave -noupdate /rc4_dec_module_tb1/rst_n
add wave -noupdate /rc4_dec_module_tb1/din_valid
add wave -noupdate /rc4_dec_module_tb1/key
add wave -noupdate /rc4_dec_module_tb1/ciphertext0
add wave -noupdate /rc4_dec_module_tb1/plaintext0
add wave -noupdate /rc4_dec_module_tb1/din
add wave -noupdate /rc4_dec_module_tb1/index1
add wave -noupdate /rc4_dec_module_tb1/index2
add wave -noupdate /rc4_dec_module_tb1/dout
add wave -noupdate /rc4_dec_module_tb1/dout_ready
add wave -noupdate /rc4_dec_module_tb1/init_done
add wave -noupdate /rc4_dec_module_tb1/i
add wave -noupdate /rc4_dec_module_tb1/j
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5145 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 56
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {5097 ps} {5380 ps}
