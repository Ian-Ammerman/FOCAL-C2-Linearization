#ifndef RTW_HEADER_Linear_Decoupled_HD_h_
#define RTW_HEADER_Linear_Decoupled_HD_h_
#ifndef Linear_Decoupled_HD_COMMON_INCLUDES_
#define Linear_Decoupled_HD_COMMON_INCLUDES_
#include <stdlib.h>
#include "sl_AsyncioQueue/AsyncioQueueCAPI.h"
#include "rtwtypes.h"
#include "sigstream_rtw.h"
#include "simtarget/slSimTgtSigstreamRTW.h"
#include "simtarget/slSimTgtSlioCoreRTW.h"
#include "simtarget/slSimTgtSlioClientsRTW.h"
#include "simtarget/slSimTgtSlioSdiRTW.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "raccel.h"
#include "slsv_diagnostic_codegen_c_api.h"
#include "rt_logging_simtarget.h"
#include "dt_info.h"
#include "ext_work.h"
#endif
#include "Linear_Decoupled_HD_types.h"
#include "mwmathutil.h"
#include <stddef.h>
#include "rtw_modelmap_simtarget.h"
#include "rt_defines.h"
#include <string.h>
#include "rtGetInf.h"
#include "rt_nonfinite.h"
#define MODEL_NAME Linear_Decoupled_HD
#define NSAMPLE_TIMES (2) 
#define NINPUTS (0)       
#define NOUTPUTS (0)     
#define NBLOCKIO (11) 
#define NUM_ZC_EVENTS (0) 
#ifndef NCSTATES
#define NCSTATES (333)   
#elif NCSTATES != 333
#error Invalid specification of NCSTATES defined in compiler command
#endif
#ifndef rtmGetDataMapInfo
#define rtmGetDataMapInfo(rtm) (*rt_dataMapInfoPtr)
#endif
#ifndef rtmSetDataMapInfo
#define rtmSetDataMapInfo(rtm, val) (rt_dataMapInfoPtr = &val)
#endif
#ifndef IN_RACCEL_MAIN
#endif
typedef struct { real_T g0vm3uynhb ; real_T gdscea3t3s [ 20 ] ; real_T
ltbm5hkgir [ 20 ] ; real_T cpljaqsgck [ 313 ] ; real_T mtjk1hrcqk [ 313 ] ;
real_T cnutujturz [ 20 ] ; real_T e15osh5iil [ 313 ] ; real_T fql2je0s4g [
235 ] ; real_T gn4npwrlyj [ 20 ] ; real_T jlczdjbm4r [ 313 ] ; real_T
knee2kaf1d [ 20 ] ; } B ; typedef struct { struct { void * TimePtr ; void *
DataPtr ; void * RSimInfoPtr ; } f2zlgn55dr ; struct { void * LoggedData ; }
jf35i0x0s3 ; struct { void * TimePtr ; void * DataPtr ; void * RSimInfoPtr ;
} nb1ss4nxop ; struct { void * AQHandles ; } a2ve2sd04u ; struct { int_T
PrevIndex ; } awuffzesc2 ; struct { int_T PrevIndex ; } cycgrsoo3r ; } DW ;
typedef struct { real_T ad3ik2cpgs [ 20 ] ; real_T bh2njxyf4s [ 313 ] ; } X ;
typedef struct { real_T ad3ik2cpgs [ 20 ] ; real_T bh2njxyf4s [ 313 ] ; }
XDot ; typedef struct { boolean_T ad3ik2cpgs [ 20 ] ; boolean_T bh2njxyf4s [
313 ] ; } XDis ; typedef struct { real_T ad3ik2cpgs [ 20 ] ; real_T
bh2njxyf4s [ 313 ] ; } CStateAbsTol ; typedef struct { real_T ad3ik2cpgs [ 20
] ; real_T bh2njxyf4s [ 313 ] ; } CXPtMin ; typedef struct { real_T
ad3ik2cpgs [ 20 ] ; real_T bh2njxyf4s [ 313 ] ; } CXPtMax ; typedef struct {
rtwCAPI_ModelMappingInfo mmi ; } DataMapInfo ; struct P_ { real_T A_HD [
97969 ] ; real_T A_platform [ 400 ] ; real_T B_HD [ 313 ] ; real_T B_platform
[ 4700 ] ; real_T C_HD [ 1878 ] ; real_T C_platform [ 1200 ] ; real_T
HydroDynStateSpaceInputs_Time0 [ 71712 ] ; real_T
HydroDynStateSpaceInputs_Data0 [ 71712 ] ; real_T FromWorkspace_Time0 ;
real_T FromWorkspace_Data0 [ 20 ] ; real_T Integrator1_IC ; real_T
Integrator_IC ; real_T Constant_Value [ 39 ] ; real_T Constant1_Value [ 190 ]
; } ; extern const char * RT_MEMORY_ALLOCATION_ERROR ; extern B rtB ; extern
X rtX ; extern DW rtDW ; extern P rtP ; extern mxArray *
mr_Linear_Decoupled_HD_GetDWork ( ) ; extern void
mr_Linear_Decoupled_HD_SetDWork ( const mxArray * ssDW ) ; extern mxArray *
mr_Linear_Decoupled_HD_GetSimStateDisallowedBlocks ( ) ; extern const
rtwCAPI_ModelMappingStaticInfo * Linear_Decoupled_HD_GetCAPIStaticMap ( void
) ; extern SimStruct * const rtS ; extern const int_T gblNumToFiles ; extern
const int_T gblNumFrFiles ; extern const int_T gblNumFrWksBlocks ; extern
rtInportTUtable * gblInportTUtables ; extern const char * gblInportFileName ;
extern const int_T gblNumRootInportBlks ; extern const int_T
gblNumModelInputs ; extern const int_T gblInportDataTypeIdx [ ] ; extern
const int_T gblInportDims [ ] ; extern const int_T gblInportComplex [ ] ;
extern const int_T gblInportInterpoFlag [ ] ; extern const int_T
gblInportContinuous [ ] ; extern const int_T gblParameterTuningTid ; extern
DataMapInfo * rt_dataMapInfoPtr ; extern rtwCAPI_ModelMappingInfo *
rt_modelMapInfoPtr ; void MdlOutputs ( int_T tid ) ; void
MdlOutputsParameterSampleTime ( int_T tid ) ; void MdlUpdate ( int_T tid ) ;
void MdlTerminate ( void ) ; void MdlInitializeSizes ( void ) ; void
MdlInitializeSampleTimes ( void ) ; SimStruct * raccel_register_model (
ssExecutionInfo * executionInfo ) ;
#endif
