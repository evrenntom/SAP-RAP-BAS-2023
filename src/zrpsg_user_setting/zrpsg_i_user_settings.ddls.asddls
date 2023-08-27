@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Settings for AM'
define root view entity ZRPSG_I_USER_SETTINGS
  as select from zrpsg_user_set

  association [0..1] to I_User as _User on  $projection.UserId = _User.UserID
                                        and _User.UserID       = $session.user

{
  key zrpsg_user_set.user_id               as UserId,
      zrpsg_user_set.customising_view_type as CustomisingViewType,
      zrpsg_user_set.lastchange_user       as LastchangeUser,
      zrpsg_user_set.lastchange_time       as LastchangeTime,
      zrpsg_user_set.alllastchangetime     as Alllastchangetime
}
