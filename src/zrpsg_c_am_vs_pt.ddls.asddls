@EndUserText.label: 'Predefines Longtexts'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZRPSG_C_AM_VS_PT
  as projection on ZRPSG_I_AM_VS_PT
{
  key Num,
  key VersionNum,
  key ElementNum,
      //      @Consumption.filter.defaultValue: #(
      @ObjectModel.text.element: ['ElementTypeText']
      ElementType,
      _ElementType.Description as ElementTypeText,
      Text,
      //      Language,
      //      _PTEXT.Text,
      /* Associations */
      _VS : redirected to parent ZRPSG_C_AM_VS,
      _AM : redirected to ZRPSG_C_AM
}
