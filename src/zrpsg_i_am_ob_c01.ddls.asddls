@EndUserText.label: 'Allowed tables'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZRPSG_I_AM_OB_C01
  as select from zrpsg_am_ob_c01
{
  key table_name            as TableName,
      description           as Description,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt, //ETag field for DRAFT version (total etag)
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt //ETag field for ACTIVE version (etag master)

}
