@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Person'
define view entity ZRPSG_I_AM_PS_VH
  as select from ZRPSG_I_AM_PS
{
  key PersonNum,
      Name,
      PhoneNumber,
      Mail,
      LastchangeTime,
      AllLastchangeTime
}
