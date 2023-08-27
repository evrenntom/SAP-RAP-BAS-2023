@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Value Help'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZRPSG_I_User_VH
  as select from I_User
{
  key UserID as UserId
}
where UserID = $session.user
