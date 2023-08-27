@EndUserText.label: 'User Settings for AM'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define root view entity ZRPSG_C_USER_SETTINGS
  as projection on ZRPSG_I_USER_SETTINGS
{
  key UserId,
      CustomisingViewType,
      LastchangeUser,
      LastchangeTime,
      
      Alllastchangetime
}
