@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agreement Type'
define root view entity ZRPSG_I_AM_C00
  as select from zrpsg_am_c00
  //association [0..*] to ZRPSG_I_AM as _am on $projection.AgreementType = _am.AgreementType
  association [1..1] to ZRPSG_I_AM_EL_C01 as _EL_C01 on $projection.ElementTypeGroupNum = _EL_C01.ElementTypeGroupNum
  association [1..1] to ZRPSG_I_AM_EL_C01_VH as _EL_C01_VH on $projection.ElementTypeGroupNum = _EL_C01_VH.ElementTypeGroupNum
  
{
  key zrpsg_am_c00.agreement_type         as AgreementType,
      zrpsg_am_c00.element_type_group_num as ElementTypeGroupNum,
      zrpsg_am_c00.description            as Description,
      zrpsg_am_c00.configdeprecationcode  as Configdeprecationcode,
      zrpsg_am_c00.lastchange_user        as LastchangeUser,
      zrpsg_am_c00.lastchange_time        as LastchangeTime,
      zrpsg_am_c00.lastchange_time_local  as AllLastchangeTime,
      //    _am,
      _EL_C01,
      _EL_C01_VH
}
