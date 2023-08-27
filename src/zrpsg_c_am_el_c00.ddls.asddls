@EndUserText.label: 'Element Type'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define root view entity ZRPSG_C_AM_EL_C00 
as projection on ZRPSG_I_AM_EL_C00 
{
    key ElementType, 
    Description,
    @ObjectModel: { foreignKey.association: '_OB_C00' }
    @ObjectModel.text.element: ['ObjectTypeDescription']
    ObjektType,
    LastchangeUser,
    LastchangeTime,
    AllLastchangeTime,
    /* Associations */
    _am_el,
    _el_c02,
    _vs_el,
    _OB_C00_VH.Description as ObjectTypeDescription,
    _OB_C00
}
