#edm -x -m "DEVICE=TPR:SYS2:0" tprMain_final.edl &
#edm -x -m "DEVICE=TPR:SYS2:0" tprPatternDiag.edl &
#edm -x -m "DEVICE=TPR:SYS2:0" tprPatternEvent.edl &
#
edm -eolc -x -m "DEVICE=SIOC:SPS:TS01:0,LOCA=SPS,IOC_UNIT=TS01,INST=0" tprMain_final.edl tprPatternEvent.edl &

