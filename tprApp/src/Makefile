TOP=../..

include $(TOP)/configure/CONFIG

USR_CXXFLAGS += -std=c++0x
USR_CXXFLAGS += -DHAVE_YAML
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#========================================
INCLUDES += -I$(TPG_INCLUDE)
INCLUDES += -I$(BSA_INCLUDE)
INCLUDES += -I$(YAML_INCLUDE)
INCLUDES += -I$(BOOST_INCLUDE)

## this part is just for yaml loader driver
INCLUDES += -I$(CPSW_FRAMEWORK_INCLUDE)


#include files for tprTrigger
INCLUDES += -I$(TPRTRIGGER_INCLUDE)

# include files for tprPattern
INCLUDES += -I$(TPRPATTERN_INCLUDE)



#LIBS     += -L $(TPG_LIB)

# ================================================
# Build the IOC application
# ================================================
# This will attempt to build an IOC application 
# for every target including the host computer.
PROD_IOC = tpr

# Use the following for RTEMS Only IOCs
#PROD_IOC_RTEMS = tpg

# tpg.dbd will be created and installed
DBD += tpr.dbd

# tpg.dbd will be made up from these files:
tpr_DBD += base.dbd
tpr_DBD += devIocStats.dbd
tpr_DBD += asSupport.dbd
tpr_DBD += caPutLog.dbd
tpr_DBD += $(CEXP_DBDS)

# ================================================================================
# The system command will be mainly used by linux hosted IOCs
# Very useful for changing kernel thread priorities for kernel drivers
# ================================================================================
tpr_DBD += system.dbd
tpr_DBD += asyn.dbd
tpr_DBD += yamlLoader.dbd


# DBD files for tprTrigger and tprPattern
tpr_DBD += crossbarControl.dbd
tpr_DBD += ATCACommon.dbd
tpr_DBD += tprTriggerAsynDriver.dbd
tpr_DBD += tprPatternAsynDriver.dbd
tpr_DBD += bsaCore.dbd
tpr_DBD += bsa.dbd

# crossbarControl
tpr_DBD += crossbarControl.dbd

# test code
tpr_DBD += subRec.dbd
tpr_DBD += fiducialTest.dbd

# If you don't have an EVR comment the following two lines:
#tpr_DBD += evrSupport.dbd
#tpr_DBD += devMrfEr.dbd

# ======================================================================
# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
tpr_SRCS += tpr_registerRecordDeviceDriver.cpp
#tpr_SRCS += tpgAsynDriver.cpp
#tpr_SRCS += tpgSequencer.cpp
#tpr_SRCS += tpgBsaEdef.cpp
#tpr_SRCS += tpgRmEdef.cpp
#tpr_SRCS += tpgBsaPoll.cpp
#tpr_SRCS += tpgDiagWf.cpp

# test code
tpr_SRCS += subRec.cpp
tpr_SRCS += fiducialTest.cpp


# ===========================================================
# bsaDriver and yamlLoader have been separated out to epics modules
# after testing these lines should be be revmoved
# ===========================================================
# BSA module will be turned to a separated module.
#tpr_SRCS += bsaAsynDriver.cpp

# YAML loader module will be turned to a separate module.

#tpr_SRCS += yamlLoader.cpp
# ===========================================================

tpr_SRCS_DEFAULT += tprMain.cpp

tpr_SRCS_vxWorks += -nil-

# ========================================================================
# ========================================================================
# Add locally compiled object code
# For example, subroutines
# ========================================================================
# tpr_SRCS += file1.c
# tpr_SRCS += file2.c

# =====================================================
# Link in the code from other libraries
# =====================================================
#
#
#

# Library for tprTrigger and tprPattern

tpr_LIBS += eventBsaSupport
tpr_LIBS += tprTrigger
tpr_LIBS += tprPattern
tpr_LIBS += ATCACommon
tpr_LIBS += BsaCore




tpr_LIBS += yamlLoader
tpr_LIBS += asyn

