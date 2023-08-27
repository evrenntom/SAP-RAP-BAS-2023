@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'negotiating person Interface View'
define root view entity ZRPSG_I_AM_PS
  as select from zrpsg_am_ps
{
  key person_num          as PersonNum,
      name                as Name,
      phone_number        as PhoneNumber,
      mail                as Mail,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      lastchange_time     as LastchangeTime,
      @Semantics.systemDateTime.lastChangedAt: true
      all_lastchange_time as AllLastchangeTime
}
