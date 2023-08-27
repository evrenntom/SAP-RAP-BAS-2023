CLASS lhc_ZRPSG_I_AM_EL_C01 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS state_area_precheck_delete TYPE string VALUE 'PRECHECK_DELETE'.

    TYPES:
      s_elem_type_group     TYPE STRUCTURE FOR READ RESULT zrpsg_i_am_el_c01\\zrpsg_i_am_el_c01,
      t_failed_el_type_gr   TYPE TABLE FOR FAILED EARLY zrpsg_i_am_el_c01\\zrpsg_i_am_el_c01,
      t_reported_el_type_gr TYPE TABLE FOR REPORTED EARLY zrpsg_i_am_el_c01\\zrpsg_i_am_el_c01.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrpsg_i_am_el_c01 RESULT result.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE zrpsg_i_am_el_c01.

    METHODS add_to_failed_reported
      IMPORTING is_elem_type_group     TYPE s_elem_type_group
      CHANGING  ct_failed_el_type_gr   TYPE t_failed_el_type_gr
                ct_reported_el_type_gr TYPE t_reported_el_type_gr.

ENDCLASS.

CLASS lhc_ZRPSG_I_AM_EL_C01 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD precheck_delete.

    DATA: lt_ag_types       TYPE STANDARD TABLE OF zrpsg_am_c00,
          lt_ag_types_draft TYPE STANDARD TABLE OF zrpsg_dam_c00.

    "select agreement types for the element type group to delete
    SELECT FROM zrpsg_am_c00 FIELDS agreement_type, element_type_group_num
      FOR ALL ENTRIES IN @keys
      WHERE element_type_group_num EQ @keys-ElementTypeGroupNum
      INTO CORRESPONDING FIELDS OF TABLE @lt_ag_types.
    "select agreement types drafts for the element type group to delete
    SELECT FROM zrpsg_dam_c00 FIELDS agreementtype, elementtypegroupnum
      FOR ALL ENTRIES IN @keys
      WHERE elementtypegroupnum EQ @keys-ElementTypeGroupNum
      INTO CORRESPONDING FIELDS OF TABLE @lt_ag_types_draft.
    "if no data found exit
    IF lt_ag_types        IS INITIAL AND
       lt_ag_types_draft  IS INITIAL.
      RETURN.
    ENDIF.

    SORT lt_ag_types BY element_type_group_num.
    SORT lt_ag_types_draft BY elementtypegroupnum.

    "check if the Element type groups to delete are used in the Agreement types
    READ ENTITIES OF zrpsg_i_am_el_c01 IN LOCAL MODE
      ENTITY zrpsg_i_am_el_c01
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_elem_type_group).

    LOOP AT lt_elem_type_group INTO DATA(ls_elem_type_group).
      "check against active instances
      READ TABLE lt_ag_types TRANSPORTING NO FIELDS
        WITH KEY element_type_group_num = ls_elem_type_group-ElementTypeGroupNum BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type_group     = ls_elem_type_group
                                CHANGING  ct_failed_el_type_gr   = failed-zrpsg_i_am_el_c01
                                          ct_reported_el_type_gr = reported-zrpsg_i_am_el_c01 ).
        CONTINUE.
      ENDIF.
      "check against drafts
      READ TABLE lt_ag_types_draft TRANSPORTING NO FIELDS
        WITH KEY elementtypegroupnum = ls_elem_type_group-ElementTypeGroupNum BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type_group     = ls_elem_type_group
                                CHANGING  ct_failed_el_type_gr   = failed-zrpsg_i_am_el_c01
                                          ct_reported_el_type_gr = reported-zrpsg_i_am_el_c01 ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD add_to_failed_reported.
    APPEND VALUE #( %tky = is_elem_type_group-%tky ) TO ct_failed_el_type_gr.
    APPEND VALUE #(
                    %tky        = is_elem_type_group-%tky
                    %state_area = state_area_precheck_delete
                    %msg        = NEW zrpsg_cx_error_messages( i_textid   = zrpsg_cx_error_messages=>delete_dependency
                                                               i_attr1    = CONV #( is_elem_type_group-ElementTypeGroupNum )
                                                               i_severity = if_abap_behv_message=>severity-error )
                    %delete     = if_abap_behv=>mk-on
                 ) TO ct_reported_el_type_gr.
  ENDMETHOD.

ENDCLASS.
