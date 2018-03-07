#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <math.h>
#include <time.h>

#include <sys/types.h>
#include <sys/stat.h>

#include <dbScan.h>
#include <ellLib.h>
#include <epicsTypes.h>
#include <epicsTime.h>
#include <epicsThread.h>
#include <epicsString.h>
#include <epicsTimer.h>
#include <epicsMutex.h>
#include <epicsEvent.h>
#include <epicsGeneralTime.h>
#include <generalTimeSup.h>



#include <iocsh.h>

#include <drvSup.h>
#include <epicsExport.h>

#include <asynPortDriver.h>
#include <asynOctetSyncIO.h>



#include <bsaCallbackApi.h>
#include <evrTime.h>



extern "C" {



void fid_test2(void * arg)
{
   epicsTimeStamp ts[5];
   evrModifier_ta   mod_a;
   epicsUInt32 patternStatus;
   epicsUInt32 edefAvgDone;
   epicsUInt32 edefMinor;
   epicsUInt32 edefMajor;
   int i;
   
   for(i =0; i <=4; i++) evrTimeGetFromPipeline(ts+i, (evrTimeId_te) i, mod_a, &patternStatus, &edefAvgDone, &edefMinor, &edefMajor);  

   for(i =0; i <=4; i++) printf("%d: %d, ", i, PULSEID(ts[i]));
   printf("\n");   

    return;    
}


void fid_edef_test(void *arg)
{
   epicsTimeStamp active_ts, ts, edef_ts, init_ts;
   evrModifier_ta   mod_a;
   epicsUInt32 patternStatus;
   epicsUInt32 edefAvgDone;
   epicsUInt32 edefMinor;
   epicsUInt32 edefMajor;
   int edef_avg_done;
   epicsEnum16 edef_sevr;
   
   evrTimeGet(&active_ts, 0);
   evrTimeGetFromPipeline(&ts, (evrTimeId_te) 0, mod_a, &patternStatus, &edefAvgDone, &edefMinor, &edefMajor); 
   evrTimeGetFromEdef(3, &edef_ts, &init_ts, &edef_avg_done, &edef_sevr);
   
   printf(" active %d: curr %d: avg done %d: init %d\n",PULSEID(active_ts), PULSEID(ts), PULSEID(edef_ts), PULSEID(init_ts));
   
    
}

void bsa_cb(void *pvt, const BsaTimingData *bsa)
{
    BsaTimingData bsa_data;
    
    bsa_data = *bsa;
    
    printf("pid %u, init %8x, active %8x, avg %8x, all %8x, update %8x, major %8x, minor %8x\n",
           (unsigned) bsa_data.pulseId,
           (unsigned) bsa_data.edefInitMask,
           (unsigned) bsa_data.edefActiveMask,
           (unsigned) bsa_data.edefAvgDoneMask,
           (unsigned) bsa_data.edefAllDoneMask,
           (unsigned) bsa_data.edefUpdateMask,
           (unsigned) bsa_data.edefMajorMask,
           (unsigned) bsa_data.edefMinorMask);
}

static void registerBsaCallback(void)
{
    RegisterBsaTimingCallback(bsa_cb, (void*) NULL);
}

static const iocshFuncDef bsaCallbackDef = {"registerBsaCallbackFunction", 0, NULL};
static void bsaCallbackFunc(const iocshArgBuf *args)
{
    registerBsaCallback();
}

static void registerFiducial2(void)
{
    evrTimeRegister(fid_test2, NULL);
}

static const iocshFuncDef fidFuncDef2 = {"registerFiducialTest2Function", 0, NULL };
static void  fidCallFunc2(const iocshArgBuf *args)
{
    registerFiducial2();
}

static void registerEdefTest(void)
{
    evrTimeRegister(fid_edef_test, NULL);
}

static const iocshFuncDef edefTestDef = {"registerEdefTestFunction", 0, NULL};
static void edefTestFunc(const iocshArgBuf *args)
{
    registerEdefTest();
}

 
void registerFiducialTestFunctionRegister(void)
{

    iocshRegister(&fidFuncDef2, fidCallFunc2);
    iocshRegister(&edefTestDef, edefTestFunc);
    iocshRegister(&bsaCallbackDef, bsaCallbackFunc);
}

epicsExportRegistrar(registerFiducialTestFunctionRegister);
} /* extern C */