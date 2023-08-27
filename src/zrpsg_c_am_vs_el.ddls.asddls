@EndUserText.label: 'Agreement Version Element'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define view entity ZRPSG_C_AM_VS_EL as projection on ZRPSG_I_AM_VS_EL
{
    key Num,
    key VersionNum,
    key ElementNum,
    ElementType,
    Description,
    Text,
    Amount,
    Currency,
    /* Associations */
    _am: redirected to ZRPSG_C_AM,
    _EL_C00: redirected to ZRPSG_C_AM_EL_C00,
    _vs: redirected to parent ZRPSG_C_AM_VS
}
