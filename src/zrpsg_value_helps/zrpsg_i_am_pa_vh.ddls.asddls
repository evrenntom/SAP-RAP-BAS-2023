@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Partner'
define root view entity ZRPSG_I_AM_PA_VH
  as select from ZRPSG_I_AM_PA as PA
{
  key PartnerNum,
      Name,
      LastchangeUser,
      LastchangeTime,
      AllLastchangeTime
}
