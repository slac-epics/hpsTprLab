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
epicsEnvSet("LOCATION","SPS")
epicsEnvSet("IOC_PV", "SIOC:SPS:TS01")
epicsEnvSet("IOC",    "sioc-sps-ts01")

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
 

dbLoadRecords("db/tprTrig.db",     "DEV=${IOC_PV}:0,LOCA=DIAG0,IOC_UNIT=TS01,INST=0,PORT=trig0")


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
#cd yaml
cd EvrCardG2_project_slotA.yaml
cpswLoadYamlFile("000TopLevel.yaml", "MemDev", "", "". "root_0")


cd ${TOP}

# ====================================
# corssbarControlAsynDriverConfigure
# ====================================
crossbarControlAsynDriverConfigure("crossbar0", "PCIe:/mmio/SfpXbar", "root_0")


# ====================================
# Setup TPG Driver
# ====================================
tprTriggerAsynDriverConfigure("trig0", "PCIe:/mmio", "root_0")


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

