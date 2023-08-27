@EndUserText.label: 'Agreement Type'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_AgreementType
  as select from ZRPSG_AM_C00
  association to parent ZI_AgreementType_S as _AgreementTypeAll on $projection.SingletonID = _AgreementTypeAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key AGREEMENT_TYPE as AgreementType,
  ELEMENT_TYPE_GROUP_NUM as ElementTypeGroupNum,
  DESCRIPTION as Description,
  CONFIGDEPRECATIONCODE as ConfigDeprecationCode,
  @Semantics.systemDateTime.lastChangedAt: true
  LASTCHANGE_TIME as LastchangeTime,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LASTCHANGE_TIME_LOCAL as LastchangeTimeLocal,
  1 as SingletonID,
  _AgreementTypeAll,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
