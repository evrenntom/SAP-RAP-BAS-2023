@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agreement Element'
define view entity ZRPSG_I_AM_EL
  as select from zrpsg_am_el
  association        to parent ZRPSG_I_AM as _am     on $projection.Num = _am.Num
  association [1..1] to ZRPSG_I_AM_EL_C00 as _EL_C00 on $projection.ElementType = _EL_C00.ElementType
{
  key num          as Num,
  key element_type as ElementType,
  key element_num  as ElementNum,
      description  as Description,
      _am,
      _EL_C00
}
