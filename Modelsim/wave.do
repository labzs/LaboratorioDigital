onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /jogo_tempo_reacao_tb/clock_in
add wave -noupdate /jogo_tempo_reacao_tb/reset_in
add wave -noupdate /jogo_tempo_reacao_tb/enable_in
add wave -noupdate /jogo_tempo_reacao_tb/sinal_in
add wave -noupdate /jogo_tempo_reacao_tb/pronto
add wave -noupdate /jogo_tempo_reacao_tb/estimulo
add wave -noupdate /jogo_tempo_reacao_tb/ligado
add wave -noupdate /jogo_tempo_reacao_tb/pulso
add wave -noupdate /jogo_tempo_reacao_tb/erro
add wave -noupdate /jogo_tempo_reacao_tb/db_estado
add wave -noupdate /jogo_tempo_reacao_tb/db_tempo_reacao0
add wave -noupdate /jogo_tempo_reacao_tb/db_tempo_reacao1
add wave -noupdate /jogo_tempo_reacao_tb/db_tempo_reacao2
add wave -noupdate /jogo_tempo_reacao_tb/db_tempo_reacao3
add wave -noupdate /jogo_tempo_reacao_tb/db_estado_medidor
add wave -noupdate /jogo_tempo_reacao_tb/caso
add wave -noupdate /jogo_tempo_reacao_tb/keep_simulating
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {100085 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 298
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {100002 ps} {100250 ps}
