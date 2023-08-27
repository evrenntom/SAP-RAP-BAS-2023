@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Longtext'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRPSG_I_AM_LTEXT
  as select from zrpsg_am_ltext
  association [1..1] to ZRPSG_I_AM           as _AM          on  $projection.Num = _AM.Num
  association        to parent ZRPSG_I_AM_VS as _VS          on  $projection.Num        = _VS.Num
                                                             and $projection.VersionNum = _VS.VersionNum
  association [1..1] to ZRPSG_I_ET_LTEXT_VH  as _ElementType on  $projection.ElementType = _ElementType.ElementType

{
  key zrpsg_am_ltext.num          as Num,
  key zrpsg_am_ltext.version_num  as VersionNum,
  key zrpsg_am_ltext.element_num  as ElementNum,
      zrpsg_am_ltext.element_type as ElementType,
      zrpsg_am_ltext.description  as Description,
      zrpsg_am_ltext.text         as Text,

      @EndUserText.label: 'Text'
      zrpsg_am_ltext.ltext        as Ltext,

      _AM,
      _VS,
      _ElementType
}
