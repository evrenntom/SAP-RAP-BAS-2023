@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Element type CONTR value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZRPSG_I_ET_CONTR_VH
  as select from ZRPSG_I_AM_EL_C00
{
  key ElementType,
      Description,
      ObjektType,
      _OB_C00.Description as DescriptionObjectType,
      _OB_C00.TableName   as TableName
}
where
  _OB_C00.TableName = 'ZRPSG_EL_CONTR'
