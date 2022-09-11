TOP=../..

include $(TOP)/configure/CONFIG

USR_CXXFLAGS += -std=c++0x
USR_CXXFLAGS += -DHAVE_YAML
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#========================================
INCLUDES += -I$(YAML_INCLUDE)
INCLUDES += -I$(BOOST_INCLUDE)

## this part is just for yaml loader driver
INCLUDES += -I$(CPSW_FRAMEWORK_INCLUDE)


#include files for tprTrigger
INCLUDES += -I$(TPRTRIGGER_INCLUDE)

# include files for tprPattern
INCLUDES += -I$(TPRPATTERN_INCLUDE)

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
tpr_DBD += tprTriggerAsynDriver.dbd
tpr_DBD += dbSub.dbd

# ======================================================================
# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
tpr_SRCS += tpr_registerRecordDeviceDriver.cpp
tpr_SRCS += dbSub.db

tpr_SRCS_DEFAULT += tprMain.cpp

tpr_SRCS_vxWorks += -nil-

# =====================================================
# Link in the code from other libraries
# =====================================================
#
#
#

# Library for tprTrigger and tprPattern

tpr_LIBS += tprTrigger
tpr_LIBS += ATCACommon
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
USR_INCLUDES = -I$(BOOST_INCLUDE) -I$(CPSW_FRAMEWORK_INCLUDE) -I$(YAML_INCLUDE)
# =====================================================

#======================================================
# PATH TO "NON EPICS" EXTERNAL PACKAGES: USER LIBRARIES
#======================================================
cpsw_DIR = $(CPSW_FRAMEWORK_LIB)
boost_system_DIR = $(BOOST_LIB)
yaml-cpp_DIR = $(YAML_LIB)
hpstpr_DIR = $(HPSTPR_LIB)
commonATCA_DIR = $(COMMONATCA_LIB)

# =====================================================

# ======================================================
# LINK "NON EPICS" EXTERNAL PACKAGE LIBRARIES STATICALLY
#=======================================================
USR_LIBS_Linux += cpsw boost_system yaml-cpp hpstpr commonATCA
# ======================================================


tpr_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

