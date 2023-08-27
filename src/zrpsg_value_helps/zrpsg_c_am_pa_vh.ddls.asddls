@EndUserText.label: 'Value Help for Partner'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZRPSG_C_AM_PA_VH
  as projection on ZRPSG_I_AM_PA_VH
{
  key PartnerNum,
      Name,
      LastchangeUser,
      LastchangeTime,
      AllLastchangeTime
}
