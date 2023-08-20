#include "Linear_Decoupled_HD_capi_host.h"
static Linear_Decoupled_HD_host_DataMapInfo_T root;
static int initialized = 0;
__declspec( dllexport ) rtwCAPI_ModelMappingInfo *getRootMappingInfo()
{
    if (initialized == 0) {
        initialized = 1;
        Linear_Decoupled_HD_host_InitializeDataMapInfo(&(root), "Linear_Decoupled_HD");
    }
    return &root.mmi;
}

rtwCAPI_ModelMappingInfo *mexFunction() {return(getRootMappingInfo());}
