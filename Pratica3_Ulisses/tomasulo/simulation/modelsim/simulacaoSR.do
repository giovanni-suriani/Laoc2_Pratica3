view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 10ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/estacaoReserva/clock 
wave create -driver freeze -pattern constant -value 1000100000000000 -range 15 0 -starttime 0ps -endtime 1000ps sim:/estacaoReserva/instrucao_in 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 00000 -range 15 0 -starttime 0ps -endtime 1000ps sim:/estacaoReserva/Vj_in 
WaveExpandAll -1
wave modify -driver freeze -pattern constant -value 0001000100000000 -range 15 0 -starttime 0ps -endtime 1000ps Edit:/estacaoReserva/instrucao_in 
wave modify -driver freeze -pattern constant -value 0000000000000001 -range 15 0 -starttime 0ps -endtime 1000ps Edit:/estacaoReserva/Vj_in 
wave create -driver freeze -pattern constant -value 1 -range 15 0 -starttime 0ps -endtime 1000ps sim:/estacaoReserva/Vk_in 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/estacaoReserva/UF_R_atoa 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/estacaoReserva/UF_I_atoa 
wave create -driver freeze -pattern constant -value 0 -range 3 0 -starttime 0ps -endtime 1000ps sim:/estacaoReserva/adt_Q_in 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 0 -range 15 0 -starttime 0ps -endtime 1000ps sim:/estacaoReserva/adt_V_in 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/estacaoReserva/nv_adt 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 1000ps sim:/estacaoReserva/nv_inst 
WaveCollapseAll -1
wave clipboard restore
