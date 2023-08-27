@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Element Type Group'

@Metadata.allowExtensions: true

define root view entity ZRPSG_I_AM_EL_C01
  as select from zrpsg_am_el_c01
  composition [1..*] of ZRPSG_I_AM_EL_C02 as _EL_C02
{
  key zrpsg_am_el_c01.element_type_group_num as ElementTypeGroupNum,
      zrpsg_am_el_c01.description            as Description,
      @Semantics.user.localInstanceLastChangedBy: true
      zrpsg_am_el_c01.lastchange_user        as LastchangeUser,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      //ETag field for ACTIVE version (etag master)
      zrpsg_am_el_c01.lastchange_time        as LastchangeTime,
      @Semantics.systemDateTime.lastChangedAt: true
      //ETag field for DRAFT version (total etag)
      zrpsg_am_el_c01.all_lastchange_time    as AllLastchangeTime,
      _EL_C02
}
