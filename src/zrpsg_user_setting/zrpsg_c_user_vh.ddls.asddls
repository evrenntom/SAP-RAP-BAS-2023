@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Value Help'
define root view entity ZRPSG_C_USER_VH
  as select from ZRPSG_I_User_VH
{
  key UserId
}
