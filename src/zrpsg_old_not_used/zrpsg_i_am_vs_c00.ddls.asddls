@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agreement Version Status'
define root view entity ZRPSG_I_AM_VS_C00
  as select from zrpsg_am_vs_c00
  association [1..*] to ZRPSG_I_AM_VS as _vs_st on $projection.VersionStatus = _vs_st.VersionStatus
{
  key version_status as VersionStatus,
      description    as Description
}
