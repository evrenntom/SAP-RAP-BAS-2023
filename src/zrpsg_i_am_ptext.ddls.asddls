@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PTEXT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZRPSG_I_AM_PTEXT
  as select from zrpsg_am_ptext as PTEXT
  association [1..1] to ZRPSG_I_ET_PT_VH  as _ElementType on $projection.ElementType = _ElementType.ElementType
  
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
  local_last_changed as LocalLastChanged,
  
  _ElementType
  
}
