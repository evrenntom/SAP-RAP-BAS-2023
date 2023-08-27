CLASS lhc_ContractEntity DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING it_keys REQUEST requested_authorizations FOR ContractEntity RESULT result.

    METHODS updateOrCreateContract FOR DETERMINE ON SAVE
      IMPORTING it_keys FOR ContractEntity~updateOrCreateContract.

    METHODS validate_fields " not a validation - its a custom method from me
      IMPORTING is_contract  TYPE zrpsg_c_el_contr
                is_version   TYPE zrpsg_c_am_vs OPTIONAL
                is_agreement TYPE zrpsg_c_am OPTIONAL
      RAISING   zrpsg_cx_error_messages.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ContractEntity RESULT result.

    METHODS setpercentage FOR DETERMINE ON MODIFY
      IMPORTING keys FOR contractentity~setpercentage.

ENDCLASS.

CLASS lhc_ContractEntity IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateOrCreateContract.

*    DATA ls_busvolselcrit_api_scheme TYPE zrpsg_st_am_busvolselcriteria.
*    DATA lv_field_length TYPE i.
*    DATA lv_create_or_update TYPE c LENGTH 1.
*    DATA lt_source_copy_data TYPE zrpsg_tm_copy_data.
*    DATA lt_target_copy_data TYPE zrpsg_tm_copy_data.
*    DATA l_transfer_group TYPE zrpsg_TRANSFER_GROUP.
    DATA lo_create_coco_in_desti TYPE REF TO zrpsg_cl_create_coco_in_desti.
    DATA lv_abort_program TYPE flag.
    DATA lv_contract_number TYPE string.
    DATA lv_destination TYPE string.

    READ ENTITY IN LOCAL MODE zrpsg_i_am
        ALL FIELDS WITH
        VALUE #( FOR ls_key IN it_keys ( %key = ls_key-%key ) )
        RESULT DATA(l_entity_agreement).

    READ ENTITIES OF zrpsg_i_am IN LOCAL MODE
     ENTITY zrpsg_i_am_vs
       ALL FIELDS WITH CORRESPONDING #( it_keys )
     RESULT DATA(l_entity_version)
      FAILED DATA(l_failed_version)
      REPORTED DATA(l_reported_version).

    READ ENTITIES OF zrpsg_i_am IN LOCAL MODE
      ENTITY ContractEntity
        ALL FIELDS WITH CORRESPONDING #( it_keys )
      RESULT DATA(l_entity_contract)
       FAILED DATA(l_failed_contract)
       REPORTED DATA(l_reported_contract).

    TRY.
        CREATE OBJECT lo_create_coco_in_desti.

        LOOP AT l_entity_contract ASSIGNING FIELD-SYMBOL(<ls_entity_contract>).

          READ TABLE l_entity_agreement INDEX sy-tabix ASSIGNING FIELD-SYMBOL(<ls_entity_agreement>).
          READ TABLE l_entity_version INDEX sy-tabix ASSIGNING FIELD-SYMBOL(<ls_entity_version>).
          IF <ls_entity_version>-VersionStatus NE '007'.
            lv_abort_program = abap_true.
            EXIT.
          ENDIF.

          validate_fields( is_contract = CORRESPONDING #( <ls_entity_contract> )
                           is_version = CORRESPONDING #( <ls_entity_version> )
                           is_agreement = CORRESPONDING #( <ls_entity_agreement> ) ).

          lv_destination = 'DSY_subaccount'. " Source of data to be determined

          lo_create_coco_in_desti->prepare_and_send_request( EXPORTING
                                                                is_contract = CORRESPONDING #( <ls_entity_contract> )
                                                                is_version = CORRESPONDING #( <ls_entity_version> )
                                                                is_agreement = CORRESPONDING #( <ls_entity_agreement> )
                                                                iv_destination = lv_destination
                                                             IMPORTING
                                                                ev_contract_number = lv_contract_number
                                                            ).

        ENDLOOP.

        IF lv_abort_program EQ 'X'.
          EXIT.
        ENDIF.

**        " Transfer Manager - pseudocode for later use
***        " transfer group dependent of element type
***            READ TABLE l_entity_contract INDEX 1 ASSIGNING FIELD-SYMBOL(<ls_entity_contract>).
***            IF sy-subrc = 0.
***              IF <ls_entity_contract>-ElementType EQ 'CC01'.
***                l_transfer_group = 'CC01'.
***              ELSEIF <ls_entity_contract>-ElementType EQ 'CC02'.
***                l_transfer_group = 'CC02'.
***              ELSE.
***                l_transfer_group = 'CC00'.
***              ENDIF.
***            ELSE.
**
***        zrpsg_cl_transfer_manager=>transfer(
***                        exporting
***                            it_source_copy_data = lt_source_copy_data
***                            i_transfer_group = l_transfer_group
***                            i_transfer_event = 'C1'
***                        changing
***                            ct_target_copy_data = lt_target_copy_data
***                            ).
*

      CATCH zrpsg_cx_error_messages INTO DATA(lo_error).

        APPEND VALUE #( %tky                    = <ls_entity_contract>-%tky
                        %element-coconum        = if_abap_behv=>mk-on
                        %msg                    = lo_error
*                          NEW zrpsg_cx_error_messages( i_textid   = zrpsg_cx_error_messages=>error_client_create
*                                                       i_severity = if_abap_behv_message=>severity-error )
                    ) TO reported-contractentity.

    ENDTRY.

    IF l_entity_contract IS NOT INITIAL.
      MODIFY ENTITY IN LOCAL MODE zrpsg_i_am\\ContractEntity
          UPDATE FIELDS ( CocoNum )
          WITH VALUE #( FOR ls_el_contr IN l_entity_contract ( %tky   = ls_el_contr-%tky
                                                              CocoNum = lv_contract_number ) ).
