#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <math.h>
#include <time.h>

#include <sys/types.h>
#include <sys/stat.h>


#include <stdio.h>
#include <string.h>
#include <subRecord.h>
#include <epicsTime.h>
#include <epicsTypes.h>
#include <registryFunction.h>
#include <epicsExport.h>


#include <asynPortDriver.h>
#include <asynOctetSyncIO.h>





#include <evrTime.h>

/* Masks used to decode pulse ID from the nsec part of the timestamp   */
#define UPPER_15_BIT_MASK       (0xFFFE0000)    /* (2^32)-1 - (2^17)-1 */
#define LOWER_17_BIT_MASK       (0x0001FFFF)    /* (2^17)-1            */
/* Pulse ID Definitions */
#define PULSEID(time)           ((time).nsec & LOWER_17_BIT_MASK)

extern "C" {
static long sub_pulseID(subRecord *psub)
{

    
    
    evrTimeGet(&psub->time, 1);
    
    psub->val = (double) PULSEID(psub->time);
    
    
    
    return 0;
}

epicsRegisterFunction(sub_pulseID);
} /* extern C */
