#!../../bin/linuxRT-x86_64/tpr

## You may have to change tpg to something else
## everywhere it appears in this file

< envPaths


cd ${TOP}

## Register all support components
dbLoadDatabase("dbd/tpr.dbd")
tpr_registerRecordDeviceDriver(pdbbase)


# ====================================================================
# Setup some additional environment variables
# ====================================================================
# Setup environment variables
epicsEnvSet("ENGINEER","Kukhee Kim")
epicsEnvSet("LOCATION","TID B82")
epicsEnvSet("IOC_PV", "TPR:SYS2:0")
epicsEnvSet("IOC",    "vioc-b84-tpr01")

# tag log messages with IOC name
# How to escape the "ioctpg" as the PERL program
# will try to repplace it.
# So, uncomment the following and remove the backslash
#epicsEnvSet("EPICS\_IOC\_LOG_CLIENT_INET","${IOC}")

# ========================================================
# Support Large Arrays/Waveforms; Number in Bytes
# Please calculate the size of the largest waveform
# that you support in your IOC.  Do not just copy numbers
# from other apps.  This will only lead to an exhaustion
# of resources and problems with your IOC.
# The default maximum size for a channel access array is
# 16K bytes.
# ========================================================
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "2000000")

# END: Additional environment variables
# ====================================================================

########################################################################
# BEGIN: Load the record databases
#######################################################################
# TPR driver DB
 
dbLoadRecords("db/test.db")
dbLoadRecords("db/tprTrg.db",     "DEV=${IOC_PV}, PORT=trig")
dbLoadRecords("db/tprPattern.db", "DEV=${IOC_PV}, PORT=pattern") 

dbLoadRecords("db/subRec.db", "DEVICE=${IOC_PV},NAME=TIME_TEST,TSE=-1,EVNT=9")
dbLoadRecords("db/subRec.db", "DEVICE=$(IOC_PV),NAME=FIDTEST_TS1,TSE=-2,EVNT=FIDTEST_TS1")
dbLoadRecords("db/subRec.db", "DEVICE=$(IOC_PV),NAME=FIDTEST_TS2,TSE=-2,EVNT=FIDTEST_TS2")
dbLoadRecords("db/subRec.db", "DEVICE=$(IOC_PV),NAME=FIDTEST_TS3,TSE=-2,EVNT=FIDTEST_TS3")
dbLoadRecords("db/subRec.db", "DEVICE=$(IOC_PV),NAME=FIDTEST_TS4,TSE=-2,EVNT=FIDTEST_TS4")
dbLoadRecords("db/subRec.db", "DEVICE=$(IOC_PV),NAME=FIDTEST_TS5,TSE=-2,EVNT=FIDTEST_TS5")
dbLoadRecords("db/subRec.db", "DEVICE=$(IOC_PV),NAME=FIDTEST_TS6,TSE=-2,EVNT=FIDTEST_TS6")

dbLoadRecords("db/bsaTest.db")



# =====================================================================
# Load iocAdmin databases to support IOC Health and monitoring
# =====================================================================
dbLoadRecords("db/iocAdminSoft.db","IOC=${IOC_PV}")
dbLoadRecords("db/iocAdminScanMon.db","IOC=${IOC_PV}")

# The following database is a result of a python parser
# which looks at RELEASE_SITE and RELEASE to discover
# versions of software your IOC is referencing
# The python parser is part of iocAdmin
dbLoadRecords("db/iocRelease.db","IOC=${IOC_PV}")

# =====================================================================
# Load database for autosave status
# =====================================================================
dbLoadRecords("db/save_restoreStatus.db", "P=${IOC_PV}:")


# =====================================================================
#Load Additional databases:
# =====================================================================
## Load record instances
#dbLoadRecords("db/dbExample.db","user=khkimHost")

# END: Loading the record databases
########################################################################

# =================================
# Load YAML
# =================================
#cd yamlConfig_0x0000000D-20170322125042
#cd yamlConfig_0x0000000D-20170412114921
#cd yamlConfig_0x0000000E-20170416145959
#cd yamlConfig_0x0000000E-20170420000855
cd yaml
cpswLoadYamlFile("000TopLevel.yaml", "NetIODev", "", "10.0.3.105")

# ===================================
# Load ADC configuration from YAML file
# ====================================
#cd ("${IOC_DATA}/vioc-b84-ev02/yamlConfig")
#cpswLoadConfigFile("configDump.yaml", "mmio/AmcCarrierTimingGenerator/ApplicationCore", "")


cd ${TOP}

# ====================================
# Setup TPG Driver
# ====================================
#tpgAsynDriverConfigure("tpgPort", "192.168.2.10")
#tpgAsynDriverConfigure("tpgPort", "10.0.3.102")
# TPG driver for yaml
#tpgAsynDriverConfigure("tpgPort")
tprTriggerAsynDriverConfigure("trig", "mmio/AmcCarrierEmpty/AmcCarrierCore")
tprPatternAsynDriverConfigure("pattern", "mmio/AmcCarrierEmpty/AmcCarrierCore", "tstream")

# ====================================
# Setup BSA Driver
# ====================================
# add BSA PVs


registerFiducialTestFunction("FIDTEST_TS1",1)
registerFiducialTestFunction("FIDTEST_TS2",2)
registerFiducialTestFunction("FIDTEST_TS3",3)
registerFiducialTestFunction("FIDTEST_TS4",4)
registerFiducialTestFunction("FIDTEST_TS5",5)
registerFiducialTestFunction("FIDTEST_TS6",6)

iocInit()

# =====================================================
# Turn on caPutLogging:
# Log values only on change to the iocLogServer:
caPutLogInit("${EPICS_CA_PUT_LOG_ADDR}")
caPutLogShow(2)
# =====================================================

## Start any sequence programs
#seq sncExample,"user=khkimHost"


epicsThreadSleep(1.)
#registerFiducialTest2Function
#registerEdefTestFunction
#registerBsaCallbackFunction
