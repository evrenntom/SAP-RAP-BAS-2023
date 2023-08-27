@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Element type Predefined Longtext VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRPSG_I_ET_PT_VH_2 
with parameters P_langu: spras
  as select from ZRPSG_I_AM_EL_C00
  left outer join ZRPSG_I_AM_PTEXT on  ZRPSG_I_AM_EL_C00.ElementType
  = ZRPSG_I_AM_PTEXT.ElementType
//  association [1..1] to ZRPSG_I_AM_PTEXT on ZRPSG_I_AM_EL_C00.ElementType
//  = ZRPSG_I_AM_PTEXT.ElementType
    
{
  key ZRPSG_I_AM_EL_C00.ElementType,
      ZRPSG_I_AM_EL_C00.Description,
      ZRPSG_I_AM_EL_C00.ObjektType,
      ZRPSG_I_AM_EL_C00._OB_C00.Description as DescriptionObjectType,
      ZRPSG_I_AM_EL_C00._OB_C00.TableName   as TableName
//      ZRPSG_I_AM_PTEXT
}
where
  ZRPSG_I_AM_EL_C00._OB_C00.TableName = 'ZRPSG_AM_PTEXT'
  and ZRPSG_I_AM_PTEXT.Language = $parameters.P_langu
