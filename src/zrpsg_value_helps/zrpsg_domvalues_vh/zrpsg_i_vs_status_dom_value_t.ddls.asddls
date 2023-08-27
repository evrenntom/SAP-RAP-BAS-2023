@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fixed values of ZRPSG_AM_VS_STATUS texts'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZRPSG_I_VS_STATUS_DOM_VALUE_T
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name : 'ZRPSG_AM_VS_STATUS' )
{
      @ObjectModel.text.element: ['Text']
  key value_low      as Value,
      @Semantics.language: true
  key language       as Language,
      @Semantics.text: true
      text           as Text

}
