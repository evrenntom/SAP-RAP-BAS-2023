CLASS lhc_ZRPSG_I_AM_OB_C00 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS state_area_precheck_delete TYPE string VALUE 'PRECHECK_DELETE'.

    TYPES:
      s_ob_type          TYPE STRUCTURE FOR READ RESULT zrpsg_i_am_ob_c00\\zrpsg_i_am_ob_c00,
      t_failed_ob_type   TYPE TABLE FOR FAILED EARLY zrpsg_i_am_ob_c00\\zrpsg_i_am_ob_c00,
      t_reported_ob_type TYPE TABLE FOR REPORTED EARLY zrpsg_i_am_ob_c00\\zrpsg_i_am_ob_c00.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrpsg_i_am_ob_c00 RESULT result.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE zrpsg_i_am_ob_c00.

    METHODS add_to_failed_reported
      IMPORTING is_ob_type          TYPE s_ob_type
      CHANGING  ct_failed_ob_type   TYPE t_failed_ob_type
                ct_reported_ob_type TYPE t_reported_ob_type.

ENDCLASS.

CLASS lhc_ZRPSG_I_AM_OB_C00 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD precheck_delete.

    DATA: lt_elem_types   TYPE STANDARD TABLE OF zrpsg_am_el_c00,
          lt_elem_types_d TYPE STANDARD TABLE OF zrpsg_dam_el_c00.

    "select element types for the Object types to delete
    SELECT FROM zrpsg_am_el_c00 FIELDS element_type, objekt_type
     FOR ALL ENTRIES IN @keys
     WHERE objekt_type EQ @keys-ObjektType
     INTO CORRESPONDING FIELDS OF TABLE @lt_elem_types.

    "select element type drafts for the Object types to delete
    SELECT FROM zrpsg_dam_el_c00 FIELDS elementtype, objekttype
     FOR ALL ENTRIES IN @keys
     WHERE elementtype EQ @keys-ObjektType
     INTO CORRESPONDING FIELDS OF TABLE @lt_elem_types_d.

    "if no data found exit
    IF lt_elem_types IS INITIAL AND
       lt_elem_types_d  IS INITIAL.
      RETURN.
    ENDIF.

    SORT lt_elem_types BY objekt_type.
    SORT lt_elem_types_d BY objekttype.

    "check if the object types to delete are used in the element types
    READ ENTITIES OF zrpsg_i_am_ob_c00 IN LOCAL MODE
      ENTITY zrpsg_i_am_ob_c00
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_object_types).

    LOOP AT lt_object_types INTO DATA(ls_ob_type).
      "check against active instances
      READ TABLE lt_elem_types TRANSPORTING NO FIELDS
        WITH KEY objekt_type = ls_ob_type-ObjektType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_ob_type          = ls_ob_type
                                CHANGING  ct_failed_ob_type   = failed-zrpsg_i_am_ob_c00
                                          ct_reported_ob_type = reported-zrpsg_i_am_ob_c00 ).
        CONTINUE.
      ENDIF.
      "check against drafts
      READ TABLE lt_elem_types_d TRANSPORTING NO FIELDS
        WITH KEY objekttype = ls_ob_type-ObjektType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_ob_type          = ls_ob_type
                                CHANGING  ct_failed_ob_type   = failed-zrpsg_i_am_ob_c00
                                          ct_reported_ob_type = reported-zrpsg_i_am_ob_c00 ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD add_to_failed_reported.
    APPEND VALUE #( %tky = is_ob_type-%tky ) TO ct_failed_ob_type.
    APPEND VALUE #(
                    %tky        = is_ob_type-%tky
                    %state_area = state_area_precheck_delete
                    %msg        = NEW zrpsg_cx_error_messages( i_textid   = zrpsg_cx_error_messages=>delete_dependency
                                                               i_attr1    = CONV #( is_ob_type-ObjektType )
                                                               i_severity = if_abap_behv_message=>severity-error )
                    %delete     = if_abap_behv=>mk-on
                 ) TO ct_reported_ob_type.
  ENDMETHOD.

ENDCLASS.
