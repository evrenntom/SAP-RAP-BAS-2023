@EndUserText.label: 'Abs. Entity for copy version parameter'
define abstract entity ZRPSG_A_AM_COPY_VERSION
{
  //@UI.defaultValue: '20230101' -> not working with dates...
  DateFrom : zrpsg_am_date_from;
  //@UI.defaultValue: '20231231'
  DateTo   : zrpsg_am_date_to;

}
