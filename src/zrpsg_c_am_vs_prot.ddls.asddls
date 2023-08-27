@EndUserText.label: 'Textbausteine bearbeitbar'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZRPSG_C_AM_VS_Prot
  as projection on ZRPSG_I_AM_VS_PROT
{

  key    Num,
  key    VersionNum,
  key    ElementNum,

         @ObjectModel.text.element: ['ElementTypeText']
         ElementType,

         Spras,
         _ElementType.Description as ElementTypeText,
         Text,
         /* Associations */
         _VS : redirected to parent ZRPSG_C_AM_VS,
         _AM : redirected to ZRPSG_C_AM

}
