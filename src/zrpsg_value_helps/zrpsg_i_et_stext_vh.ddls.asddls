@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Element type STEXT value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}



define view entity ZRPSG_I_ET_STEXT_VH
//with parameters relevant_AgreementType: zrpsg_am_type
  as select from ZRPSG_I_AM_EL_C00_VH_BASE
{
  key AgreementType,
  key ElementType,
      Elementtype_Description as Description,
      ObjektType,
      _OB_C00.Description as DescriptionObjectType,
      _OB_C00.TableName   as TableName,
      AgreementType as testmerkmal
}
where
  _OB_C00.TableName = 'ZRPSG_AM_STEXT'
//  and AgreementType = $parameters.relevant_AgreementType
