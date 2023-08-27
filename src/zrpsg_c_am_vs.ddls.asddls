@EndUserText.label: 'Agrement Version'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define view entity ZRPSG_C_AM_VS
  as projection on ZRPSG_I_AM_VS
{
  key Num,

  key VersionNum,
      @ObjectModel.text.element: ['VersionStatusText']
      VersionStatus,
      _VSStatus._Text.Text as VersionStatusText : localized,
      VersionDesc,
      DateFrom,
      DateTo,
      CreationUser,
      CreationTime,
      LastchangeUser,
      LastchangeTime,

      /* Associations */
      _am       : redirected to parent ZRPSG_C_AM,
//      _VS_EL    : redirected to composition child ZRPSG_C_AM_VS_EL,
//      _VS_EL    : redirected to  ZRPSG_C_AM_VS_EL_OVERVIEW,
      _VS_PS    : redirected to composition child ZRPSG_C_AM_VS_PS,
      _EL_CONTR : redirected to composition child ZRPSG_C_EL_CONTR,
      _EL_LTEXT : redirected to composition child ZRPSG_C_AM_LTEXT,
      _EL_STEXT : redirected to composition child ZRPSG_C_AM_STEXT,
      _VS_PT    : redirected to composition child ZRPSG_C_AM_VS_PT,
      
       _VS_PROT : redirected to composition child ZRPSG_C_AM_VS_Prot
      
}
