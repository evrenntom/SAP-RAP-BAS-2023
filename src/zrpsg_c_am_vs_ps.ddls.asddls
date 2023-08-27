@EndUserText.label: 'Person Agrement Version Assinment'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define view entity ZRPSG_C_AM_VS_PS 
as projection on ZRPSG_I_AM_VS_PS 
{   
//    @ObjectModel: { foreignKey.association: '_PS' }
//    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZRPSG_C_AM_PS', element: 'PersonNum'  },
//     useForValidation: true }]
    @ObjectModel.text.element: ['PersonName']
    key PersonNum,
    key Num,
    key VersionNum,
//    @ObjectModel: { foreignKey.association: '_PS_C00' }
//    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZRPSG_C_AM_PS_C00', element: 'Role'  },
//     useForValidation: true }]
    @ObjectModel.text.element: ['RoleDescription']
    key Role,
    _PS_C00_VH.Description as RoleDescription,
    _PS_VH.Name as PersonName,
    Pname,
    Rdes,
 


    
    /* Associations */
    _vs : redirected to parent ZRPSG_C_AM_VS,
    _am : redirected to ZRPSG_C_AM,
    _PS : redirected to ZRPSG_C_AM_PS,
    _PS_C00 : redirected to ZRPSG_C_AM_PS_C00
    
}
