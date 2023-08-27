@EndUserText.label: 'Allowed tables'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZRPSG_C_AM_OB_C01
  provider contract transactional_query
  as projection on ZRPSG_I_AM_OB_C01
{
  key TableName,
      Description,
      LastChangedAt,
      LocalLastChangedAt
}
