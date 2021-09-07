#edm -x -m "DEVICE=TPR:SYS2:0" tprMain_final.edl &
#edm -x -m "DEVICE=TPR:SYS2:0" tprPatternDiag.edl &
#edm -x -m "DEVICE=TPR:SYS2:0" tprPatternEvent.edl &
#
edm -eolc -x -m "DEVICE=SIOC:DIAG0:TS01:0,LOCA=DIAG0,IOC_UNIT=TS01,INST=0" tprMain_final.edl tprPatternEvent.edl &

