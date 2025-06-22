# Cria um script para compilar e simular o testbench de hierarquia de memória
# Cria a biblioteca de trabalho
vlib work
#vlib altera
# Compila a biblioteca altera necessária 
#vlog -work altera /home/gi/altera/13.0sp1/modelsim_ase/altera/verilog/src/altera_mf.v
# vlog -work altera /home/giovanni/intelFPGA/20.1/modelsim_ase/altera/verilog/src/altera_mf.v

# Compila os arquivos Verilog necessários
vlog +acc tomasulo.v memoria_instrucoes.v memoria_dados.v fila_de_instrucoes.v CDB_arbiter.v register_status.v unidade_despacho.v res_station_R.v tb_tomasulo.v 
#vsim -L altera work.tb_tomasulo

vsim -L altera -voptargs="+acc" work.tb_tomasulo  -c -do "run 10000ps; quit"

# para rodar:  clear;vsim -c -do vlog_terminal_tb_tomasulo.do