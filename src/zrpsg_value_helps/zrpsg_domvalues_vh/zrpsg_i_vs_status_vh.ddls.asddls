@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Version Status value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS //Value Help as Dropdown List
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZRPSG_I_VS_STATUS_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name : 'ZRPSG_AM_VS_STATUS' )

  association [0..*] to ZRPSG_I_VS_STATUS_DOM_VALUE_T as _Text on $projection.Value = _Text.Value
{
      @ObjectModel.text.association: '_Text'
  key value_low as Value,
  
      _Text
}
