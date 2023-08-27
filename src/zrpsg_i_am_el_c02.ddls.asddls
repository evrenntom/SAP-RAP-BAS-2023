@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Element Type Group Assignment'

@Metadata.allowExtensions: true

define view entity ZRPSG_I_AM_EL_C02
  as select from zrpsg_am_el_c02
  association        to parent ZRPSG_I_AM_EL_C01 as _el_c01 on $projection.ElementTypeGroupNum = _el_c01.ElementTypeGroupNum
  association [1..1] to ZRPSG_I_AM_EL_C00        as _el_c00 on $projection.ElementType = _el_c00.ElementType
  association [1..1] to ZRPSG_I_AM_EL_C00_VH     as _el_c00_vh on $projection.ElementType = _el_c00_vh.ElementType
{
  key zrpsg_am_el_c02.element_type_group_num as ElementTypeGroupNum,
  key zrpsg_am_el_c02.element_type           as ElementType,
      zrpsg_am_el_c02.el_level               as ElementLevel,
      zrpsg_am_el_c02.sortorder              as SortOrder,
      zrpsg_am_el_c02.chapter                as Chapter,
      @Semantics.user.localInstanceLastChangedBy: true
      zrpsg_am_el_c02.lastchange_user        as LastchangeUser,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      //ETag field for ACTIVE version (etag master)
      zrpsg_am_el_c02.lastchange_time        as LastchangeTime,
      @Semantics.systemDateTime.lastChangedAt: true
      //ETag field for DRAFT version (total etag)
      zrpsg_am_el_c02.all_lastchange_time    as AllLastchangeTime,
      _el_c01,
      _el_c00,
      _el_c00_vh
}
