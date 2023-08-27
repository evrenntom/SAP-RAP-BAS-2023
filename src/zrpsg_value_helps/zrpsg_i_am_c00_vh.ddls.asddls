@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agreement type value help'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRPSG_I_AM_C00_VH 
    as select from ZRPSG_I_AM_C00
{
    key AgreementType,
    ElementTypeGroupNum,
    Description,
    Configdeprecationcode,
    LastchangeUser,
    LastchangeTime,
    AllLastchangeTime
}
