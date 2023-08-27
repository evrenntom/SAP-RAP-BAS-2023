@EndUserText.label: 'Agreement Element'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define view entity ZRPSG_C_AM_EL 
as projection on ZRPSG_I_AM_EL 
{
    key Num,
    key ElementType,
    key ElementNum,
    Description,
    /* Associations */
    _am : redirected to parent ZRPSG_C_AM,
    _EL_C00 : redirected to ZRPSG_C_AM_EL_C00
}
