@EndUserText.label: 'Condition Contract'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define view entity ZRPSG_C_EL_CONTR
  as projection on ZRPSG_I_EL_CONTR
{
  key Num,
  key VersionNum,
  key ElementNum,
      @ObjectModel.text.element: ['ElementTypeText']
      ElementType,
      _ElementType.Description as ElementTypeText,
      HeaderText,
      CocoNum,
      @ObjectModel.text.element: ['CalcTypeText']
      CalcType,
      _CalcType._Text.Text as CalcTypeText : localized,
      Amount,
      Currency,
      PricingUnit,
      Unit,
      AmountPer,
      Percentage,
       
      /* Associations */
      _VS_EL : redirected to ZRPSG_C_AM_VS_EL,
      _VS    : redirected to parent ZRPSG_C_AM_VS,
      _AM    : redirected to ZRPSG_C_AM
}
