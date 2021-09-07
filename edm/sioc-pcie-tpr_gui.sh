#edm -x -m "DEVICE=TPR:SYS2:0" tprMain_final.edl &
#edm -x -m "DEVICE=TPR:SYS2:0" tprPatternDiag.edl &
#edm -x -m "DEVICE=TPR:SYS2:0" tprPatternEvent.edl &
#
edm -eolc -x -m "DEVICE=SIOC:B84:TR01:0,LOCA=B84,IOC_UNIT=TR01,INST=0" tprMain_final.edl tprPatternEvent.edl &
#edm -eolc -x -m "DEVICE=SIOC:B84:TR01:1,LOCA=B84,IOC_UNIT=TR01,INST=1" tprMain_final.edl tprPatternEvent.edl &
#

