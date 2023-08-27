//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Agrement Version Element'
//define view entity ZRPSG_I_AM_VS_EL_Overview
//  as select from zrpsg_am_vs_el as el
//  association        to parent ZRPSG_I_AM_VS as _vs       on  $projection.Num        = _vs.Num
//                                                          and $projection.VersionNum = _vs.VersionNum
//  association [1..1] to ZRPSG_I_AM           as _am       on  $projection.Num = _am.Num
//  association [1..1] to ZRPSG_I_AM_EL_C00    as _EL_C00   on  $projection.ElementType = _EL_C00.ElementType
//
//  association [0..1] to ZRPSG_I_EL_CONTR     as _EL_CONTR on  $projection.Num        = _EL_CONTR.Num
//                                                          and $projection.VersionNum = _EL_CONTR.VersionNum
//                                                          and $projection.ElementNum = _EL_CONTR.ElementNum
//
//{
//  key el.num          as Num,
//  key el.version_num  as VersionNum,
//  key el.element_num  as ElementNum,
//      el.element_type as ElementType,
//      el.description  as Description,
//      el.text         as Text,
//      el.amount       as Amount,
//
//      el.currency     as Currency,
//      _vs,
//      _am,
//      _EL_C00,
//      _EL_CONTR
//}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agrement Version Element'

//wurden eingefügt das hier sonst ein Fehler entsteht
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZRPSG_I_AM_VS_EL_Overview

  as select from ZRPSG_I_EL_CONTR as EL_CONTR

  association [1..1] to ZRPSG_I_EL_CONTR     as _contr  on  $projection.Num        = _contr.Num
                                                        and $projection.VersionNum = _contr.VersionNum
                                                        and $projection.ElementNum = _contr.ElementNum
  association [1..1] to ZRPSG_I_AM           as _am     on  $projection.Num = _am.Num
  association [1..1] to ZRPSG_I_AM_VS        as _vs     on  $projection.Num        = _vs.Num
                                                        and $projection.VersionNum = _vs.VersionNum
  association [1..1] to ZRPSG_I_AM_EL_C00    as _EL_C00 on  $projection.ElementType = _EL_C00.ElementType
{
  key EL_CONTR.Num                                     as Num,
  key EL_CONTR.VersionNum                              as VersionNum,
  key EL_CONTR.ElementNum                              as ElementNum,
      EL_CONTR.ElementType                             as ElementType,

      cast( EL_CONTR.CocoNum as zrpsg_am_description ) as Description,
      EL_CONTR.HeaderText                              as Text,

      0                                                as Amount,
      ''                                               as Currency,

      /* Associations */
      _am,
      _vs,
      _EL_C00,
      _contr
}
union

select from ZRPSG_I_AM_LTEXT as EL_LTEXT

association [1..1] to ZRPSG_I_EL_CONTR     as _contr  on  $projection.Num        = _contr.Num
                                                      and $projection.VersionNum = _contr.VersionNum
                                                      and $projection.ElementNum = _contr.ElementNum
association [1..1] to ZRPSG_I_AM           as _am     on  $projection.Num = _am.Num
association [1..1] to ZRPSG_I_AM_VS        as _vs     on  $projection.Num        = _vs.Num
                                                      and $projection.VersionNum = _vs.VersionNum
association [1..1] to ZRPSG_I_AM_EL_C00    as _EL_C00 on  $projection.ElementType = _EL_C00.ElementType
{
  key EL_LTEXT.Num         as Num,
  key EL_LTEXT.VersionNum  as VersionNum,
  key EL_LTEXT.ElementNum  as ElementNum,
      EL_LTEXT.ElementType as ElementType,

      EL_LTEXT.Description as Description,
      EL_LTEXT.Text        as Text,

      0                    as Amount,
      ''                   as Currency,

      /* Associations */
      _am,
      _vs,
      _EL_C00,
      _contr
}

union

select from ZRPSG_I_AM_STEXT as EL_STEXT

association [1..1] to ZRPSG_I_EL_CONTR     as _contr  on  $projection.Num        = _contr.Num
                                                      and $projection.VersionNum = _contr.VersionNum
                                                      and $projection.ElementNum = _contr.ElementNum
association [1..1] to ZRPSG_I_AM           as _am     on  $projection.Num = _am.Num
association [1..1] to ZRPSG_I_AM_VS        as _vs     on  $projection.Num        = _vs.Num
                                                      and $projection.VersionNum = _vs.VersionNum
association [1..1] to ZRPSG_I_AM_EL_C00    as _EL_C00 on  $projection.ElementType = _EL_C00.ElementType
{
  key EL_STEXT.Num         as Num,
  key EL_STEXT.VersionNum  as VersionNum,
  key EL_STEXT.ElementNum  as ElementNum,
      EL_STEXT.ElementType as ElementType,

      EL_STEXT.Description as Description,
      EL_STEXT.Text        as Text,

      0                    as Amount,
      ''                   as Currency,
      /* Associations */
      _am,
      _vs,
      _EL_C00,
      _contr
}