*        REPORTED DATA(lv_update_reported).
    ENDIF.
*    reported = CORRESPONDING #( DEEP lv_update_reported ).

  ENDMETHOD.

  METHOD validate_fields.

    IF is_contract-HeaderText = 'ERROR'.
      RAISE EXCEPTION TYPE zrpsg_cx_error_messages
        EXPORTING
          i_textid   = zrpsg_cx_error_messages=>error_contract_field
          i_attr1    = 'HeaderText'
          i_severity = if_abap_behv_message=>severity-error.
    ENDIF.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zrpsg_i_am IN LOCAL MODE
      ENTITY ContractEntity
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_el_contr)
      FAILED failed.

    LOOP AT lt_el_contr INTO DATA(ls_el_contr).
      APPEND VALUE #( %tky            = ls_el_contr-%tky
                      %field-Currency = COND #( WHEN ls_el_contr-CalcType = 'A'
                                                THEN if_abap_behv=>fc-f-read_only ELSE if_abap_behv=>fc-f-unrestricted )
                      %field-Amount = COND #( WHEN ls_el_contr-CalcType = 'A'
                                              THEN if_abap_behv=>fc-f-read_only ELSE if_abap_behv=>fc-f-unrestricted )
                      %field-AmountPer = COND #( WHEN ls_el_contr-CalcType = 'B' OR ls_el_contr-CalcType = 'C'
                                                 THEN if_abap_behv=>fc-f-read_only ELSE if_abap_behv=>fc-f-unrestricted )
                      %field-PricingUnit = COND #( WHEN ls_el_contr-CalcType = 'A' OR ls_el_contr-CalcType = 'B'
                                                   THEN if_abap_behv=>fc-f-read_only ELSE if_abap_behv=>fc-f-unrestricted )
                      %field-Unit = COND #( WHEN ls_el_contr-CalcType = 'A' OR ls_el_contr-CalcType = 'B'
                                            THEN if_abap_behv=>fc-f-read_only ELSE if_abap_behv=>fc-f-unrestricted )
        ) TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD setPercentage.

    READ ENTITIES OF zrpsg_i_am IN LOCAL MODE
      ENTITY ContractEntity
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_el_contr).

    DELETE lt_el_contr WHERE CalcType NE 'A' AND Percentage IS NOT INITIAL.
    IF lt_el_contr IS INITIAL.
      RETURN.
    ENDIF.

    MODIFY ENTITIES OF zrpsg_i_am IN LOCAL MODE
      ENTITY ContractEntity
        UPDATE FIELDS ( Percentage )
        WITH VALUE #( FOR ls_el_contr IN lt_el_contr ( %tky       = ls_el_contr-%tky
                                                       Percentage = '%' ) )
    REPORTED DATA(update_reported).
    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

ENDCLASS.
