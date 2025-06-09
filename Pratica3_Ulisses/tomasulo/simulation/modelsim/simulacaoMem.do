view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 10ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/memoria/clock 
wave create -driver freeze -pattern counter -startvalue 00000000 -endvalue 1111 -type Range -direction Up -period 50ps -step 1 -repeat forever -range 7 0 -starttime 0ps -endtime 1000ps sim:/memoria/A 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 111 -range 15 0 -starttime 0ps -endtime 1000ps sim:/memoria/data 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/memoria/W 
wave create -driver freeze -pattern constant -value 100 -range 2 0 -starttime 0ps -endtime 1000ps sim:/memoria/dest_in 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 1000 -range 3 0 -starttime 0ps -endtime 1000ps sim:/memoria/Qi_in 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 100ps sim:/memoria/nova 
wave modify -driver freeze -pattern constant -value 1 -starttime 100ps -endtime 200ps Edit:/memoria/nova 
wave modify -driver freeze -pattern constant -value 0 -starttime 200ps -endtime 1000ps Edit:/memoria/nova 
WaveCollapseAll -1
wave clipboard restore
