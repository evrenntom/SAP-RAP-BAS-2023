CLASS lhc_ZRPSG_I_AM_PS_C00 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS state_area_precheck_delete TYPE string VALUE 'PRECHECK_DELETE'.

    TYPES:
      s_person_role       TYPE STRUCTURE FOR READ RESULT zrpsg_i_am_ps_c00\\zrpsg_i_am_ps_c00,
      t_failed_per_role   TYPE TABLE FOR FAILED EARLY zrpsg_i_am_ps_c00\\zrpsg_i_am_ps_c00,
      t_reported_per_role TYPE TABLE FOR REPORTED EARLY zrpsg_i_am_ps_c00\\zrpsg_i_am_ps_c00.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrpsg_i_am_ps_c00 RESULT result.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE zrpsg_i_am_ps_c00.

    METHODS add_to_failed_reported
      IMPORTING is_person_role       TYPE s_person_role
      CHANGING  ct_failed_per_role   TYPE t_failed_per_role
                ct_reported_per_role TYPE t_reported_per_role.

ENDCLASS.

CLASS lhc_ZRPSG_I_AM_PS_C00 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD precheck_delete.

    DATA: lt_person_ag_v   TYPE STANDARD TABLE OF zrpsg_am_vs_ps,
          lt_person_ag_v_d TYPE STANDARD TABLE OF zrpsg_dam_vs_ps.

    "select person agreement version assignments for the roles to delete
    SELECT FROM zrpsg_am_vs_ps FIELDS person_num, num, version_num, role
     FOR ALL ENTRIES IN @keys
     WHERE role EQ @keys-Role
     INTO CORRESPONDING FIELDS OF TABLE @lt_person_ag_v.

    "select person agreement version assignment drafts for the roles to delete
    SELECT FROM zrpsg_dam_vs_ps FIELDS personnum, num, versionnum, role
     FOR ALL ENTRIES IN @keys
     WHERE role EQ @keys-Role
     INTO CORRESPONDING FIELDS OF TABLE @lt_person_ag_v_d.

    "if no data found exit
    IF lt_person_ag_v   IS INITIAL AND
       lt_person_ag_v_d IS INITIAL.
      RETURN.
    ENDIF.

    SORT lt_person_ag_v BY role.
    SORT lt_person_ag_v_d BY role.

    "check if the roles to delete are used in the assignments
    READ ENTITIES OF zrpsg_i_am_ps_c00 IN LOCAL MODE
      ENTITY zrpsg_i_am_ps_c00
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_person_roles).

    LOOP AT lt_person_roles INTO DATA(ls_person_role).
      "check against active instances
      READ TABLE lt_person_ag_v TRANSPORTING NO FIELDS
        WITH KEY role = ls_person_role-Role BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_person_role       = ls_person_role
                                CHANGING  ct_failed_per_role   = failed-zrpsg_i_am_ps_c00
                                          ct_reported_per_role = reported-zrpsg_i_am_ps_c00 ).
        CONTINUE.
      ENDIF.
      "check against drafts
      READ TABLE lt_person_ag_v_d TRANSPORTING NO FIELDS
        WITH KEY role = ls_person_role-Role BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_person_role       = ls_person_role
                                CHANGING  ct_failed_per_role   = failed-zrpsg_i_am_ps_c00
                                          ct_reported_per_role = reported-zrpsg_i_am_ps_c00 ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD add_to_failed_reported.
    APPEND VALUE #( %tky = is_person_role-%tky ) TO ct_failed_per_role.
    APPEND VALUE #(
                    %tky        = is_person_role-%tky
                    %state_area = state_area_precheck_delete
                    %msg        = NEW zrpsg_cx_error_messages( i_textid   = zrpsg_cx_error_messages=>delete_dependency
                                                               i_attr1    = CONV #( is_person_role-Role )
                                                               i_severity = if_abap_behv_message=>severity-error )
                    %delete     = if_abap_behv=>mk-on
                 ) TO ct_reported_per_role.
  ENDMETHOD.

ENDCLASS.
