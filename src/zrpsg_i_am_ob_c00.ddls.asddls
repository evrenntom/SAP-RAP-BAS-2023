@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Objekt type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZRPSG_I_AM_OB_C00
  as select from zrpsg_am_ob_c00
  association [1..1] to ZRPSG_I_AM_OB_C01 as _AllowedTables on $projection.TableName = _AllowedTables.TableName
{
  key objekt_type         as ObjektType,
      description         as Description,
      table_name          as TableName,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      //ETag field for ACTIVE version (etag master)
      lastchange_time     as LastchangeTime,
      @Semantics.systemDateTime.lastChangedAt: true
      //ETag field for DRAFT version (total etag)
      all_lastchange_time as AllLastchangeTime,
      
      _AllowedTables  
}
