# Cria um script para compilar e simular o testbench de hierarquia de memória
# Cria a biblioteca de trabalho
vlib work
#vlib altera
# Compila a biblioteca altera necessária 
#vlog -work altera /home/gi/altera/13.0sp1/modelsim_ase/altera/verilog/src/altera_mf.v
# vlog -work altera /home/giovanni/intelFPGA/20.1/modelsim_ase/altera/verilog/src/altera_mf.v

# Compila os arquivos Verilog necessários
vlog +acc tomasulo.v memoria_instrucoes.v memoria_dados.v fila_de_instrucoes.v CDB_arbiter.v register_status.v unidade_despacho.v res_station_R.v unidade_funcional_R.v tb_tomasulo.v 
vsim -L altera work.tb_tomasulo


# Executa a simulação

# Sinais do ambiente de simulação
#add wave -label "clock" tb_processador/Clock
#add wave -label "Opcode" -radix binary tb_processador/Opcode


# Sinais do uut (unit under test)
add wave -label "Clock" tb_tomasulo/Clock
add wave -label "Reset" tb_tomasulo/Reset
add wave -label "Pop" /tb_tomasulo/uut/Pop
add wave -label "Fila de Instrucoes" -radix binary  tb_tomasulo/uut/u_fila_de_instrucoes/Fila
add wave -label "Instrucao_Despachada" -radix binary /tb_tomasulo/uut/Instrucao_Despachada


#add wave -label "Full" /tb_tomasulo/uut/Full
#add wave -label "Instrucao_Despachada" -radix binary  tb_tomasulo/uut/u_fila_de_instrucoes/Instrucao_Despachada
#add wave -label "mem" -radix binary /tb_tomasulo/uut/u_fila_de_instrucoes/u_memoria_instrucoes/mem
#add wave -label "Mem_data" -radix binary  /tb_tomasulo/uut/u_fila_de_instrucoes/Mem_data
#add wave -label "Empty" /tb_tomasulo/uut/Empty
#add wave -label "head" /tb_tomasulo/uut/head
#add wave -label "tail" /tb_tomasulo/uut/tail
#add wave -label "count" /tb_tomasulo/uut/count
#add wave -label "PC" /tb_tomasulo/uut/PC
#add wave -label "preenche" /tb_tomasulo/uut/preenche
#add wave -label "Address" /tb_tomasulo/uut/u_memoria_instrucoes/Address
#add wave -label "Q" /tb_tomasulo/uut/u_memoria_instrucoes/Q

# Sinais da unidade de despacho
add wave -label "Estacao_Reserva_ADD1_Enable" /tb_tomasulo/uut/u_unidade_despacho/Estacao_Reserva_ADD1_Enable
add wave -label "Estacao_Reserva_ADD2_Enable" /tb_tomasulo/uut/u_unidade_despacho/Estacao_Reserva_ADD2_Enable
add wave -label "Ready_R1" /tb_tomasulo/uut/u_unidade_despacho/Ready_R1
add wave -label "Ready_R2" /tb_tomasulo/uut/u_unidade_despacho/Ready_R2
add wave -label "Rs_Qi" /tb_tomasulo/uut/u_unidade_despacho/Rs_Qi
add wave -label "Rs_Qi_data" /tb_tomasulo/uut/u_unidade_despacho/Rs_Qi_data
add wave -label "Despacho/Vj" /tb_tomasulo/uut/u_unidade_despacho/Vj
add wave -label "Despacho/Vk" /tb_tomasulo/uut/u_unidade_despacho/Vk
add wave -label "Despacho/Qj" /tb_tomasulo/uut/u_unidade_despacho/Qj
add wave -label "Despacho/Qk" /tb_tomasulo/uut/u_unidade_despacho/Qk

# Sinais da unidade de reserva ADD1

add wave -label "ADD1/Busy" /tb_tomasulo/uut/ADD1/Busy
add wave -label "ADD1/Vj" /tb_tomasulo/uut/ADD1/Vj
add wave -label "ADD1/Vk" /tb_tomasulo/uut/ADD1/Vk
add wave -label "ADD1/Qj" /tb_tomasulo/uut/ADD1/Qj
add wave -label "ADD1/Qk" /tb_tomasulo/uut/ADD1/Qk
add wave -label "ADD1/Ready" /tb_tomasulo/uut/ADD1/Ready
add wave -label "ADD1/Result" /tb_tomasulo/uut/ADD1/Result
add wave -label "ADD1/Ufop" -radix binary /tb_tomasulo/uut/ADD1/Ufop
#add wave -label "ADD1/Enable" /tb_tomasulo/uut/ADD1/Estacao_Reserva_ADD1_Enable


# Executa a simulacao
run 1000ps

# Abre o waveform e ajusta exibição
radix -unsigned
view wave
#WaveRestoreZoom 7000ps 7500ps
#WaveRestoreZoom 5000ps 5500ps
configure wave -timelineunits ps


# para rodar:   killmodelsim;vsim -do vlog_wave_tb_tomasulo.do 
