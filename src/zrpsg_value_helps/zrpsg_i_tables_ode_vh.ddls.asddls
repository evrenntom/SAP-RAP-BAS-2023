@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tables from Object Directory Entry VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZRPSG_I_TABLES_ODE_VH
  as select from I_CustABAPObjDirectoryEntry
{
      @UI.hidden
  key ABAPObjectCategory,
      @UI.hidden
  key ABAPObjectType,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
  key ABAPObject,
      ABAPPackage,
      ABAPSoftwareComponent,
      ABAPObjectResponsibleUser
}
where
      ABAPObjectCategory  =    'R3TR'
  and ABAPObjectType      =    'TABL'
  and ABAPObjectIsDeleted is initial
  and ABAPObject          like 'Z%'
