@EndUserText.label: 'Value Help for Person Role'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZRPSG_C_AM_PS_C00_VH
  as projection on ZRPSG_I_AM_PS_C00_VH
{
  key Role,
      Description,
      LastchangeTime,
      AllLastchangeTime
}
