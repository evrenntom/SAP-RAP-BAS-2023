@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ProposalText Version Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define view entity ZRPSG_I_AM_VS_PROT
  as select from zrpsg_am_vs_prot
  association [1..1] to ZRPSG_I_AM           as _AM          on  $projection.Num = _AM.Num
  association        to parent ZRPSG_I_AM_VS as _VS          on  $projection.Num        = _VS.Num
                                                             and $projection.VersionNum = _VS.VersionNum
  association [1..1] to ZRPSG_I_Prot_VH      as _ElementType on  $projection.ElementType = _ElementType.ElementType

{
  key zrpsg_am_vs_prot.num          as Num,
  key zrpsg_am_vs_prot.version_num  as VersionNum,
  key zrpsg_am_vs_prot.element_num  as ElementNum,
      zrpsg_am_vs_prot.element_type as ElementType,
      zrpsg_am_vs_prot.spras        as Spras,
      zrpsg_am_vs_prot.text         as Text,

      _AM,
      _VS,
      _ElementType

}
