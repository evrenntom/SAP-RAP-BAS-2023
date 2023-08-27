@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'person Agreement Version Assinment'
define view entity ZRPSG_I_AM_VS_PS
  as select from zrpsg_am_vs_ps as ps
  association        to parent ZRPSG_I_AM_VS as _vs        on  $projection.Num        = _vs.Num
                                                           and $projection.VersionNum = _vs.VersionNum
  association [1]    to ZRPSG_I_AM           as _am        on  $projection.Num = _am.Num

  association [1..1] to ZRPSG_I_AM_PS_C00    as _PS_C00    on  $projection.Role = _PS_C00.Role
  association [0..1] to ZRPSG_I_AM_PS_C00_VH as _PS_C00_VH on  $projection.Role = _PS_C00_VH.Role

  association [0..1] to ZRPSG_I_AM_PS        as _PS        on  $projection.PersonNum = _PS.PersonNum
  association [0..1] to ZRPSG_I_AM_PS_VH     as _PS_VH     on  $projection.PersonNum = _PS_VH.PersonNum
{
  key person_num  as PersonNum,
  key num         as Num,
  key version_num as VersionNum,
  key role        as Role,

      pname       as Pname,
      rdes        as Rdes,

      _am,
      _vs,
      _PS,
      _PS_C00,
      _PS_C00_VH,
      _PS_VH
}
