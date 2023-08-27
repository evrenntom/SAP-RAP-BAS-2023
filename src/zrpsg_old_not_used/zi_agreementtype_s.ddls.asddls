@EndUserText.label: 'Agreement Type Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_AgreementType_S
  as select from I_Language
    left outer join ZRPSG_AM_C00 on 0 = 0
  composition [0..*] of ZI_AgreementType as _AgreementType
{
  key 1 as SingletonID,
  _AgreementType,
  max( ZRPSG_AM_C00.LASTCHANGE_TIME ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
