@EndUserText.label: 'Agreement Type Singleton - Maintain'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_AgreementType_S
  provider contract transactional_query
  as projection on ZI_AgreementType_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _AgreementType : redirected to composition child ZC_AgreementType
  
}