# Needed to link in iocAdmin support
tpr_LIBS += devIocStats

# Needed to link in autosave support
tpr_LIBS += autosave

# Needed to link caPutLog support
tpr_LIBS += caPutLog

# Needed to link cexpsh() support
tpr_LIBS += $(CEXP_LIBS)


# =====================================================
# Path to "NON EPICS" External PACKAGES: USER INCLUDES
#======================================================
USR_INCLUDES = -I$(BOOST_INCLUDE) -I$(CPSW_FRAMEWORK_INCLUDE) -I$(YAML_INCLUDE) -I$(LLRFAMC_INCLUDE) -I$(YAMLREADER_INCLUDE) -I$(DEVICELIB_INCLUDE)
# =====================================================

#======================================================
# PATH TO "NON EPICS" EXTERNAL PACKAGES: USER LIBRARIES
#======================================================
cpsw_DIR = $(CPSW_FRAMEWORK_LIB)
boost_system_DIR = $(BOOST_LIB)
yaml-cpp_DIR = $(YAML_LIB)
hpstpr_DIR = $(HPSTPR_LIB)
bsa_DIR = $(BSA_LIB)
commonATCA_DIR = $(COMMONATCA_LIB)
#llrfHls_DIR = $(LLRFHLS_LIB)
#commonRF_DIR = $(COMMONRF_LIB)
#llrfAmc_DIR = $(LLRFAMC_LIB)
deviceLib_DIR = $(DEVICELIB_LIB)
yamlReader_DIR  = $(YAMLREADER_LIB)
# =====================================================

# ======================================================
# LINK "NON EPICS" EXTERNAL PACKAGE LIBRARIES STATICALLY
#=======================================================
# USR_LIBS_Linux += cpsw boost_system yaml-cpp hpstpr bsa commonATCA commonRF llrfHls llrfAmc yamlReader deviceLib
USR_LIBS_Linux += cpsw boost_system yaml-cpp hpstpr bsa commonATCA yamlReader deviceLib
# ======================================================



# =============================================
# Begin to link in the EVR support for
# RTEMS, linux, and linuxRT
# If you don't have an EVR, you can comment out 
# the lines below.
# =============================================
# tpr_LIBS += evrSupport
# tpr_LIBS += devMrfEr

ifneq ($(T_A),linuxRT-x86)
  ifneq ($(T_A),linuxRT-x86_64)
   ifneq ($(T_A),linuxRT_glibc-x86_64)
    ifneq ($(T_A),linux-x86)
      ifneq ($(T_A),linux-x86_64)
#       tpr_LIBS += mrfVme64x
      endif
    endif
  endif
 endif
endif

 ifeq ($(T_A),linuxRT-x86)
#  tpr_LIBS += drvMrf
 endif

 ifeq ($(T_A),linuxRT-x86_64)
#  tpr_LIBS += drvMrf
 endif
 
 ifeq ($(T_A),linuxRT_glibc-x86_64)
#  tpr_LIBS += drvMrf
 endif

 ifeq ($(T_A),linux-x86)
#  tpr_LIBS += drvMrf
 endif

 ifeq ($(T_A),linux-x86_64)
#  tpr_LIBS += drvMrf
 endif
# =====================================================
# END EVR libraries
# =====================================================

# NOTE: To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file

#ifneq ($(SNCSEQ),)
#    # This builds sncExample as a component of tpg
#    tpr_SNCFLAGS += +r
#    tpr_DBD += sncExample.dbd
#    tpr_SRCS += sncExample.stt
#    tpr_LIBS += seq pv
#
#    # The following builds sncProgram as a standalone application
#  ifneq ($(T_A),linuxRT-x86)
#    PROD_HOST += sncProgram
#    sncProgram_SNCFLAGS += +m
#    sncProgram_SRCS += sncProgram.st
#    sncProgram_LIBS += seq pv
#    sncProgram_LIBS += $(EPICS_BASE_HOST_LIBS)
#  endif
#endif

tpr_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

