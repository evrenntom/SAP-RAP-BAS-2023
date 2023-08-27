@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Element Type'

@Metadata.allowExtensions: true

define root view entity ZRPSG_I_AM_EL_C00
  as select from zrpsg_am_el_c00
  association [0..*] to ZRPSG_I_AM_EL_C02 as _el_c02 on $projection.ElementType = _el_c02.ElementType
  association [0..*] to ZRPSG_I_AM_EL     as _am_el  on $projection.ElementType = _am_el.ElementType
  association [0..*] to ZRPSG_I_AM_VS_EL  as _vs_el  on $projection.ElementType = _vs_el.ElementType
  association [0..1] to ZRPSG_I_AM_OB_C00 as _OB_C00 on $projection.ObjektType = _OB_C00.ObjektType
  association [0..1] to ZRPSG_I_AM_OB_C00_VH as _OB_C00_VH on $projection.ObjektType = _OB_C00_VH.ObjektType
{
  key zrpsg_am_el_c00.element_type        as ElementType,
      zrpsg_am_el_c00.description         as Description,
      zrpsg_am_el_c00.objekt_type         as ObjektType,
      @Semantics.user.localInstanceLastChangedBy: true
      zrpsg_am_el_c00.lastchange_user     as LastchangeUser,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      //ETag field for ACTIVE version (etag master)
      zrpsg_am_el_c00.lastchange_time     as LastchangeTime,
      @Semantics.systemDateTime.lastChangedAt: true
      //ETag field for DRAFT version (total etag)
      zrpsg_am_el_c00.all_lastchange_time as AllLastchangeTime,

      _el_c02,
      _am_el,
      _vs_el,
      _OB_C00,
      _OB_C00_VH
}
