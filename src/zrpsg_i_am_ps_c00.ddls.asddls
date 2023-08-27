@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'negotiating person role Interface View'

@Metadata.allowExtensions: true

define root view entity ZRPSG_I_AM_PS_C00
  as select from zrpsg_am_ps_c00
{

  key role                as Role,
      description         as Description,
      lastchange_time     as LastchangeTime,
      all_lastchange_time as AllLastchangeTime
}
