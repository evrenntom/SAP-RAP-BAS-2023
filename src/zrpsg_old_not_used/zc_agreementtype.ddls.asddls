@EndUserText.label: 'Agreement Type - Maintain'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_AgreementType
  as projection on ZI_AgreementType
{
  key AgreementType,
  ElementTypeGroupNum,
  Description,
  @ObjectModel.text.element: [ 'ConfigurationDeprecation_Text' ]
  ConfigDeprecationCode,
  LastchangeTime,
  @Consumption.hidden: true
  LastchangeTimeLocal,
  @Consumption.hidden: true
  SingletonID,
  _AgreementTypeAll : redirected to parent ZC_AgreementType_S,
  ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText.ConfignDeprecationCodeName as ConfigurationDeprecation_Text : localized
  
}
