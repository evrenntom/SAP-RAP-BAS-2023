@EndUserText.label: 'Shorttext'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define view entity ZRPSG_C_AM_STEXT
  as projection on ZRPSG_I_AM_STEXT
{
  key Num,
  key VersionNum,
  key ElementNum,
      @ObjectModel.text.element: ['ElementTypeText']
      ElementType,
      _ElementType.Description as ElementTypeText,
      Text,
      Description,
      
      AgreementType,

      /* Associations */
      _VS : redirected to parent ZRPSG_C_AM_VS,
      _AM : redirected to ZRPSG_C_AM
}
