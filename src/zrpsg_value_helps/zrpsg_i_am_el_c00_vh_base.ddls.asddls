@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base view for Elemtntype VH with Agreementtype'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRPSG_I_AM_EL_C00_VH_BASE
  as select from ZRPSG_I_AM_C00 as AM_C00

  association [1..*] to ZRPSG_I_AM_EL_C02 as _EL_C02 on $projection.ElementTypeGroupNum = _EL_C02.ElementTypeGroupNum
{
  key AM_C00.AgreementType,
  key _EL_C02.ElementType,
      AM_C00.ElementTypeGroupNum,
      AM_C00.Description             as Agreementtype_Description,
      _EL_C02._el_c00_vh.Description as Elementtype_Description,
      _EL_C02._el_c00.ObjektType,
      _EL_C02._el_c00._OB_C00

}
