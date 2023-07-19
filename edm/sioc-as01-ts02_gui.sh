#edm -x -m "DEVICE=TPR:SYS2:0" tprMain_final.edl &
#edm -x -m "DEVICE=TPR:SYS2:0" tprPatternDiag.edl &
#edm -x -m "DEVICE=TPR:SYS2:0" tprPatternEvent.edl &
#
edm -eolc -x -m "DEVICE=SIOC:AS01:TS02:0,LOCA=AS01,IOC_UNIT=TS02,INST=0" tprMain_final.edl tprPatternEvent.edl &
edm -eolc -x -m "DEVICE=SIOC:AS01:TS02:1,LOCA=AS01,IOC_UNIT=TS02,INST=1" tprMain_final.edl tprPatternEvent.edl &
#

