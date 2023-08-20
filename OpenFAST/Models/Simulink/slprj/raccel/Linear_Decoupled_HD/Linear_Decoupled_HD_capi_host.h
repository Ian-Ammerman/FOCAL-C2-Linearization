#ifndef RTW_HEADER_Linear_Decoupled_HD_cap_host_h__
#define RTW_HEADER_Linear_Decoupled_HD_cap_host_h__
#ifdef HOST_CAPI_BUILD
#include "rtw_capi.h"
#include "rtw_modelmap_simtarget.h"
typedef struct { rtwCAPI_ModelMappingInfo mmi ; }
Linear_Decoupled_HD_host_DataMapInfo_T ;
#ifdef __cplusplus
extern "C" {
#endif
void Linear_Decoupled_HD_host_InitializeDataMapInfo (
Linear_Decoupled_HD_host_DataMapInfo_T * dataMap , const char * path ) ;
#ifdef __cplusplus
}
#endif
#endif
#endif
