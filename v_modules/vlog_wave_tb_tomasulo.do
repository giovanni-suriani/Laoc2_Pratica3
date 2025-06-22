# Cria um script para compilar e simular o testbench de hierarquia de memória
# Cria a biblioteca de trabalho
vlib work
#vlib altera
# Compila a biblioteca altera necessária 
#vlog -work altera /home/gi/altera/13.0sp1/modelsim_ase/altera/verilog/src/altera_mf.v
# vlog -work altera /home/giovanni/intelFPGA/20.1/modelsim_ase/altera/verilog/src/altera_mf.v

# Compila os arquivos Verilog necessários
vlog +acc tomasulo.v memoria_instrucoes.v memoria_dados.v fila_de_instrucoes.v CDB_arbiter.v register_status.v unidade_despacho.v res_station_R.v tb_tomasulo.v 
vsim -L altera work.tb_tomasulo


# Executa a simulação

# Sinais do ambiente de simulação
#add wave -label "clock" tb_processador/Clock
#add wave -label "Opcode" -radix binary tb_processador/Opcode


# Sinais do uut (unit under test)
#add wave -label "Clock" tb_fila/Clock
#add wave -label "Pop" /tb_fila/uut/Pop
#add wave -label "Reset" tb_fila/Reset
#add wave -label "Instrucao_Despachada" -radix binary  tb_fila/uut/Instrucao_Despachada
#add wave -label "Fila de Instrucoes" -radix binary  tb_fila/uut/Fila
#add wave -label "mem" -radix binary /tb_fila/uut/u_memoria_instrucoes/mem
#add wave -label "Mem_data" -radix binary  /tb_fila/uut/Mem_data
#add wave -label "Instrucao_Despachada" -radix binary /tb_fila/uut/Instrucao_Despachada
#add wave -label "Full" /tb_fila/uut/Full
#add wave -label "Empty" /tb_fila/uut/Empty
#add wave -label "head" /tb_fila/uut/head
#add wave -label "tail" /tb_fila/uut/tail
#add wave -label "count" /tb_fila/uut/count
#add wave -label "PC" /tb_fila/uut/PC
#add wave -label "preenche" /tb_fila/uut/preenche
#add wave -label "Address" /tb_fila/uut/u_memoria_instrucoes/Address
#add wave -label "Q" /tb_fila/uut/u_memoria_instrucoes/Q


# Executa a simulacao
run 1000ps

# Abre o waveform e ajusta exibição
radix -unsigned
view wave
#WaveRestoreZoom 7000ps 7500ps
#WaveRestoreZoom 5000ps 5500ps
configure wave -timelineunits ps


# para rodar:   killmodelsim;vsim -do vlog_wave_tb_fila.do 
