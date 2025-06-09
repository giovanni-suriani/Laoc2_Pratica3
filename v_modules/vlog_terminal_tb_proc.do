# Cria um script para compilar e simular o testbench de hierarquia de memória
# Cria a biblioteca de trabalho
vlib work
vlib altera
# Compila a biblioteca altera necessária 
#vlog -work altera /home/gi/altera/13.0sp1/modelsim_ase/altera/verilog/src/altera_mf.v

# Compila os arquivos Verilog necessários, falta memoram.v
vlog processador_multiciclo.v registrador.v registrador_IR.v registrador_SP.v registrador_PC.v mux.v unidade_controle.v contador_3bits.v memoram.v memoram_dados.v tb_processador.v decode3_8bits.v ula.v 
vsim -L altera -voptargs="+acc" work.tb_processador  -c -do "run 10000ps; quit"

# para rodar:  clear;vsim -c -do vlog_terminal_tb_proc.do