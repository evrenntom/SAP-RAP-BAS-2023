@EndUserText.label: 'Element Type Group'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define root view entity ZRPSG_C_AM_EL_C01 
provider contract transactional_query 
as projection on ZRPSG_I_AM_EL_C01 
{
    
    key ElementTypeGroupNum,
    Description,
    LastchangeUser,
    LastchangeTime,
    AllLastchangeTime,
    /* Associations */
    _EL_C02 : redirected to composition child ZRPSG_C_AM_EL_C02
}
