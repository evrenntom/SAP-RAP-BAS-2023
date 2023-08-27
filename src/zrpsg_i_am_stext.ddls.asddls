@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shorttext'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRPSG_I_AM_STEXT
  as select from zrpsg_am_stext
  association [1..1] to ZRPSG_I_AM           as _AM          on  $projection.Num = _AM.Num
  association        to parent ZRPSG_I_AM_VS as _VS          on  $projection.Num        = _VS.Num
                                                             and $projection.VersionNum = _VS.VersionNum
  association [1..1] to ZRPSG_I_ET_STEXT_VH  as _ElementType on  $projection.agreementtype = _ElementType.AgreementType
                                                             and $projection.ElementType   = _ElementType.ElementType

{
  key zrpsg_am_stext.num          as Num,
  key zrpsg_am_stext.version_num  as VersionNum,
  key zrpsg_am_stext.element_num  as ElementNum,
      zrpsg_am_stext.element_type as ElementType,
      zrpsg_am_stext.description  as Description,
      zrpsg_am_stext.text         as Text,

      /*for association */
      _AM.AgreementType,
      /*association*/
      _AM,
      _VS,
      _ElementType
}
