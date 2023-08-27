@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Allowed tables VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel : { resultSet.sizeCategory: #XS } //Value Help as Dropdown List
define view entity ZRPSG_I_ALLOWED_TABLES_VH
  as select from ZRPSG_I_AM_OB_C01
{
      @ObjectModel.text.element: ['Description']
      @UI.textArrangement: #TEXT_LAST
  key TableName,
      @Semantics.text: true
      Description
}
