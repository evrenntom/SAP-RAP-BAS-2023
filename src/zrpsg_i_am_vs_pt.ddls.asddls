@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VS predefined longtext'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRPSG_I_AM_VS_PT
  as select from zrpsg_am_vs_pt
//  association [1..1] to ZRPSG_I_AM_PTEXT     as _PTEXT on $projection.ElementType = _PTEXT.ElementType
  association [1..1] to ZRPSG_I_AM           as _AM on  $projection.Num = _AM.Num
  association        to parent ZRPSG_I_AM_VS as _VS on  $projection.Num        = _VS.Num
                                                    and $projection.VersionNum = _VS.VersionNum
  association [1..1] to ZRPSG_I_ET_PT_VH  as _ElementType on $projection.ElementType = _ElementType.ElementType
  
// association [0..1] to ZRPSG_I_AM_PTEXT as _PTEXT on $projection.ElementType = _PTEXT.ElementType
//                                                 and $projection.Language = _PTEXT.Language
                                            
                                                    
{
  key num                as Num,
  key version_num        as VersionNum,
  key element_num        as ElementNum,
      element_type       as ElementType,
      text               as Text,
//      _AM.Language       as Language,
//      _PTEXT.Text        as Text,
      _AM,
      _VS, 
      _ElementType
//      ,     
//      _PTEXT
}
