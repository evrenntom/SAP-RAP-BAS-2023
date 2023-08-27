@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agrement Partner'

@Metadata.allowExtensions: true

define root view entity ZRPSG_I_AM_PA
  as select from zrpsg_am_pa as PA
{
  key PA.partner_num         as PartnerNum,
      PA.name                as Name,
      @Semantics.user.lastChangedBy: true
      PA.lastchange_user     as LastchangeUser,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      PA.lastchange_time     as LastchangeTime,
      @Semantics.systemDateTime.lastChangedAt: true
      PA.all_lastchange_time as AllLastchangeTime
}
