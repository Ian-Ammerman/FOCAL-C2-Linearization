#include "rtw_capi.h"
#ifdef HOST_CAPI_BUILD
#include "Linear_Decoupled_HD_capi_host.h"
#define sizeof(s) ((size_t)(0xFFFF))
#undef rt_offsetof
#define rt_offsetof(s,el) ((uint16_T)(0xFFFF))
#define TARGET_CONST
#define TARGET_STRING(s) (s)
#ifndef SS_UINT64
#define SS_UINT64 17
#endif
#ifndef SS_INT64
#define SS_INT64 18
#endif
#else
#include "builtin_typeid_types.h"
#include "Linear_Decoupled_HD.h"
#include "Linear_Decoupled_HD_capi.h"
#include "Linear_Decoupled_HD_private.h"
#ifdef LIGHT_WEIGHT_CAPI
#define TARGET_CONST
#define TARGET_STRING(s)               ((NULL))
#else
#define TARGET_CONST                   const
#define TARGET_STRING(s)               (s)
#endif
#endif
static const rtwCAPI_Signals rtBlockSignals [ ] = { { 0 , 0 , TARGET_STRING (
"Linear_Decoupled_HD/Vector Concatenate" ) , TARGET_STRING ( "" ) , 0 , 0 , 0
, 0 , 0 } , { 1 , 0 , TARGET_STRING (
"Linear_Decoupled_HD/HydroDyn State-Space Inputs" ) , TARGET_STRING ( "" ) ,
0 , 0 , 1 , 0 , 0 } , { 2 , 0 , TARGET_STRING ( "Linear_Decoupled_HD/A_HD" )
, TARGET_STRING ( "" ) , 0 , 0 , 2 , 0 , 0 } , { 3 , 0 , TARGET_STRING (
"Linear_Decoupled_HD/A_platform" ) , TARGET_STRING ( "" ) , 0 , 0 , 3 , 0 , 0
} , { 4 , 0 , TARGET_STRING ( "Linear_Decoupled_HD/B_HD" ) , TARGET_STRING (
"" ) , 0 , 0 , 2 , 0 , 0 } , { 5 , 0 , TARGET_STRING (
"Linear_Decoupled_HD/B_platform" ) , TARGET_STRING ( "" ) , 0 , 0 , 3 , 0 , 0
} , { 6 , 0 , TARGET_STRING ( "Linear_Decoupled_HD/C_HD" ) , TARGET_STRING (
"" ) , 0 , 0 , 4 , 0 , 0 } , { 7 , 0 , TARGET_STRING (
"Linear_Decoupled_HD/Integrator" ) , TARGET_STRING ( "" ) , 0 , 0 , 2 , 0 , 0
} , { 8 , 0 , TARGET_STRING ( "Linear_Decoupled_HD/Integrator1" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 3 , 0 , 0 } , { 9 , 0 , TARGET_STRING (
"Linear_Decoupled_HD/Sum" ) , TARGET_STRING ( "" ) , 0 , 0 , 2 , 0 , 0 } , {
10 , 0 , TARGET_STRING ( "Linear_Decoupled_HD/Sum1" ) , TARGET_STRING ( "" )
, 0 , 0 , 3 , 0 , 0 } , { 11 , 0 , TARGET_STRING ( "Linear_Decoupled_HD/Sum4"
) , TARGET_STRING ( "" ) , 0 , 0 , 3 , 0 , 0 } , { 0 , 0 , ( NULL ) , ( NULL
) , 0 , 0 , 0 , 0 , 0 } } ; static const rtwCAPI_BlockParameters
rtBlockParameters [ ] = { { 12 , TARGET_STRING (
"Linear_Decoupled_HD/Constant" ) , TARGET_STRING ( "Value" ) , 0 , 5 , 0 } ,
{ 13 , TARGET_STRING ( "Linear_Decoupled_HD/Constant1" ) , TARGET_STRING (
"Value" ) , 0 , 6 , 0 } , { 14 , TARGET_STRING (
"Linear_Decoupled_HD/From Workspace" ) , TARGET_STRING ( "Time0" ) , 0 , 1 ,
0 } , { 15 , TARGET_STRING ( "Linear_Decoupled_HD/From Workspace" ) ,
TARGET_STRING ( "Data0" ) , 0 , 3 , 0 } , { 16 , TARGET_STRING (
"Linear_Decoupled_HD/HydroDyn State-Space Inputs" ) , TARGET_STRING ( "Time0"
) , 0 , 7 , 0 } , { 17 , TARGET_STRING (
"Linear_Decoupled_HD/HydroDyn State-Space Inputs" ) , TARGET_STRING ( "Data0"
) , 0 , 7 , 0 } , { 18 , TARGET_STRING ( "Linear_Decoupled_HD/Integrator" ) ,
TARGET_STRING ( "InitialCondition" ) , 0 , 1 , 0 } , { 19 , TARGET_STRING (
"Linear_Decoupled_HD/Integrator1" ) , TARGET_STRING ( "InitialCondition" ) ,
0 , 1 , 0 } , { 0 , ( NULL ) , ( NULL ) , 0 , 0 , 0 } } ; static int_T
rt_LoggedStateIdxList [ ] = { - 1 } ; static const rtwCAPI_Signals
rtRootInputs [ ] = { { 0 , 0 , ( NULL ) , ( NULL ) , 0 , 0 , 0 , 0 , 0 } } ;
static const rtwCAPI_Signals rtRootOutputs [ ] = { { 0 , 0 , ( NULL ) , (
NULL ) , 0 , 0 , 0 , 0 , 0 } } ; static const rtwCAPI_ModelParameters
rtModelParameters [ ] = { { 20 , TARGET_STRING ( "A_HD" ) , 0 , 8 , 0 } , {
21 , TARGET_STRING ( "A_platform" ) , 0 , 9 , 0 } , { 22 , TARGET_STRING (
"B_HD" ) , 0 , 2 , 0 } , { 23 , TARGET_STRING ( "B_platform" ) , 0 , 10 , 0 }
, { 24 , TARGET_STRING ( "C_HD" ) , 0 , 11 , 0 } , { 25 , TARGET_STRING (
"C_platform" ) , 0 , 12 , 0 } , { 0 , ( NULL ) , 0 , 0 , 0 } } ;
#ifndef HOST_CAPI_BUILD
static void * rtDataAddrMap [ ] = { & rtB . fql2je0s4g [ 0 ] , & rtB .
g0vm3uynhb , & rtB . mtjk1hrcqk [ 0 ] , & rtB . cnutujturz [ 0 ] , & rtB .
e15osh5iil [ 0 ] , & rtB . gn4npwrlyj [ 0 ] , ( & rtB . fql2je0s4g [ 0 ] + 39
) , & rtB . cpljaqsgck [ 0 ] , & rtB . gdscea3t3s [ 0 ] , & rtB . jlczdjbm4r
[ 0 ] , & rtB . knee2kaf1d [ 0 ] , & rtB . ltbm5hkgir [ 0 ] , & rtP .
Constant_Value [ 0 ] , & rtP . Constant1_Value [ 0 ] , & rtP .
FromWorkspace_Time0 , & rtP . FromWorkspace_Data0 [ 0 ] , & rtP .
HydroDynStateSpaceInputs_Time0 [ 0 ] , & rtP . HydroDynStateSpaceInputs_Data0
[ 0 ] , & rtP . Integrator_IC , & rtP . Integrator1_IC , & rtP . A_HD [ 0 ] ,
& rtP . A_platform [ 0 ] , & rtP . B_HD [ 0 ] , & rtP . B_platform [ 0 ] , &
rtP . C_HD [ 0 ] , & rtP . C_platform [ 0 ] , } ; static int32_T *
rtVarDimsAddrMap [ ] = { ( NULL ) } ;
#endif
static TARGET_CONST rtwCAPI_DataTypeMap rtDataTypeMap [ ] = { { "double" ,
"real_T" , 0 , 0 , sizeof ( real_T ) , ( uint8_T ) SS_DOUBLE , 0 , 0 , 0 } }
;
#ifdef HOST_CAPI_BUILD
#undef sizeof
#endif
static TARGET_CONST rtwCAPI_ElementMap rtElementMap [ ] = { { ( NULL ) , 0 ,
0 , 0 , 0 } , } ; static const rtwCAPI_DimensionMap rtDimensionMap [ ] = { {
rtwCAPI_VECTOR , 0 , 2 , 0 } , { rtwCAPI_SCALAR , 2 , 2 , 0 } , {
rtwCAPI_VECTOR , 4 , 2 , 0 } , { rtwCAPI_VECTOR , 6 , 2 , 0 } , {
rtwCAPI_VECTOR , 8 , 2 , 0 } , { rtwCAPI_VECTOR , 10 , 2 , 0 } , {
rtwCAPI_VECTOR , 12 , 2 , 0 } , { rtwCAPI_VECTOR , 14 , 2 , 0 } , {
rtwCAPI_MATRIX_COL_MAJOR , 16 , 2 , 0 } , { rtwCAPI_MATRIX_COL_MAJOR , 18 , 2
, 0 } , { rtwCAPI_MATRIX_COL_MAJOR , 20 , 2 , 0 } , {
rtwCAPI_MATRIX_COL_MAJOR , 22 , 2 , 0 } , { rtwCAPI_MATRIX_COL_MAJOR , 24 , 2
, 0 } } ; static const uint_T rtDimensionArray [ ] = { 235 , 1 , 1 , 1 , 313
, 1 , 20 , 1 , 1 , 6 , 39 , 1 , 190 , 1 , 71712 , 1 , 313 , 313 , 20 , 20 ,
20 , 235 , 6 , 313 , 60 , 20 } ; static const real_T rtcapiStoredFloats [ ] =
{ 0.0 } ; static const rtwCAPI_FixPtMap rtFixPtMap [ ] = { { ( NULL ) , (
NULL ) , rtwCAPI_FIX_RESERVED , 0 , 0 , ( boolean_T ) 0 } , } ; static const
rtwCAPI_SampleTimeMap rtSampleTimeMap [ ] = { { ( const void * ) &
rtcapiStoredFloats [ 0 ] , ( const void * ) & rtcapiStoredFloats [ 0 ] , (
int8_T ) 0 , ( uint8_T ) 0 } } ; static rtwCAPI_ModelMappingStaticInfo
mmiStatic = { { rtBlockSignals , 12 , rtRootInputs , 0 , rtRootOutputs , 0 }
, { rtBlockParameters , 8 , rtModelParameters , 6 } , { ( NULL ) , 0 } , {
rtDataTypeMap , rtDimensionMap , rtFixPtMap , rtElementMap , rtSampleTimeMap
, rtDimensionArray } , "float" , { 2219643579U , 1250443361U , 3258463862U ,
1037043963U } , ( NULL ) , 0 , ( boolean_T ) 0 , rt_LoggedStateIdxList } ;
const rtwCAPI_ModelMappingStaticInfo * Linear_Decoupled_HD_GetCAPIStaticMap (
void ) { return & mmiStatic ; }
#ifndef HOST_CAPI_BUILD
void Linear_Decoupled_HD_InitializeDataMapInfo ( void ) { rtwCAPI_SetVersion
( ( * rt_dataMapInfoPtr ) . mmi , 1 ) ; rtwCAPI_SetStaticMap ( ( *
rt_dataMapInfoPtr ) . mmi , & mmiStatic ) ; rtwCAPI_SetLoggingStaticMap ( ( *
rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ; rtwCAPI_SetDataAddressMap ( ( *
rt_dataMapInfoPtr ) . mmi , rtDataAddrMap ) ; rtwCAPI_SetVarDimsAddressMap (
( * rt_dataMapInfoPtr ) . mmi , rtVarDimsAddrMap ) ;
rtwCAPI_SetInstanceLoggingInfo ( ( * rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArray ( ( * rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArrayLen ( ( * rt_dataMapInfoPtr ) . mmi , 0 ) ; }
#else
#ifdef __cplusplus
extern "C" {
#endif
void Linear_Decoupled_HD_host_InitializeDataMapInfo (
Linear_Decoupled_HD_host_DataMapInfo_T * dataMap , const char * path ) {
rtwCAPI_SetVersion ( dataMap -> mmi , 1 ) ; rtwCAPI_SetStaticMap ( dataMap ->
mmi , & mmiStatic ) ; rtwCAPI_SetDataAddressMap ( dataMap -> mmi , ( NULL ) )
; rtwCAPI_SetVarDimsAddressMap ( dataMap -> mmi , ( NULL ) ) ;
rtwCAPI_SetPath ( dataMap -> mmi , path ) ; rtwCAPI_SetFullPath ( dataMap ->
mmi , ( NULL ) ) ; rtwCAPI_SetChildMMIArray ( dataMap -> mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArrayLen ( dataMap -> mmi , 0 ) ; }
#ifdef __cplusplus
}
#endif
#endif
