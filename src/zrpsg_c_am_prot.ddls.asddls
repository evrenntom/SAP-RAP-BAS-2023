@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZRPSG_I_AM_PROT'
@ObjectModel.semanticKey: [ 'ElementType', 'Language' ]
define root view entity ZRPSG_C_AM_PROT
  provider contract transactional_query
  as projection on ZRPSG_I_AM_PROT
{
  key ElementType,
  key Language,
  Text,
  AllLastchangeTime,
  LastChangedAt,
  LocalLastChanged
  
}
