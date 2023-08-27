@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Person Role'
define root view entity ZRPSG_I_AM_PS_C00_VH
  as select from ZRPSG_I_AM_PS_C00 as PS_C00
{
  key Role,
      Description,
      LastchangeTime,
      AllLastchangeTime
}
