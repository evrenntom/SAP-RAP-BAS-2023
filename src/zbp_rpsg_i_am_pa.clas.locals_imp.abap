CLASS lhc_ZRPSG_I_AM_PA DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS state_area_precheck_delete TYPE string VALUE 'PRECHECK_DELETE'.

    TYPES:
      s_partner          TYPE STRUCTURE FOR READ RESULT zrpsg_i_am_pa\\zrpsg_i_am_pa,
      t_failed_partner   TYPE TABLE FOR FAILED EARLY zrpsg_i_am_pa\\zrpsg_i_am_pa,
      t_reported_partner TYPE TABLE FOR REPORTED EARLY zrpsg_i_am_pa\\zrpsg_i_am_pa.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrpsg_i_am_pa RESULT result.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE zrpsg_i_am_pa.

    METHODS add_to_failed_reported
      IMPORTING is_partner          TYPE s_partner
      CHANGING  ct_failed_partner   TYPE t_failed_partner
                ct_reported_partner TYPE t_reported_partner.

ENDCLASS.

CLASS lhc_ZRPSG_I_AM_PA IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD precheck_delete.

    DATA: lt_agreements   TYPE STANDARD TABLE OF zrpsg_am,
          lt_agreements_d TYPE STANDARD TABLE OF zrpsg_dam.

    "select agreements for the partners to delete
    SELECT FROM zrpsg_am FIELDS num, partner_num
     FOR ALL ENTRIES IN @keys
     WHERE partner_num EQ @keys-PartnerNum
     INTO CORRESPONDING FIELDS OF TABLE @lt_agreements.

    "select agreements drafts for the partners to delete
    SELECT FROM zrpsg_dam FIELDS num, partnernum
     FOR ALL ENTRIES IN @keys
     WHERE partnernum EQ @keys-PartnerNum
     INTO CORRESPONDING FIELDS OF TABLE @lt_agreements_d.

    "if no data found exit
    IF lt_agreements   IS INITIAL AND
       lt_agreements_d IS INITIAL.
      RETURN.
    ENDIF.

    SORT lt_agreements BY partner_num.
    SORT lt_agreements_d BY partnernum.

    "check if the partners to delete are used in the agreements
    READ ENTITIES OF zrpsg_i_am_pa IN LOCAL MODE
      ENTITY zrpsg_i_am_pa
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_partners).

    LOOP AT lt_partners INTO DATA(ls_partner).
      "check against active instances
      READ TABLE lt_agreements TRANSPORTING NO FIELDS
        WITH KEY partner_num = ls_partner-PartnerNum BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_partner          = ls_partner
                                CHANGING  ct_failed_partner   = failed-zrpsg_i_am_pa
                                          ct_reported_partner = reported-zrpsg_i_am_pa ).
        CONTINUE.
      ENDIF.
      "check against drafts
      READ TABLE lt_agreements_d TRANSPORTING NO FIELDS
        WITH KEY partnernum = ls_partner-PartnerNum BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_partner          = ls_partner
                                CHANGING  ct_failed_partner   = failed-zrpsg_i_am_pa
                                          ct_reported_partner = reported-zrpsg_i_am_pa ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD add_to_failed_reported.
    APPEND VALUE #( %tky = is_partner-%tky ) TO ct_failed_partner.
    APPEND VALUE #(
                    %tky        = is_partner-%tky
                    %state_area = state_area_precheck_delete
                    %msg        = NEW zrpsg_cx_error_messages( i_textid   = zrpsg_cx_error_messages=>delete_dependency
                                                               i_attr1    = CONV #( is_partner-PartnerNum )
                                                               i_severity = if_abap_behv_message=>severity-error )
                    %delete     = if_abap_behv=>mk-on
                 ) TO ct_reported_partner.
  ENDMETHOD.

ENDCLASS.
