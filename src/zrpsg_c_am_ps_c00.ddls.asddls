@EndUserText.label: 'person role'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define root view entity ZRPSG_C_AM_PS_C00
  provider contract transactional_query
  as projection on ZRPSG_I_AM_PS_C00
{
  key Role,
      Description,
      LastchangeTime,
      AllLastchangeTime

}
