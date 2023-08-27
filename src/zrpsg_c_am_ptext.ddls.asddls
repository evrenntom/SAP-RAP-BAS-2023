@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZRPSG_I_AM_PTEXT'
@ObjectModel.semanticKey: [ 'ElementType', 'Language' ]
define root view entity ZRPSG_C_AM_PTEXT
  provider contract transactional_query
  as projection on ZRPSG_I_AM_PTEXT
{
  @ObjectModel.text.element: ['ElementTypeText']     
  key ElementType,    
  key Language,
  Text,
  AllLastchangeTime,
  LastChangedAt,
  LocalLastChanged,
  _ElementType.Description as ElementTypeText
  
}
