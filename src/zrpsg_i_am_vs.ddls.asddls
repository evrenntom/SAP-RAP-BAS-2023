@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agrement Version Interface View'
define view entity ZRPSG_I_AM_VS
  as select from zrpsg_am_vs as vs

  association        to parent ZRPSG_I_AM         as _am    on  $projection.Num = _am.Num

  composition [1..*] of ZRPSG_I_AM_VS_PS          as _VS_PS
  composition [0..*] of ZRPSG_I_EL_CONTR          as _EL_CONTR
  composition [0..*] of ZRPSG_I_AM_LTEXT          as _EL_LTEXT
  composition [0..*] of ZRPSG_I_AM_STEXT          as _EL_STEXT
  composition [0..*] of ZRPSG_I_AM_VS_PT          as _VS_PT
  
  composition [0..*] of ZRPSG_I_AM_VS_PROT        as _VS_PROT

//  association [0..*] to ZRPSG_I_AM_VS_EL_Overview as _VS_EL on  $projection.Num        = _VS_EL.Num
//                                                            and $projection.VersionNum = _VS_EL.VersionNum

  association [1..1] to ZRPSG_I_VS_STATUS_VH  as _VSStatus on $projection.VersionStatus = _VSStatus.Value                                                          
{
  key vs.num             as Num,
  key vs.version_num     as VersionNum,
      vs.version_status  as VersionStatus,
      vs.version_desc    as VersionDesc,
      vs.date_from       as DateFrom,
      vs.date_to         as DateTo,
      @Semantics.user.createdBy: true
      vs.creation_user   as CreationUser,
      @Semantics.systemDateTime.createdAt: true
      vs.creation_time   as CreationTime,
      @Semantics.user.localInstanceLastChangedBy: true
      vs.lastchange_user as LastchangeUser,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      //ETag field for ACTIVE version (etag master)
      vs.lastchange_time as LastchangeTime,

      _am,
      _VS_PS,
//      _VS_EL,
      _EL_CONTR,
      _EL_LTEXT,
      _EL_STEXT,
      _VS_PT,
      
      _VS_PROT,
            
      _VSStatus
}
