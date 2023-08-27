@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agrement Version Element'
define view entity ZRPSG_I_AM_VS_EL
  as select from zrpsg_am_vs_el as el
  association        to parent ZRPSG_I_AM_VS as _vs       on  $projection.Num        = _vs.Num
                                                          and $projection.VersionNum = _vs.VersionNum
  association [1..1] to ZRPSG_I_AM           as _am       on  $projection.Num = _am.Num
  association [1..1] to ZRPSG_I_AM_EL_C00    as _EL_C00   on  $projection.ElementType = _EL_C00.ElementType

  association [0..1] to ZRPSG_I_EL_CONTR     as _EL_CONTR on  $projection.Num        = _EL_CONTR.Num
                                                          and $projection.VersionNum = _EL_CONTR.VersionNum
                                                          and $projection.ElementNum = _EL_CONTR.ElementNum

{
  key el.num          as Num,
  key el.version_num  as VersionNum,
  key el.element_num  as ElementNum,
      el.element_type as ElementType,
      el.description  as Description,
      el.text         as Text,
      el.amount       as Amount,

      el.currency     as Currency,
      _vs,
      _am,
      _EL_C00,
      _EL_CONTR
}

//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Agrement Version Element'
//
////wurden eingefügt das hier sonst ein Fehler entsteht
//@Metadata.ignorePropagatedAnnotations: true
//
//define view entity ZRPSG_I_AM_VS_EL
//as select from ZRPSG_I_EL_CONTR as EL_CONTR
//
//
//association to parent ZRPSG_I_AM_VS as _vs on $projection.Num = _vs.num
//                                          and $projection.VersionNum = _vs.version_num
//association [1..1] to ZRPSG_I_AM as _am on $projection.Num = _am.num
//association [1..1] to ZRPSG_I_AM_EL_C00 as _EL_C00 on $projection.ElementType = _EL_C00.ElementType
//
//
//{
//    key EL_CONTR.Num        as Num,
//    key EL_CONTR.VersionNum as VersionNum,
//    key EL_CONTR.ElementNum as ElementNum,
//    EL_CONTR.ElementType    as ElementType,
//
//    cast( EL_CONTR.CocoNum as zrpsg_am_description ) as  Description,
//    EL_CONTR.HeaderText     as Text,
//
//    0                       as Amount,
//    ''                      as Currency,
//
//    /* Associations */
//    _am,
//    _vs,
//    _EL_C00
//}
//union
//
//select from zrpsg_am_ltext as EL_LTEXT
//
//association to parent ZRPSG_I_AM_VS as _vs on $projection.Num = _vs.num
//                                          and $projection.VersionNum = _vs.version_num
//association [1..1] to ZRPSG_I_AM as _am on $projection.Num = _am.num
//association [1..1] to ZRPSG_I_AM_EL_C00 as _EL_C00 on $projection.ElementType = _EL_C00.ElementType
//
//{
//    key EL_LTEXT.num         as Num,
//    key EL_LTEXT.version_num as VersionNum,
//    key EL_LTEXT.element_num as ElementNum,
//    EL_LTEXT.element_type    as ElementType,
//
//    EL_LTEXT.description     as Description,
//    EL_LTEXT.text            as Text,
//
//    0                       as Amount,
//    ''                      as Currency,
//
//    /* Associations */
//    _am,
//    _vs,
//    _EL_C00
//}
//
////union
////
////select from zrpsg_am_stext as EL_STEXT
////
////association [1..1] to ZRPSG_I_AM_VS as _vs on $projection.Num = _vs.num
////                                          and $projection.VersionNum = _vs.version_num
////association [1..1] to ZRPSG_I_AM as _am on $projection.Num = _am.num
////association [1..1] to ZRPSG_I_AM_EL_C00 as _EL_C00 on $projection.ElementType = _EL_C00.ElementType
////
////{
////    key EL_STEXT.num         as Num,
////    key EL_STEXT.version_num as VersionNum,
////    key EL_STEXT.element_num as ElementNum,
////    EL_STEXT.element_type    as ElementType,
////
////    EL_STEXT.description     as Description,
////    EL_STEXT.text            as Text,
////
////    EL_STEXT.attribute_name as AttributeName,
////    /* Associations */
////    _AM,
////    _VS,
////    _EL_C00
////}
