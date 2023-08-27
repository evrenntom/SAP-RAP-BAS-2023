@EndUserText.label: 'Element overview'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define root view entity ZRPSG_C_AM_VS_EL_OVERVIEW 
provider contract transactional_query
  as projection on ZRPSG_I_AM_VS_EL_Overview
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
    _am : redirected to ZRPSG_C_AM,
    _EL_C00 : redirected to ZRPSG_C_AM_EL_C00,
    _vs : redirected to ZRPSG_C_AM_VS,
    _contr : redirected to ZRPSG_C_EL_CONTR
//    _el_contr : redirected to ZRPSG_C_EL_CONTR
}
 