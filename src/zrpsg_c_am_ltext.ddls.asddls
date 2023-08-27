@EndUserText.label: 'Longtext'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
//@ObjectModel.semanticKey: [ 'Num', 'VersionNum', 'ElementNum' ]
 
define view entity ZRPSG_C_AM_LTEXT
  as projection on ZRPSG_I_AM_LTEXT
{
  key Num,
  key VersionNum,
  key ElementNum,
      @ObjectModel.text.element: ['ElementTypeText']
      ElementType,
      _ElementType.Description as ElementTypeText,
      Description,
      Text,
      
      Ltext,
      
      /* Associations */
      _VS : redirected to parent ZRPSG_C_AM_VS,
      _AM : redirected to ZRPSG_C_AM
}
