@EndUserText.label: 'Objekt type'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define root view entity ZRPSG_C_AM_OB_C00
  provider contract transactional_query
  as projection on ZRPSG_I_AM_OB_C00
{
  key ObjektType,
      Description,
      @ObjectModel.text.element: ['TableDescription']
      TableName,
      _AllowedTables.Description as TableDescription,
      LastchangeTime,
      AllLastchangeTime
      
}
