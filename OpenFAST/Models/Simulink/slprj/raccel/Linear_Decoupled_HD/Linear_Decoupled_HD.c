#include "Linear_Decoupled_HD.h"
#include "rtwtypes.h"
#include <emmintrin.h>
#include "blas.h"
#include <string.h>
#include "Linear_Decoupled_HD_private.h"
#include "rt_logging_mmi.h"
#include "Linear_Decoupled_HD_capi.h"
#include "Linear_Decoupled_HD_dt.h"
extern void * CreateDiagnosticAsVoidPtr_wrapper ( const char * id , int nargs
, ... ) ; RTWExtModeInfo * gblRTWExtModeInfo = NULL ; void
raccelForceExtModeShutdown ( boolean_T extModeStartPktReceived ) { if ( !
extModeStartPktReceived ) { boolean_T stopRequested = false ;
rtExtModeWaitForStartPkt ( gblRTWExtModeInfo , 1 , & stopRequested ) ; }
rtExtModeShutdown ( 1 ) ; }
#include "slsv_diagnostic_codegen_c_api.h"
#include "slsa_sim_engine.h"
const int_T gblNumToFiles = 0 ; const int_T gblNumFrFiles = 0 ; const int_T
gblNumFrWksBlocks = 2 ;
#ifdef RSIM_WITH_SOLVER_MULTITASKING
boolean_T gbl_raccel_isMultitasking = 1 ;
#else
boolean_T gbl_raccel_isMultitasking = 0 ;
#endif
boolean_T gbl_raccel_tid01eq = 0 ; int_T gbl_raccel_NumST = 2 ; const char_T
* gbl_raccel_Version = "10.5 (R2022a) 13-Nov-2021" ; void
raccel_setup_MMIStateLog ( SimStruct * S ) {
#ifdef UseMMIDataLogging
rt_FillStateSigInfoFromMMI ( ssGetRTWLogInfo ( S ) , & ssGetErrorStatus ( S )
) ;
#else
UNUSED_PARAMETER ( S ) ;
#endif
} static DataMapInfo rt_dataMapInfo ; DataMapInfo * rt_dataMapInfoPtr = &
rt_dataMapInfo ; rtwCAPI_ModelMappingInfo * rt_modelMapInfoPtr = & (
rt_dataMapInfo . mmi ) ; const int_T gblNumRootInportBlks = 0 ; const int_T
gblNumModelInputs = 0 ; extern const char * gblInportFileName ; extern
rtInportTUtable * gblInportTUtables ; const int_T gblInportDataTypeIdx [ ] =
{ - 1 } ; const int_T gblInportDims [ ] = { - 1 } ; const int_T
gblInportComplex [ ] = { - 1 } ; const int_T gblInportInterpoFlag [ ] = { - 1
} ; const int_T gblInportContinuous [ ] = { - 1 } ; int_T enableFcnCallFlag [
] = { 1 , 1 } ; const char * raccelLoadInputsAndAperiodicHitTimes ( SimStruct
* S , const char * inportFileName , int * matFileFormat ) { return
rt_RAccelReadInportsMatFile ( S , inportFileName , matFileFormat ) ; }
#include "simstruc.h"
#include "fixedpoint.h"
#include "slsa_sim_engine.h"
#include "simtarget/slSimTgtSLExecSimBridge.h"
B rtB ; X rtX ; DW rtDW ; static SimStruct model_S ; SimStruct * const rtS =
& model_S ; void MdlInitialize ( void ) { int32_T i ; for ( i = 0 ; i < 20 ;
i ++ ) { rtX . ad3ik2cpgs [ i ] = rtP . Integrator1_IC ; } for ( i = 0 ; i <
313 ; i ++ ) { rtX . bh2njxyf4s [ i ] = rtP . Integrator_IC ; } } void
MdlStart ( void ) { { bool externalInputIsInDatasetFormat = false ; void *
pISigstreamManager = rt_GetISigstreamManager ( rtS ) ;
rtwISigstreamManagerGetInputIsInDatasetFormat ( pISigstreamManager , &
externalInputIsInDatasetFormat ) ; if ( externalInputIsInDatasetFormat ) { }
} { { { bool isStreamoutAlreadyRegistered = false ; { sdiSignalSourceInfoU
srcInfo ; sdiLabelU loggedName = sdiGetLabelFromChars ( "C_platform" ) ;
sdiLabelU origSigName = sdiGetLabelFromChars ( "" ) ; sdiLabelU propName =
sdiGetLabelFromChars ( "C_platform" ) ; sdiLabelU blockPath =
sdiGetLabelFromChars ( "Linear_Decoupled_HD/Final Output" ) ; sdiLabelU
blockSID = sdiGetLabelFromChars ( "" ) ; sdiLabelU subPath =
sdiGetLabelFromChars ( "" ) ; sdiDims sigDims ; sdiLabelU sigName =
sdiGetLabelFromChars ( "C_platform" ) ; sdiAsyncRepoDataTypeHandle hDT =
sdiAsyncRepoGetBuiltInDataTypeHandle ( DATA_TYPE_DOUBLE ) ; { sdiComplexity
sigComplexity = REAL ; sdiSampleTimeContinuity stCont =
SAMPLE_TIME_CONTINUOUS ; int_T sigDimsArray [ 1 ] = { 60 } ; sigDims . nDims
= 1 ; sigDims . dimensions = sigDimsArray ; srcInfo . numBlockPathElems = 1 ;
srcInfo . fullBlockPath = ( sdiFullBlkPathU ) & blockPath ; srcInfo . SID = (
sdiSignalIDU ) & blockSID ; srcInfo . subPath = subPath ; srcInfo . portIndex
= 0 + 1 ; srcInfo . signalName = sigName ; srcInfo . sigSourceUUID = 0 ; rtDW
. a2ve2sd04u . AQHandles = sdiStartAsyncioQueueCreation ( hDT , & srcInfo ,
rt_dataMapInfo . mmi . InstanceMap . fullPath ,
"3a9fc9ee-9a0d-4537-83ee-7ba1b7ac053c" , sigComplexity , & sigDims ,
DIMENSIONS_MODE_FIXED , stCont , "" ) ; sdiCompleteAsyncioQueueCreation (
rtDW . a2ve2sd04u . AQHandles , hDT , & srcInfo ) ; if ( rtDW . a2ve2sd04u .
AQHandles ) { sdiSetSignalSampleTimeString ( rtDW . a2ve2sd04u . AQHandles ,
"Continuous" , 0.0 , ssGetTFinal ( rtS ) ) ; sdiSetSignalRefRate ( rtDW .
a2ve2sd04u . AQHandles , 0.0 ) ; sdiSetRunStartTime ( rtDW . a2ve2sd04u .
AQHandles , ssGetTaskTime ( rtS , 0 ) ) ; sdiAsyncRepoSetSignalExportSettings
( rtDW . a2ve2sd04u . AQHandles , 1 , 0 ) ; sdiAsyncRepoSetSignalExportName (
rtDW . a2ve2sd04u . AQHandles , loggedName , origSigName , propName ) ;
sdiAsyncRepoSetBlockPathDomain ( rtDW . a2ve2sd04u . AQHandles ) ; }
sdiFreeLabel ( sigName ) ; sdiFreeLabel ( loggedName ) ; sdiFreeLabel (
origSigName ) ; sdiFreeLabel ( propName ) ; sdiFreeLabel ( blockPath ) ;
sdiFreeLabel ( blockSID ) ; sdiFreeLabel ( subPath ) ; } } if ( !
isStreamoutAlreadyRegistered ) { { sdiLabelU varName = sdiGetLabelFromChars (
"platform_out" ) ; sdiRegisterWksVariable ( rtDW . a2ve2sd04u . AQHandles ,
varName , "timeseries" ) ; sdiFreeLabel ( varName ) ; } } } } } { FWksInfo *
fromwksInfo ; if ( ( fromwksInfo = ( FWksInfo * ) calloc ( 1 , sizeof (
FWksInfo ) ) ) == ( NULL ) ) { ssSetErrorStatus ( rtS ,
"from workspace STRING(Name) memory allocation error" ) ; } else {
fromwksInfo -> origWorkspaceVarName = "HD_input" ; fromwksInfo ->
origDataTypeId = 0 ; fromwksInfo -> origIsComplex = 0 ; fromwksInfo ->
origWidth = 1 ; fromwksInfo -> origElSize = sizeof ( real_T ) ; fromwksInfo
-> data = ( void * ) rtP . HydroDynStateSpaceInputs_Data0 ; fromwksInfo ->
nDataPoints = 71712 ; fromwksInfo -> time = ( double * ) rtP .
HydroDynStateSpaceInputs_Time0 ; rtDW . f2zlgn55dr . TimePtr = fromwksInfo ->
time ; rtDW . f2zlgn55dr . DataPtr = fromwksInfo -> data ; rtDW . f2zlgn55dr
. RSimInfoPtr = fromwksInfo ; } rtDW . awuffzesc2 . PrevIndex = 0 ; } {
FWksInfo * fromwksInfo ; if ( ( fromwksInfo = ( FWksInfo * ) calloc ( 1 ,
sizeof ( FWksInfo ) ) ) == ( NULL ) ) { ssSetErrorStatus ( rtS ,
"from workspace STRING(Name) memory allocation error" ) ; } else {
fromwksInfo -> origWorkspaceVarName = "IC" ; fromwksInfo -> origDataTypeId =
0 ; fromwksInfo -> origIsComplex = 0 ; fromwksInfo -> origWidth = 20 ;
fromwksInfo -> origElSize = sizeof ( real_T ) ; fromwksInfo -> data = ( void
* ) rtP . FromWorkspace_Data0 ; fromwksInfo -> nDataPoints = 1 ; fromwksInfo
-> time = ( double * ) & rtP . FromWorkspace_Time0 ; rtDW . nb1ss4nxop .
TimePtr = fromwksInfo -> time ; rtDW . nb1ss4nxop . DataPtr = fromwksInfo ->
data ; rtDW . nb1ss4nxop . RSimInfoPtr = fromwksInfo ; } rtDW . cycgrsoo3r .
PrevIndex = 0 ; } MdlInitialize ( ) ; } void MdlOutputs ( int_T tid ) {
real_T ijhp2wqgry [ 20 ] ; __m128d tmp ; __m128d tmp_p ; ptrdiff_t INCX ;
ptrdiff_t INCY ; ptrdiff_t LDA ; ptrdiff_t M ; ptrdiff_t N ; real_T
lkryf4aolw [ 60 ] ; real_T ALPHA ; real_T BETA ; int32_T i ; int32_T i_p ;
char_T TRANS ; { real_T * pDataValues = ( real_T * ) rtDW . f2zlgn55dr .
DataPtr ; real_T * pTimeValues = ( real_T * ) rtDW . f2zlgn55dr . TimePtr ;
int_T currTimeIndex = rtDW . awuffzesc2 . PrevIndex ; real_T t =
ssGetTaskTime ( rtS , 0 ) ; int numPoints , lastPoint ; FWksInfo *
fromwksInfo = ( FWksInfo * ) rtDW . f2zlgn55dr . RSimInfoPtr ; numPoints =
fromwksInfo -> nDataPoints ; lastPoint = numPoints - 1 ; if ( t <=
pTimeValues [ 0 ] ) { currTimeIndex = 0 ; } else if ( t >= pTimeValues [
lastPoint ] ) { currTimeIndex = lastPoint - 1 ; } else { if ( t < pTimeValues
[ currTimeIndex ] ) { while ( t < pTimeValues [ currTimeIndex ] ) {
currTimeIndex -- ; } } else { while ( t >= pTimeValues [ currTimeIndex + 1 ]
) { currTimeIndex ++ ; } } } rtDW . awuffzesc2 . PrevIndex = currTimeIndex ;
{ real_T t1 = pTimeValues [ currTimeIndex ] ; real_T t2 = pTimeValues [
currTimeIndex + 1 ] ; if ( t1 == t2 ) { if ( t < t1 ) { rtB . g0vm3uynhb =
pDataValues [ currTimeIndex ] ; } else { rtB . g0vm3uynhb = pDataValues [
currTimeIndex + 1 ] ; } } else { real_T f1 = ( t2 - t ) / ( t2 - t1 ) ;
real_T f2 = 1.0 - f1 ; real_T d1 ; real_T d2 ; int_T TimeIndex =
currTimeIndex ; d1 = pDataValues [ TimeIndex ] ; d2 = pDataValues [ TimeIndex
+ 1 ] ; rtB . g0vm3uynhb = ( real_T ) rtInterpolate ( d1 , d2 , f1 , f2 ) ;
pDataValues += numPoints ; } } } { real_T * pDataValues = ( real_T * ) rtDW .
nb1ss4nxop . DataPtr ; { int_T elIdx ; for ( elIdx = 0 ; elIdx < 20 ; ++
elIdx ) { ( & ijhp2wqgry [ 0 ] ) [ elIdx ] = pDataValues [ 0 ] ; pDataValues
+= 1 ; } } } for ( i = 0 ; i <= 18 ; i += 2 ) { tmp = _mm_loadu_pd ( & rtX .
ad3ik2cpgs [ i ] ) ; _mm_storeu_pd ( & rtB . gdscea3t3s [ i ] , tmp ) ; tmp =
_mm_loadu_pd ( & ijhp2wqgry [ i ] ) ; tmp_p = _mm_loadu_pd ( & rtB .
gdscea3t3s [ i ] ) ; _mm_storeu_pd ( & rtB . ltbm5hkgir [ i ] , _mm_add_pd (
tmp , tmp_p ) ) ; } TRANS = 'N' ; M = 60LL ; N = 20LL ; ALPHA = 1.0 ; LDA =
60LL ; INCX = 1LL ; BETA = 0.0 ; INCY = 1LL ; dgemv ( & TRANS , & M , & N , &
ALPHA , & rtP . C_platform [ 0 ] , & LDA , & rtB . ltbm5hkgir [ 0 ] , & INCX
, & BETA , & lkryf4aolw [ 0 ] , & INCY ) ; { if ( rtDW . a2ve2sd04u .
AQHandles && ssGetLogOutput ( rtS ) ) { sdiWriteSignal ( rtDW . a2ve2sd04u .
AQHandles , ssGetTaskTime ( rtS , 0 ) , ( char * ) & lkryf4aolw [ 0 ] + 0 ) ;
} } memcpy ( & rtB . cpljaqsgck [ 0 ] , & rtX . bh2njxyf4s [ 0 ] , 313U *
sizeof ( real_T ) ) ; TRANS = 'N' ; M = 313LL ; N = 313LL ; ALPHA = 1.0 ; LDA
= 313LL ; INCX = 1LL ; BETA = 0.0 ; INCY = 1LL ; dgemv ( & TRANS , & M , & N
, & ALPHA , & rtP . A_HD [ 0 ] , & LDA , & rtB . cpljaqsgck [ 0 ] , & INCX ,
& BETA , & rtB . mtjk1hrcqk [ 0 ] , & INCY ) ; for ( i = 0 ; i < 20 ; i ++ )
{ rtB . cnutujturz [ i ] = 0.0 ; for ( i_p = 0 ; i_p < 20 ; i_p ++ ) { rtB .
cnutujturz [ i ] += rtP . A_platform [ 20 * i_p + i ] * rtB . ltbm5hkgir [
i_p ] ; } } for ( i = 0 ; i <= 310 ; i += 2 ) { _mm_storeu_pd ( & rtB .
e15osh5iil [ i ] , _mm_mul_pd ( _mm_loadu_pd ( & rtP . B_HD [ i ] ) ,
_mm_set1_pd ( rtB . g0vm3uynhb ) ) ) ; } for ( i = 312 ; i < 313 ; i ++ ) {
rtB . e15osh5iil [ i ] = rtP . B_HD [ i ] * rtB . g0vm3uynhb ; } memcpy ( &
rtB . fql2je0s4g [ 0 ] , & rtP . Constant_Value [ 0 ] , 39U * sizeof ( real_T
) ) ; TRANS = 'N' ; M = 6LL ; N = 313LL ; ALPHA = 1.0 ; LDA = 6LL ; INCX =
1LL ; BETA = 0.0 ; INCY = 1LL ; dgemv ( & TRANS , & M , & N , & ALPHA , & rtP
. C_HD [ 0 ] , & LDA , & rtB . cpljaqsgck [ 0 ] , & INCX , & BETA , & rtB .
fql2je0s4g [ 39 ] , & INCY ) ; memcpy ( & rtB . fql2je0s4g [ 45 ] , & rtP .
Constant1_Value [ 0 ] , 190U * sizeof ( real_T ) ) ; TRANS = 'N' ; M = 20LL ;
N = 235LL ; ALPHA = 1.0 ; LDA = 20LL ; INCX = 1LL ; BETA = 0.0 ; INCY = 1LL ;
dgemv ( & TRANS , & M , & N , & ALPHA , & rtP . B_platform [ 0 ] , & LDA , &
rtB . fql2je0s4g [ 0 ] , & INCX , & BETA , & rtB . gn4npwrlyj [ 0 ] , & INCY
) ; for ( i = 0 ; i <= 310 ; i += 2 ) { tmp = _mm_loadu_pd ( & rtB .
e15osh5iil [ i ] ) ; tmp_p = _mm_loadu_pd ( & rtB . mtjk1hrcqk [ i ] ) ;
_mm_storeu_pd ( & rtB . jlczdjbm4r [ i ] , _mm_add_pd ( tmp , tmp_p ) ) ; }
for ( i = 312 ; i < 313 ; i ++ ) { rtB . jlczdjbm4r [ i ] = rtB . e15osh5iil
[ i ] + rtB . mtjk1hrcqk [ i ] ; } for ( i = 0 ; i <= 18 ; i += 2 ) { tmp =
_mm_loadu_pd ( & rtB . gn4npwrlyj [ i ] ) ; tmp_p = _mm_loadu_pd ( & rtB .
cnutujturz [ i ] ) ; _mm_storeu_pd ( & rtB . knee2kaf1d [ i ] , _mm_add_pd (
tmp , tmp_p ) ) ; } UNUSED_PARAMETER ( tid ) ; } void MdlOutputsTID1 ( int_T
tid ) { UNUSED_PARAMETER ( tid ) ; } void MdlUpdate ( int_T tid ) {
UNUSED_PARAMETER ( tid ) ; } void MdlUpdateTID1 ( int_T tid ) {
UNUSED_PARAMETER ( tid ) ; } void MdlDerivatives ( void ) { XDot * _rtXdot ;
_rtXdot = ( ( XDot * ) ssGetdX ( rtS ) ) ; memcpy ( & _rtXdot -> ad3ik2cpgs [
0 ] , & rtB . knee2kaf1d [ 0 ] , 20U * sizeof ( real_T ) ) ; memcpy ( &
_rtXdot -> bh2njxyf4s [ 0 ] , & rtB . jlczdjbm4r [ 0 ] , 313U * sizeof (
real_T ) ) ; } void MdlProjection ( void ) { } void MdlTerminate ( void ) {
rt_FREE ( rtDW . f2zlgn55dr . RSimInfoPtr ) ; rt_FREE ( rtDW . nb1ss4nxop .
RSimInfoPtr ) ; { if ( rtDW . a2ve2sd04u . AQHandles ) {
sdiTerminateStreaming ( & rtDW . a2ve2sd04u . AQHandles ) ; } } } static void
mr_Linear_Decoupled_HD_cacheDataAsMxArray ( mxArray * destArray , mwIndex i ,
int j , const void * srcData , size_t numBytes ) ; static void
mr_Linear_Decoupled_HD_cacheDataAsMxArray ( mxArray * destArray , mwIndex i ,
int j , const void * srcData , size_t numBytes ) { mxArray * newArray =
mxCreateUninitNumericMatrix ( ( size_t ) 1 , numBytes , mxUINT8_CLASS ,
mxREAL ) ; memcpy ( ( uint8_T * ) mxGetData ( newArray ) , ( const uint8_T *
) srcData , numBytes ) ; mxSetFieldByNumber ( destArray , i , j , newArray )
; } static void mr_Linear_Decoupled_HD_restoreDataFromMxArray ( void *
destData , const mxArray * srcArray , mwIndex i , int j , size_t numBytes ) ;
static void mr_Linear_Decoupled_HD_restoreDataFromMxArray ( void * destData ,
const mxArray * srcArray , mwIndex i , int j , size_t numBytes ) { memcpy ( (
uint8_T * ) destData , ( const uint8_T * ) mxGetData ( mxGetFieldByNumber (
srcArray , i , j ) ) , numBytes ) ; } static void
mr_Linear_Decoupled_HD_cacheBitFieldToMxArray ( mxArray * destArray , mwIndex
i , int j , uint_T bitVal ) ; static void
mr_Linear_Decoupled_HD_cacheBitFieldToMxArray ( mxArray * destArray , mwIndex
i , int j , uint_T bitVal ) { mxSetFieldByNumber ( destArray , i , j ,
mxCreateDoubleScalar ( ( double ) bitVal ) ) ; } static uint_T
mr_Linear_Decoupled_HD_extractBitFieldFromMxArray ( const mxArray * srcArray
, mwIndex i , int j , uint_T numBits ) ; static uint_T
mr_Linear_Decoupled_HD_extractBitFieldFromMxArray ( const mxArray * srcArray
, mwIndex i , int j , uint_T numBits ) { const uint_T varVal = ( uint_T )
mxGetScalar ( mxGetFieldByNumber ( srcArray , i , j ) ) ; return varVal & ( (
1u << numBits ) - 1u ) ; } static void
mr_Linear_Decoupled_HD_cacheDataToMxArrayWithOffset ( mxArray * destArray ,
mwIndex i , int j , mwIndex offset , const void * srcData , size_t numBytes )
; static void mr_Linear_Decoupled_HD_cacheDataToMxArrayWithOffset ( mxArray *
destArray , mwIndex i , int j , mwIndex offset , const void * srcData ,
size_t numBytes ) { uint8_T * varData = ( uint8_T * ) mxGetData (
mxGetFieldByNumber ( destArray , i , j ) ) ; memcpy ( ( uint8_T * ) & varData
[ offset * numBytes ] , ( const uint8_T * ) srcData , numBytes ) ; } static
void mr_Linear_Decoupled_HD_restoreDataFromMxArrayWithOffset ( void *
destData , const mxArray * srcArray , mwIndex i , int j , mwIndex offset ,
size_t numBytes ) ; static void
mr_Linear_Decoupled_HD_restoreDataFromMxArrayWithOffset ( void * destData ,
const mxArray * srcArray , mwIndex i , int j , mwIndex offset , size_t
numBytes ) { const uint8_T * varData = ( const uint8_T * ) mxGetData (
mxGetFieldByNumber ( srcArray , i , j ) ) ; memcpy ( ( uint8_T * ) destData ,
( const uint8_T * ) & varData [ offset * numBytes ] , numBytes ) ; } static
void mr_Linear_Decoupled_HD_cacheBitFieldToCellArrayWithOffset ( mxArray *
destArray , mwIndex i , int j , mwIndex offset , uint_T fieldVal ) ; static
void mr_Linear_Decoupled_HD_cacheBitFieldToCellArrayWithOffset ( mxArray *
destArray , mwIndex i , int j , mwIndex offset , uint_T fieldVal ) {
mxSetCell ( mxGetFieldByNumber ( destArray , i , j ) , offset ,
mxCreateDoubleScalar ( ( double ) fieldVal ) ) ; } static uint_T
mr_Linear_Decoupled_HD_extractBitFieldFromCellArrayWithOffset ( const mxArray
* srcArray , mwIndex i , int j , mwIndex offset , uint_T numBits ) ; static
uint_T mr_Linear_Decoupled_HD_extractBitFieldFromCellArrayWithOffset ( const
mxArray * srcArray , mwIndex i , int j , mwIndex offset , uint_T numBits ) {
const uint_T fieldVal = ( uint_T ) mxGetScalar ( mxGetCell (
mxGetFieldByNumber ( srcArray , i , j ) , offset ) ) ; return fieldVal & ( (
1u << numBits ) - 1u ) ; } mxArray * mr_Linear_Decoupled_HD_GetDWork ( ) {
static const char * ssDWFieldNames [ 3 ] = { "rtB" , "rtDW" , "NULL_PrevZCX"
, } ; mxArray * ssDW = mxCreateStructMatrix ( 1 , 1 , 3 , ssDWFieldNames ) ;
mr_Linear_Decoupled_HD_cacheDataAsMxArray ( ssDW , 0 , 0 , ( const void * ) &
( rtB ) , sizeof ( rtB ) ) ; { static const char * rtdwDataFieldNames [ 2 ] =
{ "rtDW.awuffzesc2" , "rtDW.cycgrsoo3r" , } ; mxArray * rtdwData =
mxCreateStructMatrix ( 1 , 1 , 2 , rtdwDataFieldNames ) ;
mr_Linear_Decoupled_HD_cacheDataAsMxArray ( rtdwData , 0 , 0 , ( const void *
) & ( rtDW . awuffzesc2 ) , sizeof ( rtDW . awuffzesc2 ) ) ;
mr_Linear_Decoupled_HD_cacheDataAsMxArray ( rtdwData , 0 , 1 , ( const void *
) & ( rtDW . cycgrsoo3r ) , sizeof ( rtDW . cycgrsoo3r ) ) ;
mxSetFieldByNumber ( ssDW , 0 , 1 , rtdwData ) ; } return ssDW ; } void
mr_Linear_Decoupled_HD_SetDWork ( const mxArray * ssDW ) { ( void ) ssDW ;
mr_Linear_Decoupled_HD_restoreDataFromMxArray ( ( void * ) & ( rtB ) , ssDW ,
0 , 0 , sizeof ( rtB ) ) ; { const mxArray * rtdwData = mxGetFieldByNumber (
ssDW , 0 , 1 ) ; mr_Linear_Decoupled_HD_restoreDataFromMxArray ( ( void * ) &
( rtDW . awuffzesc2 ) , rtdwData , 0 , 0 , sizeof ( rtDW . awuffzesc2 ) ) ;
mr_Linear_Decoupled_HD_restoreDataFromMxArray ( ( void * ) & ( rtDW .
cycgrsoo3r ) , rtdwData , 0 , 1 , sizeof ( rtDW . cycgrsoo3r ) ) ; } }
mxArray * mr_Linear_Decoupled_HD_GetSimStateDisallowedBlocks ( ) { mxArray *
data = mxCreateCellMatrix ( 1 , 3 ) ; mwIndex subs [ 2 ] , offset ; { static
const char * blockType [ 1 ] = { "Scope" , } ; static const char * blockPath
[ 1 ] = { "Linear_Decoupled_HD/Scope" , } ; static const int reason [ 1 ] = {
0 , } ; for ( subs [ 0 ] = 0 ; subs [ 0 ] < 1 ; ++ ( subs [ 0 ] ) ) { subs [
1 ] = 0 ; offset = mxCalcSingleSubscript ( data , 2 , subs ) ; mxSetCell (
data , offset , mxCreateString ( blockType [ subs [ 0 ] ] ) ) ; subs [ 1 ] =
1 ; offset = mxCalcSingleSubscript ( data , 2 , subs ) ; mxSetCell ( data ,
offset , mxCreateString ( blockPath [ subs [ 0 ] ] ) ) ; subs [ 1 ] = 2 ;
offset = mxCalcSingleSubscript ( data , 2 , subs ) ; mxSetCell ( data ,
offset , mxCreateDoubleScalar ( ( double ) reason [ subs [ 0 ] ] ) ) ; } }
return data ; } void MdlInitializeSizes ( void ) { ssSetNumContStates ( rtS ,
333 ) ; ssSetNumPeriodicContStates ( rtS , 0 ) ; ssSetNumY ( rtS , 0 ) ;
ssSetNumU ( rtS , 0 ) ; ssSetDirectFeedThrough ( rtS , 0 ) ;
ssSetNumSampleTimes ( rtS , 1 ) ; ssSetNumBlocks ( rtS , 20 ) ;
ssSetNumBlockIO ( rtS , 11 ) ; ssSetNumBlockParams ( rtS , 250136 ) ; } void
MdlInitializeSampleTimes ( void ) { ssSetSampleTime ( rtS , 0 , 0.0 ) ;
ssSetOffsetTime ( rtS , 0 , 0.0 ) ; } void raccel_set_checksum ( ) {
ssSetChecksumVal ( rtS , 0 , 2219643579U ) ; ssSetChecksumVal ( rtS , 1 ,
1250443361U ) ; ssSetChecksumVal ( rtS , 2 , 3258463862U ) ; ssSetChecksumVal
( rtS , 3 , 1037043963U ) ; }
#if defined(_MSC_VER)
#pragma optimize( "", off )
#endif
SimStruct * raccel_register_model ( ssExecutionInfo * executionInfo ) {
static struct _ssMdlInfo mdlInfo ; static struct _ssBlkInfo2 blkInfo2 ;
static struct _ssBlkInfoSLSize blkInfoSLSize ; ( void ) memset ( ( char * )
rtS , 0 , sizeof ( SimStruct ) ) ; ( void ) memset ( ( char * ) & mdlInfo , 0
, sizeof ( struct _ssMdlInfo ) ) ; ( void ) memset ( ( char * ) & blkInfo2 ,
0 , sizeof ( struct _ssBlkInfo2 ) ) ; ( void ) memset ( ( char * ) &
blkInfoSLSize , 0 , sizeof ( struct _ssBlkInfoSLSize ) ) ; ssSetBlkInfo2Ptr (
rtS , & blkInfo2 ) ; ssSetBlkInfoSLSizePtr ( rtS , & blkInfoSLSize ) ;
ssSetMdlInfoPtr ( rtS , & mdlInfo ) ; ssSetExecutionInfo ( rtS ,
executionInfo ) ; slsaAllocOPModelData ( rtS ) ; { static time_T mdlPeriod [
NSAMPLE_TIMES ] ; static time_T mdlOffset [ NSAMPLE_TIMES ] ; static time_T
mdlTaskTimes [ NSAMPLE_TIMES ] ; static int_T mdlTsMap [ NSAMPLE_TIMES ] ;
static int_T mdlSampleHits [ NSAMPLE_TIMES ] ; static boolean_T
mdlTNextWasAdjustedPtr [ NSAMPLE_TIMES ] ; static int_T mdlPerTaskSampleHits
[ NSAMPLE_TIMES * NSAMPLE_TIMES ] ; static time_T mdlTimeOfNextSampleHit [
NSAMPLE_TIMES ] ; { int_T i ; for ( i = 0 ; i < NSAMPLE_TIMES ; i ++ ) {
mdlPeriod [ i ] = 0.0 ; mdlOffset [ i ] = 0.0 ; mdlTaskTimes [ i ] = 0.0 ;
mdlTsMap [ i ] = i ; mdlSampleHits [ i ] = 1 ; } } ssSetSampleTimePtr ( rtS ,
& mdlPeriod [ 0 ] ) ; ssSetOffsetTimePtr ( rtS , & mdlOffset [ 0 ] ) ;
ssSetSampleTimeTaskIDPtr ( rtS , & mdlTsMap [ 0 ] ) ; ssSetTPtr ( rtS , &
mdlTaskTimes [ 0 ] ) ; ssSetSampleHitPtr ( rtS , & mdlSampleHits [ 0 ] ) ;
ssSetTNextWasAdjustedPtr ( rtS , & mdlTNextWasAdjustedPtr [ 0 ] ) ;
ssSetPerTaskSampleHitsPtr ( rtS , & mdlPerTaskSampleHits [ 0 ] ) ;
ssSetTimeOfNextSampleHitPtr ( rtS , & mdlTimeOfNextSampleHit [ 0 ] ) ; }
ssSetSolverMode ( rtS , SOLVER_MODE_SINGLETASKING ) ; { ssSetBlockIO ( rtS ,
( ( void * ) & rtB ) ) ; ( void ) memset ( ( ( void * ) & rtB ) , 0 , sizeof
( B ) ) ; } { real_T * x = ( real_T * ) & rtX ; ssSetContStates ( rtS , x ) ;
( void ) memset ( ( void * ) x , 0 , sizeof ( X ) ) ; } { void * dwork = (
void * ) & rtDW ; ssSetRootDWork ( rtS , dwork ) ; ( void ) memset ( dwork ,
0 , sizeof ( DW ) ) ; } { static DataTypeTransInfo dtInfo ; ( void ) memset (
( char_T * ) & dtInfo , 0 , sizeof ( dtInfo ) ) ; ssSetModelMappingInfo ( rtS
, & dtInfo ) ; dtInfo . numDataTypes = 22 ; dtInfo . dataTypeSizes = &
rtDataTypeSizes [ 0 ] ; dtInfo . dataTypeNames = & rtDataTypeNames [ 0 ] ;
dtInfo . BTransTable = & rtBTransTable ; dtInfo . PTransTable = &
rtPTransTable ; dtInfo . dataTypeInfoTable = rtDataTypeInfoTable ; }
Linear_Decoupled_HD_InitializeDataMapInfo ( ) ; ssSetIsRapidAcceleratorActive
( rtS , true ) ; ssSetRootSS ( rtS , rtS ) ; ssSetVersion ( rtS ,
SIMSTRUCT_VERSION_LEVEL2 ) ; ssSetModelName ( rtS , "Linear_Decoupled_HD" ) ;
ssSetPath ( rtS , "Linear_Decoupled_HD" ) ; ssSetTStart ( rtS , 0.16733 ) ;
ssSetTFinal ( rtS , 3000.0185 ) ; { static RTWLogInfo rt_DataLoggingInfo ;
rt_DataLoggingInfo . loggingInterval = ( NULL ) ; ssSetRTWLogInfo ( rtS , &
rt_DataLoggingInfo ) ; } { { static int_T rt_LoggedStateWidths [ ] = { 20 ,
313 } ; static int_T rt_LoggedStateNumDimensions [ ] = { 1 , 1 } ; static
int_T rt_LoggedStateDimensions [ ] = { 20 , 313 } ; static boolean_T
rt_LoggedStateIsVarDims [ ] = { 0 , 0 } ; static BuiltInDTypeId
rt_LoggedStateDataTypeIds [ ] = { SS_DOUBLE , SS_DOUBLE } ; static int_T
rt_LoggedStateComplexSignals [ ] = { 0 , 0 } ; static RTWPreprocessingFcnPtr
rt_LoggingStatePreprocessingFcnPtrs [ ] = { ( NULL ) , ( NULL ) } ; static
const char_T * rt_LoggedStateLabels [ ] = { "CSTATE" , "CSTATE" } ; static
const char_T * rt_LoggedStateBlockNames [ ] = {
"Linear_Decoupled_HD/Integrator1" , "Linear_Decoupled_HD/Integrator" } ;
static const char_T * rt_LoggedStateNames [ ] = { "" , "" } ; static
boolean_T rt_LoggedStateCrossMdlRef [ ] = { 0 , 0 } ; static
RTWLogDataTypeConvert rt_RTWLogDataTypeConvert [ ] = { { 0 , SS_DOUBLE ,
SS_DOUBLE , 0 , 0 , 0 , 1.0 , 0 , 0.0 } , { 0 , SS_DOUBLE , SS_DOUBLE , 0 , 0
, 0 , 1.0 , 0 , 0.0 } } ; static int_T rt_LoggedStateIdxList [ ] = { 0 , 1 }
; static RTWLogSignalInfo rt_LoggedStateSignalInfo = { 2 ,
rt_LoggedStateWidths , rt_LoggedStateNumDimensions , rt_LoggedStateDimensions
, rt_LoggedStateIsVarDims , ( NULL ) , ( NULL ) , rt_LoggedStateDataTypeIds ,
rt_LoggedStateComplexSignals , ( NULL ) , rt_LoggingStatePreprocessingFcnPtrs
, { rt_LoggedStateLabels } , ( NULL ) , ( NULL ) , ( NULL ) , {
rt_LoggedStateBlockNames } , { rt_LoggedStateNames } ,
rt_LoggedStateCrossMdlRef , rt_RTWLogDataTypeConvert , rt_LoggedStateIdxList
} ; static void * rt_LoggedStateSignalPtrs [ 2 ] ; rtliSetLogXSignalPtrs (
ssGetRTWLogInfo ( rtS ) , ( LogSignalPtrsType ) rt_LoggedStateSignalPtrs ) ;
rtliSetLogXSignalInfo ( ssGetRTWLogInfo ( rtS ) , & rt_LoggedStateSignalInfo
) ; rt_LoggedStateSignalPtrs [ 0 ] = ( void * ) & rtX . ad3ik2cpgs [ 0 ] ;
rt_LoggedStateSignalPtrs [ 1 ] = ( void * ) & rtX . bh2njxyf4s [ 0 ] ; }
rtliSetLogT ( ssGetRTWLogInfo ( rtS ) , "tout" ) ; rtliSetLogX (
ssGetRTWLogInfo ( rtS ) , "" ) ; rtliSetLogXFinal ( ssGetRTWLogInfo ( rtS ) ,
"xFinal" ) ; rtliSetLogVarNameModifier ( ssGetRTWLogInfo ( rtS ) , "none" ) ;
rtliSetLogFormat ( ssGetRTWLogInfo ( rtS ) , 4 ) ; rtliSetLogMaxRows (
ssGetRTWLogInfo ( rtS ) , 0 ) ; rtliSetLogDecimation ( ssGetRTWLogInfo ( rtS
) , 1 ) ; rtliSetLogY ( ssGetRTWLogInfo ( rtS ) , "" ) ;
rtliSetLogYSignalInfo ( ssGetRTWLogInfo ( rtS ) , ( NULL ) ) ;
rtliSetLogYSignalPtrs ( ssGetRTWLogInfo ( rtS ) , ( NULL ) ) ; } { static
struct _ssStatesInfo2 statesInfo2 ; ssSetStatesInfo2 ( rtS , & statesInfo2 )
; } { static ssPeriodicStatesInfo periodicStatesInfo ;
ssSetPeriodicStatesInfo ( rtS , & periodicStatesInfo ) ; } { static
ssJacobianPerturbationBounds jacobianPerturbationBounds ;
ssSetJacobianPerturbationBounds ( rtS , & jacobianPerturbationBounds ) ; } {
static ssSolverInfo slvrInfo ; static boolean_T contStatesDisabled [ 333 ] ;
static real_T absTol [ 333 ] = { 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 } ;
static uint8_T absTolControl [ 333 ] = { 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U
, 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U
, 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U
, 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U
, 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U
, 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U
, 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U
, 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U
, 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U
, 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U
, 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U
} ; static real_T contStateJacPerturbBoundMinVec [ 333 ] ; static real_T
contStateJacPerturbBoundMaxVec [ 333 ] ; { int i ; for ( i = 0 ; i < 333 ; ++
i ) { contStateJacPerturbBoundMinVec [ i ] = 0 ;
contStateJacPerturbBoundMaxVec [ i ] = rtGetInf ( ) ; } } ssSetSolverRelTol (
rtS , 0.001 ) ; ssSetStepSize ( rtS , 0.0 ) ; ssSetMinStepSize ( rtS , 0.0 )
; ssSetMaxNumMinSteps ( rtS , - 1 ) ; ssSetMinStepViolatedError ( rtS , 0 ) ;
ssSetMaxStepSize ( rtS , 59.997023399999996 ) ; ssSetSolverMaxOrder ( rtS , -
1 ) ; ssSetSolverRefineFactor ( rtS , 1 ) ; ssSetOutputTimes ( rtS , ( NULL )
) ; ssSetNumOutputTimes ( rtS , 0 ) ; ssSetOutputTimesOnly ( rtS , 0 ) ;
ssSetOutputTimesIndex ( rtS , 0 ) ; ssSetZCCacheNeedsReset ( rtS , 0 ) ;
ssSetDerivCacheNeedsReset ( rtS , 0 ) ; ssSetNumNonContDerivSigInfos ( rtS ,
0 ) ; ssSetNonContDerivSigInfos ( rtS , ( NULL ) ) ; ssSetSolverInfo ( rtS ,
& slvrInfo ) ; ssSetSolverName ( rtS , "VariableStepAuto" ) ;
ssSetVariableStepSolver ( rtS , 1 ) ; ssSetSolverConsistencyChecking ( rtS ,
0 ) ; ssSetSolverAdaptiveZcDetection ( rtS , 0 ) ;
ssSetSolverRobustResetMethod ( rtS , 0 ) ; ssSetAbsTolVector ( rtS , absTol )
; ssSetAbsTolControlVector ( rtS , absTolControl ) ;
ssSetSolverAbsTol_Obsolete ( rtS , absTol ) ;
ssSetSolverAbsTolControl_Obsolete ( rtS , absTolControl ) ;
ssSetJacobianPerturbationBoundsMinVec ( rtS , contStateJacPerturbBoundMinVec
) ; ssSetJacobianPerturbationBoundsMaxVec ( rtS ,
contStateJacPerturbBoundMaxVec ) ; ssSetSolverStateProjection ( rtS , 0 ) ;
ssSetSolverMassMatrixType ( rtS , ( ssMatrixType ) 0 ) ;
ssSetSolverMassMatrixNzMax ( rtS , 0 ) ; ssSetModelOutputs ( rtS , MdlOutputs
) ; ssSetModelLogData ( rtS , rt_UpdateTXYLogVars ) ;
ssSetModelLogDataIfInInterval ( rtS , rt_UpdateTXXFYLogVars ) ;
ssSetModelUpdate ( rtS , MdlUpdate ) ; ssSetModelDerivatives ( rtS ,
MdlDerivatives ) ; ssSetSolverMaxConsecutiveMinStep ( rtS , 1 ) ;
ssSetSolverShapePreserveControl ( rtS , 2 ) ; ssSetTNextTid ( rtS , INT_MIN )
; ssSetTNext ( rtS , rtMinusInf ) ; ssSetSolverNeedsReset ( rtS ) ;
ssSetNumNonsampledZCs ( rtS , 0 ) ; ssSetContStateDisabled ( rtS ,
contStatesDisabled ) ; ssSetSolverMaxConsecutiveMinStep ( rtS , 1 ) ; }
ssSetChecksumVal ( rtS , 0 , 2219643579U ) ; ssSetChecksumVal ( rtS , 1 ,
1250443361U ) ; ssSetChecksumVal ( rtS , 2 , 3258463862U ) ; ssSetChecksumVal
( rtS , 3 , 1037043963U ) ; { static const sysRanDType rtAlwaysEnabled =
SUBSYS_RAN_BC_ENABLE ; static RTWExtModeInfo rt_ExtModeInfo ; static const
sysRanDType * systemRan [ 1 ] ; gblRTWExtModeInfo = & rt_ExtModeInfo ;
ssSetRTWExtModeInfo ( rtS , & rt_ExtModeInfo ) ;
rteiSetSubSystemActiveVectorAddresses ( & rt_ExtModeInfo , systemRan ) ;
systemRan [ 0 ] = & rtAlwaysEnabled ; rteiSetModelMappingInfoPtr (
ssGetRTWExtModeInfo ( rtS ) , & ssGetModelMappingInfo ( rtS ) ) ;
rteiSetChecksumsPtr ( ssGetRTWExtModeInfo ( rtS ) , ssGetChecksums ( rtS ) )
; rteiSetTPtr ( ssGetRTWExtModeInfo ( rtS ) , ssGetTPtr ( rtS ) ) ; }
slsaDisallowedBlocksForSimTargetOP ( rtS ,
mr_Linear_Decoupled_HD_GetSimStateDisallowedBlocks ) ;
slsaGetWorkFcnForSimTargetOP ( rtS , mr_Linear_Decoupled_HD_GetDWork ) ;
slsaSetWorkFcnForSimTargetOP ( rtS , mr_Linear_Decoupled_HD_SetDWork ) ;
rt_RapidReadMatFileAndUpdateParams ( rtS ) ; if ( ssGetErrorStatus ( rtS ) )
{ return rtS ; } return rtS ; }
#if defined(_MSC_VER)
#pragma optimize( "", on )
#endif
const int_T gblParameterTuningTid = 1 ; void MdlOutputsParameterSampleTime (
int_T tid ) { MdlOutputsTID1 ( tid ) ; }
