@EndUserText.label: 'Agrement Partner'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define root view entity ZRPSG_C_AM_PA
  provider contract transactional_query
  as projection on ZRPSG_I_AM_PA
{
  key PartnerNum,
      Name,
      LastchangeUser,
      LastchangeTime,
      AllLastchangeTime
}
