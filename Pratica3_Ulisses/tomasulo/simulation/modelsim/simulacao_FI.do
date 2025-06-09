view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 50ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/filaInstrucoes/clock 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/filaInstrucoes/SR_R_cheia 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/filaInstrucoes/SR_I_cheia 
wave modify -driver freeze -pattern clock -initialvalue HiZ -period 200ps -dutycycle 50 -starttime 0ps -endtime 1000ps Edit:/filaInstrucoes/SR_R_cheia 
WaveCollapseAll -1
wave clipboard restore
