@EndUserText.label: 'Agreement'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define root view entity ZRPSG_C_AM
  provider contract transactional_query
  as projection on ZRPSG_I_AM
{
  key Num,

      @ObjectModel: { foreignKey.association: '_PA' }
      PartnerNum,
      _PA.Name as PartnerName,
      @ObjectModel.text.element: ['AgreementElementText']
      AgreementType,
      _AMElementType.Description as AgreementElementText,
      Title,
      Status,
      DateFrom,
      DateTo,
      CreationUser,
      CreationTime,
      LastchangeUser,
      LastchangeTime,
      AllLastchangeTime,
      Language,

      /* Associations */
      //    _PA : redirected to ZTEST_C_AM_PA,
      _PA : redirected to ZRPSG_C_AM_PA,
      _vs : redirected to composition child ZRPSG_C_AM_VS
}
