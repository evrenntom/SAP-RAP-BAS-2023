CLASS zrpsg_cl_create_coco_in_desti DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.
    METHODS prepare_and_send_request
      IMPORTING is_contract        TYPE zrpsg_c_el_contr OPTIONAL
                is_version         TYPE zrpsg_c_am_vs OPTIONAL
                is_agreement       TYPE zrpsg_c_am OPTIONAL
                iv_destination     TYPE string
      EXPORTING ev_contract_number TYPE string
      RAISING   zrpsg_cx_error_messages.

    METHODS fill_coco_structure
      IMPORTING is_contract  TYPE zrpsg_c_el_contr OPTIONAL
                is_version   TYPE zrpsg_c_am_vs OPTIONAL
                is_agreement TYPE zrpsg_c_am OPTIONAL.

    METHODS determine_http_method
      IMPORTING is_contract  TYPE zrpsg_c_el_contr OPTIONAL.

  PRIVATE SECTION.
    DATA mv_service_url TYPE string.
    DATA mv_http_method TYPE string. " POST or PATCH
    DATA ms_api_scheme_contract TYPE zrpsg_st_am_contract.
    DATA mv_contract_json_string TYPE string.

ENDCLASS.



CLASS ZRPSG_CL_CREATE_COCO_IN_DESTI IMPLEMENTATION.

  METHOD constructor.
    mv_service_url = zif_import_tool_constants=>mc_service_url_cc.
  ENDMETHOD.

  METHOD prepare_and_send_request.

    DATA go_send_request_to_desti TYPE REF TO zrpsg_cl_send_request_to_desti.
    CREATE OBJECT go_send_request_to_desti.

    fill_coco_structure( EXPORTING
                            is_contract = is_contract
                            is_version = is_version
                            is_agreement = is_agreement ).

    determine_http_method(  ). " sets mv_http_method (PATCH or POST in this case. We don't need GET for our service currently.)

    go_send_request_to_desti->build_and_send_request( EXPORTING
                                                        iv_uri_path = mv_service_url
                                                        iv_json_payload_string = mv_contract_json_string
                                                        iv_http_method = mv_http_method
                                                        iv_destination = iv_destination
                                                      IMPORTING
                                                        ev_contract_number = ev_contract_number ).
  ENDMETHOD.

    METHOD fill_coco_structure.

    IF is_version IS NOT INITIAL.
      ms_api_scheme_contract-_cndn_contr_valid_from = is_version-datefrom.
      ms_api_scheme_contract-_cndn_contr_valid_to = is_version-dateto.
    ELSE.
      " ToDo!
    ENDIF.

    IF is_agreement IS NOT INITIAL.
      ms_api_scheme_contract-_supplier = is_agreement-PartnerNum.
    ELSE.
      " ToDo
    ENDIF.

    ms_api_scheme_contract-_cndn_contr_valid_from = '20220101'.
    ms_api_scheme_contract-_cndn_contr_valid_to = '20221231'.
    ms_api_scheme_contract-_cndn_contr_type = 'SFIX'. " <ls_entity_contract>-contract_type
    ms_api_scheme_contract-_cndn_contr_proc_var = 'S000'. " <ls_entity_contract>-process_variant
    ms_api_scheme_contract-_purchasing_organization = '0001'.
    ms_api_scheme_contract-_purchasing_group = '001'. "
    ms_api_scheme_contract-_company_code = '0001'.

    APPEND INITIAL LINE TO ms_api_scheme_contract-associationrecord ASSIGNING FIELD-SYMBOL(<ls_conditions>).

*    ms_api_scheme_condition-_condition_calculation_type = ms_api_scheme_contract-CalcType.
*    ms_api_scheme_condition-_condition_rate_amount = ms_api_scheme_contract-Amount.
*    ms_api_scheme_condition-_condition_currency = ms_api_scheme_contract-Currency.

    <ls_conditions>-_condition_table = '4AB'.
    <ls_conditions>-_condition_Application = 'M'.
    <ls_conditions>-_condition_type = 'FIXV'.
    <ls_conditions>-_condition_validity_start_date = ms_api_scheme_contract-_cndn_contr_valid_from.
    <ls_conditions>-_condition_validity_end_date = ms_api_scheme_contract-_cndn_contr_valid_to.
    <ls_conditions>-_condition_Calculation_Type = 'A'.
    <ls_conditions>-_condition_Rate_Amount = 0.
    <ls_conditions>-_condition_Accruals_Amount = 0.
    <ls_conditions>-_condition_Rate_Ratio = 10.
    <ls_conditions>-_condition_Accruals_Ratio = 0.
    <ls_conditions>-_condition_Rate_Ratio_Unit = '%'.
    <ls_conditions>-conditionquantityunitisocode = 'P1'.
    <ls_conditions>-conditionquantityunitsapcode = '%'.
    <ls_conditions>-_condition_Quantity = 10.
    <ls_conditions>-_condition_quantity_unit = 'TO'.
    <ls_conditions>-_pricing_scale_basis  = 'A'.

    APPEND INITIAL LINE TO ms_api_scheme_contract-associationcriteria ASSIGNING FIELD-SYMBOL(<ls_busvolselcriteria>).
    <ls_busvolselcriteria>-_bus_vol_field_combn_type = 'BVVE'.
    <ls_busvolselcriteria>-_cndn_contr_bus_vol_sign = 'I'.
    <ls_busvolselcriteria>-_bus_vol_selection_group = ''.
    <ls_busvolselcriteria>-_product = '32'.
    <ls_busvolselcriteria>-_supplier = '100000'.
    <ls_busvolselcriteria>-_purchasing_organization = '0001'.
    <ls_busvolselcriteria>-_purchasing_group = '001'.

    APPEND INITIAL LINE TO ms_api_scheme_contract-associationcriteria ASSIGNING <ls_busvolselcriteria>.
    <ls_busvolselcriteria>-_bus_vol_field_combn_type = 'BVVE'.
    <ls_busvolselcriteria>-_cndn_contr_bus_vol_sign = 'I'.
    <ls_busvolselcriteria>-_bus_vol_selection_group = ''.
    <ls_busvolselcriteria>-_product = '33'.
    <ls_busvolselcriteria>-_supplier = '100000'.
    <ls_busvolselcriteria>-_purchasing_organization = '0001'.
    <ls_busvolselcriteria>-_purchasing_group = '001'.

    " #. Serializing of scheme structure to JSON to send it to the ERP afterwards
    mv_contract_json_string = /ui2/cl_json=>serialize( data = ms_api_scheme_contract
                                                       pretty_name = 'X').

    REPLACE 'associationcriteria' IN mv_contract_json_string WITH '_CndnContrBusVolSelCriteria'.
    REPLACE 'associationrecord' IN mv_contract_json_string WITH '_CndnContrCndnRecord'.

    REPLACE 'conditionquantityunitisocode' IN mv_contract_json_string WITH 'ConditionQuantityUnitISOCode'.
    REPLACE 'conditionquantityunitsapcode' IN mv_contract_json_string WITH 'ConditionQuantityUnitSAPCode'.

  ENDMETHOD.

    METHOD determine_http_method.
    " #. SET HTTP-METHOD
    IF is_contract-CocoNum IS NOT INITIAL.
      mv_http_method = 'PATCH'.
    ELSE.
      mv_http_method = 'POST'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
