@EndUserText.label: 'Agreement Version Status'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZRPSG_C_AM_VS_C00 
as projection on ZRPSG_I_AM_VS_C00 
{
    key VersionStatus,
    Description
}
