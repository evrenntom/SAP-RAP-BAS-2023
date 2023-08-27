CLASS lhc_ZRPSG_I_AM_C00 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS state_area_precheck_delete TYPE string VALUE 'PRECHECK_DELETE'.

    TYPES:
      s_ag_type          TYPE STRUCTURE FOR READ RESULT zrpsg_i_am_c00\\zrpsg_i_am_c00,
      t_failed_ag_type   TYPE TABLE FOR FAILED EARLY zrpsg_i_am_c00\\zrpsg_i_am_c00,
      t_reported_ag_type TYPE TABLE FOR REPORTED EARLY zrpsg_i_am_c00\\zrpsg_i_am_c00.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrpsg_i_am_c00 RESULT result.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE zrpsg_i_am_c00.

    METHODS add_to_failed_reported
      IMPORTING is_ag_type          TYPE s_ag_type
      CHANGING  ct_failed_ag_type   TYPE t_failed_ag_type
                ct_reported_ag_type TYPE t_reported_ag_type.

ENDCLASS.

CLASS lhc_ZRPSG_I_AM_C00 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD precheck_delete.

    DATA: lt_agreements TYPE STANDARD TABLE OF zrpsg_am,
          lt_ag_drafts  TYPE STANDARD TABLE OF zrpsg_dam.

    "select agreements for the agreement types to delete
    SELECT FROM zrpsg_am FIELDS num, agreement_type
     FOR ALL ENTRIES IN @keys
     WHERE agreement_type EQ @keys-AgreementType
     INTO CORRESPONDING FIELDS OF TABLE @lt_agreements.
    "select agreement drafts for the agreement types to delete
    SELECT FROM zrpsg_dam FIELDS num, agreementtype
     FOR ALL ENTRIES IN @keys
     WHERE agreementtype EQ @keys-AgreementType
     INTO CORRESPONDING FIELDS OF TABLE @lt_ag_drafts.
    "if no data found exit
    IF lt_agreements IS INITIAL AND
       lt_ag_drafts  IS INITIAL.
      RETURN.
    ENDIF.

    SORT lt_agreements BY agreement_type.
    SORT lt_ag_drafts BY agreementtype.

    "check if the agreement types to delete are used in the agreements
    READ ENTITIES OF zrpsg_i_am_c00 IN LOCAL MODE
      ENTITY zrpsg_i_am_c00
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_ag_types).

    LOOP AT lt_ag_types INTO DATA(ls_ag_type).
      "check against active instances
      READ TABLE lt_agreements TRANSPORTING NO FIELDS
        WITH KEY agreement_type = ls_ag_type-AgreementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_ag_type          = ls_ag_type
                                CHANGING  ct_failed_ag_type   = failed-zrpsg_i_am_c00
                                          ct_reported_ag_type = reported-zrpsg_i_am_c00 ).
        CONTINUE.
      ENDIF.
      "check against drafts
      READ TABLE lt_ag_drafts TRANSPORTING NO FIELDS
        WITH KEY agreementtype = ls_ag_type-AgreementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_ag_type          = ls_ag_type
                                CHANGING  ct_failed_ag_type   = failed-zrpsg_i_am_c00
                                          ct_reported_ag_type = reported-zrpsg_i_am_c00 ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD add_to_failed_reported.
    APPEND VALUE #( %tky = is_ag_type-%tky ) TO ct_failed_ag_type.
    APPEND VALUE #(
                    %tky        = is_ag_type-%tky
                    %state_area = state_area_precheck_delete
                    %msg        = NEW zrpsg_cx_error_messages( i_textid   = zrpsg_cx_error_messages=>delete_dependency
                                                               i_attr1    = CONV #( is_ag_type-AgreementType )
                                                               i_severity = if_abap_behv_message=>severity-error )
                    %delete     = if_abap_behv=>mk-on
                 ) TO ct_reported_ag_type.
  ENDMETHOD.

ENDCLASS.
