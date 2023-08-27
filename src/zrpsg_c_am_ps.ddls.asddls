@EndUserText.label: 'Person'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define root view entity ZRPSG_C_AM_PS
  provider contract transactional_query
  as projection on ZRPSG_I_AM_PS
{
  key PersonNum,
      Name,
      PhoneNumber,
      Mail,
      LastchangeTime,
      AllLastchangeTime
}
