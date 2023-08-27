@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ValueHelp for Objects'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRPSG_I_AM_OB_C00_VH
  as select from ZRPSG_I_AM_OB_C00
{
  key ObjektType,
      Description,
      TableName
      
}
