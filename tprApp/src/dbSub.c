#include <stdio.h>
#include <stdlib.h>

#include <dbDefs.h>
#include <registryFunction.h>
#include <subRecord.h>
#include <aSubRecord.h>
#include <epicsExport.h>
#include <epicsMutex.h>
#include <timingFifoApi.h>

typedef struct {
    uint64_t        index;
    EventTimingData data;
    int             cnt;
} myData_t;

static long myInit(subRecord *prec)
{
    myData_t *p = malloc(sizeof(myData_t));
    p->cnt      = 0;
    prec->dpvt  = (void*) p;

    return 0;
}

static long mySub(subRecord *prec)
{

   myData_t *p = (myData_t *) prec->dpvt;
   int      ev = (int) prec->a;
   int    incr = (int) prec->b;

    if(!p->cnt)   timingFifoRead(ev, TS_INDEX_INIT, &p->index, &p->data); // intial try
    else          timingFifoRead(ev, incr,          &p->index, &p->data); // incr is decided by INPB

    p->cnt++;

    prec->time = p->data.fifo_time;
    prec->val  = (double) p->data.fifo_fid;


    return 0;
}



typedef struct {
    EventTimingData  data;
    unsigned         dp[64];
} myData2_t;


static long myInit2(subRecord *prec)
{
    myData2_t * p = malloc(sizeof(myData2_t));
    prec->dpvt    = (void *) p;

    return 0;
}


static long mySub2(subRecord *prec)
{
    myData2_t *p = (myData2_t *) prec->dpvt;
    int       ev = (int) prec->a;

    timingEntryRead(ev, (void *) &p->dp[0], &p->data);

  
    prec->time  = p->data.fifo_time;
    prec->val   = p->dp[0];
}



static long _mySub(subRecord *prec)
{
     
   myData_t *p = (myData_t *) prec->dpvt;
   int      ev = (int) prec->a;

    if(!p->cnt)                timingFifoRead(ev, TS_INDEX_INIT, &p->index, &p->data); // intial try
    else if(p->cnt<= ev%1000)  timingFifoRead(ev, 0,             &p->index, &p->data); // make delay, stay at the same index 
    else                       timingFifoRead(ev, 1,             &p->index, &p->data); // evolve

    p->cnt++;
    
    prec->time = p->data.fifo_time;
    prec->val  = (double) p->data.fifo_fid;

    
    return 0;
}


typedef struct {
    epicsMutexId lock;
    int          count;
} cbData_t;

static void _callback(void *pvt)
{
    if(!pvt) return;

    cbData_t *p = (cbData_t *) pvt;

    epicsMutexLock(p->lock);
    p->count++;
    epicsMutexUnlock(p->lock);
}

static long myCbSubInit(subRecord *prec)
{
    cbData_t *p = malloc(sizeof(cbData_t));
    p->lock     = epicsMutexCreate();
    p->count    = 0;

    prec->dpvt  = (void *) p;

    return RegisterTimingEventCallback((TimingEventCallback) _callback, (void *) p);

}

static long myCbSub(subRecord *prec)
{
    if(!prec->dpvt) {
        prec->val = -1.;
        return 0;
    }

    cbData_t *p = (cbData_t *) prec->dpvt;
    epicsMutexLock(p->lock);
    int count = p->count;
    p->count = 0;
    epicsMutexUnlock(p->lock);
    
    prec->val = (double) count;

    return 0;
}

epicsRegisterFunction(myInit);
epicsRegisterFunction(mySub);
epicsRegisterFunction(myInit2);
epicsRegisterFunction(mySub2);
epicsRegisterFunction(myCbSubInit);
epicsRegisterFunction(myCbSub);
