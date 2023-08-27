@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agrement Interface View'

@Metadata.allowExtensions: true

define root view entity ZRPSG_I_AM
  as select from zrpsg_am as am
  composition [1..*] of ZRPSG_I_AM_VS as _vs
//  association [1..1] to ZTEST_I_AM_PA as _PA on $projection.PartnerNum = _PA.PartnerNum
  association [1..1] to ZRPSG_I_AM_PA as _PA on $projection.PartnerNum = _PA.PartnerNum
  association [1..1] to ZRPSG_I_AM_C00_VH  as _AMElementType on $projection.AgreementType = _AMElementType.AgreementType
{
  key am.num                 as Num,
      am.partner_num         as PartnerNum,
      am.agreement_type      as AgreementType,
      
      am.title               as Title,
      am.status              as Status,
      am.date_from           as DateFrom,
      am.date_to             as DateTo,
      @Semantics.user.createdBy: true
      am.creation_user       as CreationUser,
      @Semantics.systemDateTime.createdAt: true
      am.creation_time       as CreationTime,
      @Semantics.user.localInstanceLastChangedBy: true
      am.lastchange_user     as LastchangeUser,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      //ETag field for ACTIVE version (etag master)
      am.lastchange_time     as LastchangeTime,
      @Semantics.systemDateTime.lastChangedAt: true
      //ETag field for DRAFT version (total etag)
      am.all_lastchange_time as AllLastchangeTime,
      @Semantics.language: true
      spras                  as Language,
      _vs,
      _PA,
      _AMElementType
}
