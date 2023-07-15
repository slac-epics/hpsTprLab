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
epicsEnvSet("LOCATION","UED AS01")
epicsEnvSet("IOC_PV", "SIOC:AS01:TS02")
epicsEnvSet("TPR_PV", "TPR:AS01:TS02")
epicsEnvSet("IOC",    "sioc-as01-ts02")
epicsEnvSet("HASH",   "pcie-hash-968bb5f")

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
 

dbLoadRecords("db/pcie_tprTrig.db",     "DEV=${IOC_PV}:0,LOCA=AS01,IOC_UNIT=TS02,INST=0,PORT=trig0")
dbLoadRecords("db/pcie_tprTrig.db",     "DEV=${IOC_PV}:1,LOCA=AS01,IOC_UNIT=TS02,INST=1,PORT=trig1")

#dbLoadRecords("db/evTSTest.db", "user=${IOC_PV},N=1000")
#dbLoadRecords("db/evTSTest.db", "user=${IOC_PV},N=1001")
#dbLoadRecords("db/evTSTest.db", "user=${IOC_PV},N=1002")


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
# set up yaml directory and yaml file
epicsEnvSet("YAML_DIR",      "${TOP}/firmware/${HASH}/yaml")
epicsEnvSet("YAML_TOP_FILE", "${YAML_DIR}/000TopLevel.yaml")

# use slot A pcie tpr for root_0, override to use slot_a
cpswLoadYamlFile("${YAML_TOP_FILE}", "MemDev", "", "/dev/tpra", "root_0")

# use slot B pcie tpr for root_1, override to use slot_b
cpswLoadYamlFile("${YAML_TOP_FILE}", "MemDev", "", "/dev/tprb", "root_1")

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


# ====================================
# Setup TPG Driver
# ====================================
tprTriggerAsynDriverConfigure("trig0", "PCIe:/mmio", "root_0")
tprTriggerAsynDriverConfigure("trig1", "PCIe:/mmio", "root_1")



# ====================================
# Setup BSA Driver
# ====================================


# =====================================================================
## Begin: Setup autosave/restore
# =====================================================================

# ============================================================
# If all PVs don't connect continue anyway
# ============================================================
save_restoreSet_IncompleteSetsOk(1)

# ============================================================
# created save/restore backup files with date string
# useful for recovery.
# ============================================================
save_restoreSet_DatedBackupFiles(1)

# ============================================================
# Where to find the list of PVs to save
# ============================================================
#set_requestfile_path("${IOC_DATA}/${IOC}/autosave-req")
set_requestfile_path("${IOC_DATA}/${IOC}", "autosave-req")

# ============================================================
# Where to write the save files that will be used to restore
# ============================================================
#set_savefile_path("${IOC_DATA}/${IOC}/autosave")
set_savefile_path("${IOC_DATA}/${IOC}", "autosave")

# ============================================================
# Prefix that is use to update save/restore status database
# records
# ============================================================
save_restoreSet_status_prefix("${IOC}:")

## Restore datasets
set_pass0_restoreFile("info_positions.sav")
set_pass1_restoreFile("info_positions.sav"
set_pass0_restoreFile("info_settings.sav")
set_pass1_restoreFile("info_settings.sav")

# =====================================================================
# End: Setup autosave/restore
# =====================================================================







iocInit()

# =====================================================
# Turn on caPutLogging:
# Log values only on change to the iocLogServer:
caPutLogInit("${EPICS_CA_PUT_LOG_ADDR}")
caPutLogShow(2)
# =====================================================



## Start autosave process:
cd ("${IOC_DATA}/${IOC}/autosave-req")
makeAutosaveFiles()
create_monitor_set("info_positions.req", 30, "")
create_monitor_set("info_settings.req",30,"")






## Start any sequence programs
#seq sncExample,"user=khkimHost"


epicsThreadSleep(1.)
#registerFiducialTest2Function
#registerEdefTestFunction
#registerBsaCallbackFunction
