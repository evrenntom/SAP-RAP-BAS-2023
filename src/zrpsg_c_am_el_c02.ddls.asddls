@EndUserText.label: 'Element Type Group Assignment'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define view entity ZRPSG_C_AM_EL_C02 
as projection on ZRPSG_I_AM_EL_C02 
{   
    key ElementTypeGroupNum,
    @ObjectModel: { foreignKey.association: '_el_c00' }
    @ObjectModel.text.element: ['ElementTypeText']
    key ElementType,
    ElementLevel,
    SortOrder,
    Chapter,
    LastchangeUser,
    LastchangeTime,
    AllLastchangeTime,
    _el_c00_vh.Description as ElementTypeText,
    /* Associations */
    _el_c00 : redirected to ZRPSG_C_AM_EL_C00,
    _el_c01 : redirected to parent ZRPSG_C_AM_EL_C01
}
