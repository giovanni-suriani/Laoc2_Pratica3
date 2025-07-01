# Cria um script para compilar e simular o testbench de hierarquia de memória
# Cria a biblioteca de trabalho
vlib work
#vlib altera
# Compila a biblioteca altera necessária 
#vlog -work altera /home/gi/altera/13.0sp1/modelsim_ase/altera/verilog/src/altera_mf.v
# vlog -work altera /home/giovanni/intelFPGA/20.1/modelsim_ase/altera/verilog/src/altera_mf.v

# Compila os arquivos Verilog necessários
vlog +acc tomasulo.v memoria_instrucoes.v memoria_dados.v fila_de_instrucoes.v CDB_arbiter.v register_status.v unidade_despacho.v res_station_R.v unidade_funcional_R.v seletor_uf.v tb_tomasulo.v 
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
add wave -label "head" /tb_tomasulo/uut/u_fila_de_instrucoes/head
add wave -label "tail" /tb_tomasulo/uut/u_fila_de_instrucoes/tail
add wave -label "Empty" /tb_tomasulo/uut/u_fila_de_instrucoes/Empty
add wave -label "count" /tb_tomasulo/uut/u_fila_de_instrucoes/count
add wave -label "Mem_data" -radix binary  /tb_tomasulo/uut/u_fila_de_instrucoes/Mem_data
add wave -label "PC" /tb_tomasulo/uut/u_fila_de_instrucoes/PC
add wave -label "Mem" -radix binary /tb_tomasulo/uut/u_fila_de_instrucoes/u_memoria_instrucoes/mem

# Sinais da fila de instrucoes
#add wave -label "Full" /tb_tomasulo/uut/Full
#add wave -label "Instrucao_Despachada" -radix binary  tb_tomasulo/uut/u_fila_de_instrucoes/Instrucao_Despachada
#add wave -label "mem" -radix binary /tb_tomasulo/uut/u_fila_de_instrucoes/u_memoria_instrucoes/mem
#add wave -label "Empty" /tb_tomasulo/uut/u_fila_de_instrucoes/Empty
#add wave -label "count" /tb_tomasulo/uut/u_fila_de_instrucoes/count
#add wave -label "preenche" /tb_tomasulo/uut/u_fila_de_instrucoes/preenche
#add wave -label "Address" /tb_tomasulo/uut/u_fila_de_instrucoes/u_memoria_instrucoes/Address
#add wave -label "Q" /tb_tomasulo/uut/u_fila_de_instrucoes/u_memoria_instrucoes/Q


# Executa a simulacao
run 1000ps

# Abre o waveform e ajusta exibição
radix -unsigned
view wave
#WaveRestoreZoom 7000ps 7500ps
WaveRestoreZoom 0ps 500ps
configure wave -timelineunits ps


# para rodar:   killmodelsim;vsim -do vlog_wave_tb_tomasulo.do 
