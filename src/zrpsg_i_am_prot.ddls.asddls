@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ProposalText BO'
define root view entity ZRPSG_I_AM_PROT
  as select from zrpsg_am_prot as prot
  
 
{
  key element_type as ElementType,
  key spras as Language,
  text as Text,
  @Semantics.user.createdBy: true
  creation_user as CreationUser,
  @Semantics.systemDateTime.createdAt: true
  creation_time as CreationTime,
  @Semantics.user.lastChangedBy: true
  lastchange_user as LastchangeUser,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchange_time as LastchangeTime,
  all_lastchange_time as AllLastchangeTime,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt,
  local_last_changed as LocalLastChanged
  
}
