@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Condition Contract'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
   serviceQuality: #X,
   sizeCategory: #S,
   dataClass: #MIXED
}

define view entity ZRPSG_I_EL_CONTR
  as select from zrpsg_el_contr as el_contr


  association [1..1] to ZRPSG_I_AM           as _AM       on  $projection.Num = _AM.Num
  association        to parent ZRPSG_I_AM_VS as _VS       on  $projection.Num        = _VS.Num
                                                          and $projection.VersionNum = _VS.VersionNum
  association [0..1] to ZRPSG_I_AM_VS_EL     as _VS_EL    on  $projection.Num        = _VS_EL.Num
                                                          and $projection.VersionNum = _VS_EL.VersionNum
                                                          and $projection.ElementNum = _VS_EL.ElementNum

  association [1..1] to ZRPSG_I_CALCTYPE_VH  as _CalcType on  $projection.CalcType = _CalcType.Value
  association [1..1] to ZRPSG_I_ET_CONTR_VH  as _ElementType on $projection.ElementType = _ElementType.ElementType

{
  key el_contr.num                           as Num,
  key el_contr.version_num                   as VersionNum,
  key el_contr.element_num                   as ElementNum,
      el_contr.element_type                  as ElementType,
//      _ElementType.Description               as ElementTypeText,
      el_contr.header_text                   as HeaderText,
      el_contr.coco_num                      as CocoNum,
      el_contr.calc_type                     as CalcType,
      @Semantics.amount.currencyCode : 'Currency'
      el_contr.amount                        as Amount,
      el_contr.currency                      as Currency,
      @Semantics.quantity.unitOfMeasure : 'Percentage'
      el_contr.amount_per                    as AmountPer,
      cast(
        case when $projection.CalcType = 'A'
             then '%' else '' end as meins ) as Percentage,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      el_contr.kpein                         as PricingUnit,
      el_contr.kmein                         as Unit,

      _VS_EL,
      _VS,
      _AM,

      _CalcType,
      _ElementType
}
