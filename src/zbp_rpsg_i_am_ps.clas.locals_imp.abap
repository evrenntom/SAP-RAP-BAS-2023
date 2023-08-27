CLASS lhc_ZRPSG_I_AM_PS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS state_area_precheck_delete TYPE string VALUE 'PRECHECK_DELETE'.

    TYPES:
      s_person          TYPE STRUCTURE FOR READ RESULT zrpsg_i_am_ps\\zrpsg_i_am_ps,
      t_failed_person   TYPE TABLE FOR FAILED EARLY zrpsg_i_am_ps\\zrpsg_i_am_ps,
      t_reported_person TYPE TABLE FOR REPORTED EARLY zrpsg_i_am_ps\\zrpsg_i_am_ps.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrpsg_i_am_ps RESULT result.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE zrpsg_i_am_ps.

    METHODS add_to_failed_reported
      IMPORTING is_person          TYPE s_person
      CHANGING  ct_failed_person   TYPE t_failed_person
                ct_reported_person TYPE t_reported_person.

ENDCLASS.

CLASS lhc_ZRPSG_I_AM_PS IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD precheck_delete.

    DATA: lt_person_ag_v   TYPE STANDARD TABLE OF zrpsg_am_vs_ps,
          lt_person_ag_v_d TYPE STANDARD TABLE OF zrpsg_dam_vs_ps.

    "select person agreement version assignments for the persons to delete
    SELECT FROM zrpsg_am_vs_ps FIELDS person_num, num, version_num, role
     FOR ALL ENTRIES IN @keys
     WHERE person_num EQ @keys-PersonNum
     INTO CORRESPONDING FIELDS OF TABLE @lt_person_ag_v.

    "select person agreement version assignment drafts for the persons to delete
    SELECT FROM zrpsg_dam_vs_ps FIELDS personnum, num, versionnum, role
     FOR ALL ENTRIES IN @keys
     WHERE personnum EQ @keys-PersonNum
     INTO CORRESPONDING FIELDS OF TABLE @lt_person_ag_v_d.

    "if no data found exit
    IF lt_person_ag_v   IS INITIAL AND
       lt_person_ag_v_d IS INITIAL.
      RETURN.
    ENDIF.

    SORT lt_person_ag_v BY person_num.
    SORT lt_person_ag_v_d BY personnum.

    "check if the persons to delete are used in the assignments
    READ ENTITIES OF zrpsg_i_am_ps IN LOCAL MODE
      ENTITY zrpsg_i_am_ps
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_persons).

    LOOP AT lt_persons INTO DATA(ls_person).
      "check against active instances
      READ TABLE lt_person_ag_v TRANSPORTING NO FIELDS
        WITH KEY person_num = ls_person-PersonNum BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_person          = ls_person
                                CHANGING  ct_failed_person   = failed-zrpsg_i_am_ps
                                          ct_reported_person = reported-zrpsg_i_am_ps ).
        CONTINUE.
      ENDIF.
      "check against drafts
      READ TABLE lt_person_ag_v_d TRANSPORTING NO FIELDS
        WITH KEY personnum = ls_person-PersonNum BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_person          = ls_person
                                CHANGING  ct_failed_person   = failed-zrpsg_i_am_ps
                                          ct_reported_person = reported-zrpsg_i_am_ps ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD add_to_failed_reported.
    APPEND VALUE #( %tky = is_person-%tky ) TO ct_failed_person.
    APPEND VALUE #(
                    %tky        = is_person-%tky
                    %state_area = state_area_precheck_delete
                    %msg        = NEW zrpsg_cx_error_messages( i_textid   = zrpsg_cx_error_messages=>delete_dependency
                                                               i_attr1    = CONV #( is_person-PersonNum )
                                                               i_severity = if_abap_behv_message=>severity-error )
                    %delete     = if_abap_behv=>mk-on
                 ) TO ct_reported_person.
  ENDMETHOD.

ENDCLASS.
