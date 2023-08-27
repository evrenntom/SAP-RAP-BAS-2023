@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vereinbarungs- Versionsübersicht'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZRPSG_I_vs_AM
  as select from ZRPSG_I_AM_VS as _vs
  association [0..1] to ZRPSG_I_AM as _am on  $projection.Num = _am.Num
{
  key _vs.Num,
  key _vs.VersionNum,
      _vs.VersionStatus,
      _vs.DateFrom,
      _vs.DateTo,
      _vs.CreationUser,
      _vs.CreationTime,
      _vs.LastchangeUser,
      _vs.LastchangeTime,
      _am.AllLastchangeTime,
      /* Associations */
      _vs._am,
      _vs._EL_CONTR,
      _vs._EL_LTEXT,
      _vs._EL_STEXT,
      
////      _vs._VS_PT,
      
      _vs._VSStatus,
//      _vs._VS_EL,
      _vs._VS_PS
}
