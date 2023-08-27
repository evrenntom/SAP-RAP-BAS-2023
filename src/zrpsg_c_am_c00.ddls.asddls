@EndUserText.label: 'Agreement Type'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZRPSG_C_AM_C00
  provider contract transactional_query 
as projection on ZRPSG_I_AM_C00 
{
    key AgreementType,
    @ObjectModel: { foreignKey.association: '_el_c01' }
    @ObjectModel.text.element: ['ElementTypeGroupDescription']
    ElementTypeGroupNum,
    Description,
    LastchangeUser,
    LastchangeTime,
    AllLastchangeTime,
    _EL_C01_VH.Description as ElementTypeGroupDescription,
    /* Associations */
//    _am,
    _EL_C01
}
