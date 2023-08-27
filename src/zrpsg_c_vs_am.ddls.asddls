@EndUserText.label: 'Vereinbarungs- Versionsübersicht'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define root view entity ZRPSG_C_VS_AM
  as projection on ZRPSG_I_vs_AM
{
  key Num,
  key VersionNum,
      VersionStatus,
      DateFrom,
      DateTo,
      CreationUser,
      CreationTime,
      LastchangeUser,
      LastchangeTime,
      AllLastchangeTime,
      /* Associations */
      _am
}
