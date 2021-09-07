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
epicsEnvSet("LOCATION","TID B84")
epicsEnvSet("IOC_PV", "SIOC:B84:TR01")
epicsEnvSet("IOC",    "sioc-b84-tr01")

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
 

dbLoadRecords("db/tprTrig.db",     "DEV=${IOC_PV}:0,LOCA=B84,IOC_UNIT=TR01,INST=0,PORT=trig0")
dbLoadRecords("db/tprTrig.db",     "DEV=${IOC_PV}:1,LOCA=B84,IOC_UNIT=TR01,INST=1,PORT=trig1")


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
#cd yaml
cd EvrCardG2_project_slotA.yaml
cpswLoadYamlFile("000TopLevel.yaml", "MemDev", "", "". "root_0")
cd ${TOP}
cd EvrCardG2_project_slotB.yaml
cpswLoadYamlFile("000TopLevel.yaml", "MemDev", "", "". "root_1")

# ===================================
# Load configuration from YAML file
# ====================================
#cd ("${IOC_DATA}/vioc-b84-ev02/yamlConfig")
#cpswLoadConfigFile("configDump.yaml", "mmio/AmcCarrierTimingGenerator/ApplicationCore", "")


cd ${TOP}

# ====================================
# corssbarControlAsynDriverConfigure
# ====================================
crossbarControlAsynDriverConfigure("crossbar0", "PCIe:/mmio/SfpXbar", "root_0")
crossbarControlAsynDriverConfigure("crossbar1", "PCIe:/mmio/SfpXbar", "root_1")

# Since the crossbar driver has been developed for the ATCA system
# the crossbar options have different meaning on PCIe TPR
# Please, just set up as the followings to make PCIe TPR works

# crossbarControl("BP",      "LCLS1", "root_0")
# crossbarControl("RTM_OUT1", "FPGA", "root_0")

# crossbarControl("BP",      "LCLS1", "root_1")
# crossbarControl("RTM_OUT1", "FPGA", "root_1")


# ====================================
# Setup TPG Driver
# ====================================
tprTriggerAsynDriverConfigure("trig0", "PCIe:/mmio", "root_0")
tprTriggerAsynDriverConfigure("trig1", "PCIe:/mmio", "root_1")


# ====================================
# Setup BSA Driver
# ====================================

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
