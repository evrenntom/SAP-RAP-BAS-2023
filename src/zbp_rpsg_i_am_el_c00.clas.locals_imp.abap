CLASS lhc_ZRPSG_I_AM_EL_C00 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS state_area_precheck_delete TYPE string VALUE 'PRECHECK_DELETE'.

    TYPES:
      t_keys_elem_type     TYPE TABLE FOR DELETE zrpsg_i_am_el_c00\\zrpsg_i_am_el_c00,
      t_el_type_gp_assig   TYPE STANDARD TABLE OF zrpsg_am_el_c02,
      t_el_type_gp_assig_d TYPE STANDARD TABLE OF zrpsg_dam_el_c02,
      t_ltext              TYPE STANDARD TABLE OF zrpsg_am_ltext,
      t_ltext_d            TYPE STANDARD TABLE OF zrpsg_dam_ltext,
      t_cc                 TYPE STANDARD TABLE OF zrpsg_el_contr,
      t_cc_d               TYPE STANDARD TABLE OF zrpsg_del_contr,
      t_stext              TYPE STANDARD TABLE OF zrpsg_am_stext,
      t_stext_d            TYPE STANDARD TABLE OF zrpsg_dam_stext,
      t_pred_ltext_v       TYPE STANDARD TABLE OF zrpsg_am_vs_pt,
      t_pred_ltext_v_d     TYPE STANDARD TABLE OF zrpsg_dam_vs_pt,
      t_prop_text_v        TYPE STANDARD TABLE OF zrpsg_am_vs_prot,
      t_prop_text_v_d      TYPE STANDARD TABLE OF zrpsg_d_vs_prot,
      t_prop_text          TYPE STANDARD TABLE OF zrpsg_am_prot,
      t_prop_text_d        TYPE STANDARD TABLE OF zrpsg_dam_prot,
      t_pred_ltext         TYPE STANDARD TABLE OF zrpsg_am_ptext,
      t_pred_ltext_d       TYPE STANDARD TABLE OF zrpsg_dam_ptext.
    TYPES:
      s_elem_type          TYPE STRUCTURE FOR READ RESULT zrpsg_i_am_el_c00\\zrpsg_i_am_el_c00,
      t_failed_elem_type   TYPE TABLE FOR FAILED EARLY zrpsg_i_am_el_c00\\zrpsg_i_am_el_c00,
      t_reported_elem_type TYPE TABLE FOR REPORTED EARLY zrpsg_i_am_el_c00\\zrpsg_i_am_el_c00.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrpsg_i_am_el_c00 RESULT result.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE zrpsg_i_am_el_c00.

    METHODS read_el_type_data_dependencies
      IMPORTING it_keys               TYPE t_keys_elem_type
      EXPORTING et_el_type_gp_assig   TYPE t_el_type_gp_assig
                et_el_type_gp_assig_d TYPE t_el_type_gp_assig_d
                et_ltext              TYPE t_ltext
                et_ltext_d            TYPE t_ltext_d
                et_cc                 TYPE t_cc
                et_cc_d               TYPE t_cc_d
                et_stext              TYPE t_stext
                et_stext_d            TYPE t_stext_d
                et_pred_ltext_v       TYPE t_pred_ltext_v
                et_pred_ltext_v_d     TYPE t_pred_ltext_v_d
                et_prop_text_v        TYPE t_prop_text_v
                et_prop_text_v_d      TYPE t_prop_text_v_d
                et_prop_text          TYPE t_prop_text
                et_prop_text_d        TYPE t_prop_text_d
                et_pred_ltext         TYPE t_pred_ltext
                et_pred_ltext_d       TYPE t_pred_ltext_d.

    METHODS add_to_failed_reported
      IMPORTING is_elem_type        TYPE s_elem_type
      CHANGING  ct_failed_el_type   TYPE t_failed_elem_type
                ct_reported_el_type TYPE t_reported_elem_type.

ENDCLASS.

CLASS lhc_ZRPSG_I_AM_EL_C00 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD precheck_delete.

    read_el_type_data_dependencies( EXPORTING it_keys               = keys
                                    IMPORTING et_el_type_gp_assig   = DATA(lt_el_type_gp_assig)
                                              et_el_type_gp_assig_d = DATA(lt_el_type_gp_assig_d)
                                              et_ltext              = DATA(lt_ltext)
                                              et_ltext_d            = DATA(lt_ltext_d)
                                              et_cc                 = DATA(lt_cc)
                                              et_cc_d               = DATA(lt_cc_d)
                                              et_stext              = DATA(lt_stext)
                                              et_stext_d            = DATA(lt_stext_d)
                                              et_pred_ltext_v       = DATA(lt_pred_ltext_v)
                                              et_pred_ltext_v_d     = DATA(lt_pred_ltext_v_d)
                                              et_prop_text_v        = DATA(lt_prop_text_v)
                                              et_prop_text_v_d      = DATA(lt_prop_text_v_d)
                                              et_prop_text          = DATA(lt_prop_text)
                                              et_prop_text_d        = DATA(lt_prop_text_d)
                                              et_pred_ltext         = DATA(lt_pred_ltext)
                                              et_pred_ltext_d       = DATA(lt_pred_ltext_d) ).

    "if no data found exit
    IF lt_el_type_gp_assig   IS INITIAL AND
       lt_el_type_gp_assig_d IS INITIAL AND
       lt_ltext              IS INITIAL AND
       lt_ltext_d            IS INITIAL AND
       lt_cc                 IS INITIAL AND
       lt_cc_d               IS INITIAL AND
       lt_stext              IS INITIAL AND
       lt_stext_d            IS INITIAL AND
       lt_pred_ltext_v       IS INITIAL AND
       lt_pred_ltext_v_d     IS INITIAL AND
       lt_prop_text_v        IS INITIAL AND
       lt_prop_text_v_d      IS INITIAL AND
       lt_prop_text          IS INITIAL AND
       lt_prop_text_d        IS INITIAL AND
       lt_pred_ltext         IS INITIAL AND
       lt_pred_ltext_d       IS INITIAL.
      RETURN.
    ENDIF.

    "check if the Element types to delete are used
    READ ENTITIES OF zrpsg_i_am_el_c00 IN LOCAL MODE
      ENTITY zrpsg_i_am_el_c00
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_elem_types).

    LOOP AT lt_elem_types INTO DATA(ls_elem_type).
      READ TABLE lt_el_type_gp_assig TRANSPORTING NO FIELDS
        WITH KEY element_type = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_el_type_gp_assig_d TRANSPORTING NO FIELDS
        WITH KEY elementtype = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_ltext TRANSPORTING NO FIELDS
        WITH KEY element_type = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_ltext_d TRANSPORTING NO FIELDS
        WITH KEY elementtype = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_cc TRANSPORTING NO FIELDS
        WITH KEY element_type = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_cc_d TRANSPORTING NO FIELDS
        WITH KEY elementtype = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_stext TRANSPORTING NO FIELDS
        WITH KEY element_type = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_stext_d TRANSPORTING NO FIELDS
        WITH KEY elementtype = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_pred_ltext_v TRANSPORTING NO FIELDS
        WITH KEY element_type = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_pred_ltext_v_d TRANSPORTING NO FIELDS
        WITH KEY elementtype = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_prop_text_v TRANSPORTING NO FIELDS
        WITH KEY element_type = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_prop_text_v_d TRANSPORTING NO FIELDS
        WITH KEY elementtype = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_prop_text TRANSPORTING NO FIELDS
        WITH KEY element_type = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_prop_text_d TRANSPORTING NO FIELDS
        WITH KEY elementtype = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_pred_ltext TRANSPORTING NO FIELDS
        WITH KEY element_type = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_pred_ltext_d TRANSPORTING NO FIELDS
        WITH KEY elementtype = ls_elem_type-ElementType BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_elem_type        = ls_elem_type
                                CHANGING  ct_failed_el_type   = failed-zrpsg_i_am_el_c00
                                          ct_reported_el_type = reported-zrpsg_i_am_el_c00 ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD read_el_type_data_dependencies.

    CLEAR: et_el_type_gp_assig, et_el_type_gp_assig_d,
           et_ltext, et_ltext_d,
           et_cc, et_cc_d,
           et_stext, et_stext_d,
           et_pred_ltext_v, et_pred_ltext_v_d,
           et_prop_text_v, et_prop_text_v_d,
           et_prop_text, et_prop_text_d,
           et_pred_ltext, et_pred_ltext_d.

    IF it_keys IS INITIAL.
      RETURN.
    ENDIF.

    "select Element type group assignments for the Element types to delete
    SELECT FROM zrpsg_am_el_c02 FIELDS element_type_group_num, element_type
      FOR ALL ENTRIES IN @it_keys
      WHERE element_type EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_el_type_gp_assig.

    "select Element type group assignments drafts for the Element types to delete
    SELECT FROM zrpsg_dam_el_c02 FIELDS elementtypegroupnum, elementtype
      FOR ALL ENTRIES IN @it_keys
      WHERE elementtype EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_el_type_gp_assig_d.

    "select Long text for the Element types to delete
    SELECT FROM zrpsg_am_ltext FIELDS num, version_num, element_num, element_type
      FOR ALL ENTRIES IN @it_keys
      WHERE element_type EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_ltext.

    "select Long text drafts for the Element types to delete
    SELECT FROM zrpsg_dam_ltext FIELDS num, versionnum, elementnum, elementtype
      FOR ALL ENTRIES IN @it_keys
      WHERE elementtype EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_ltext_d.

    "select Condition Contracts for the Element types to delete
    SELECT FROM zrpsg_el_contr FIELDS num, version_num, element_num, element_type
      FOR ALL ENTRIES IN @it_keys
      WHERE element_type EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_cc.

    "select Condition Contract drafts for the Element types to delete
    SELECT FROM zrpsg_del_contr FIELDS num, versionnum, elementnum, elementtype
      FOR ALL ENTRIES IN @it_keys
      WHERE elementtype EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_cc_d.

    "select short texts for the Element types to delete
    SELECT FROM zrpsg_am_stext FIELDS num, version_num, element_num, element_type
      FOR ALL ENTRIES IN @it_keys
      WHERE element_type EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_stext.

    "select short text drafts for the Element types to delete
    SELECT FROM zrpsg_dam_stext FIELDS num, versionnum, elementnum, elementtype
      FOR ALL ENTRIES IN @it_keys
      WHERE elementtype EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_stext_d.

    "select predefined long texts version for the Element types to delete
    SELECT FROM zrpsg_am_vs_pt FIELDS num, version_num, element_num, element_type
      FOR ALL ENTRIES IN @it_keys
      WHERE element_type EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_pred_ltext_v.

    "select predefined long text version drafts for the Element types to delete
    SELECT FROM zrpsg_dam_vs_pt FIELDS num, versionnum, elementnum, elementtype
      FOR ALL ENTRIES IN @it_keys
      WHERE elementtype EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_pred_ltext_v_d.

    "select proposal texts version for the Element types to delete
    SELECT FROM zrpsg_am_vs_prot FIELDS num, version_num, element_num, element_type
      FOR ALL ENTRIES IN @it_keys
      WHERE element_type EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_prop_text_v.

    "select proposal text version drafts for the Element types to delete
    SELECT FROM zrpsg_d_vs_prot FIELDS num, versionnum, elementnum, elementtype
      FOR ALL ENTRIES IN @it_keys
      WHERE elementtype EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_prop_text_v_d.

    "select proposal texts for the Element types to delete
    SELECT FROM zrpsg_am_prot FIELDS element_type, spras
      FOR ALL ENTRIES IN @it_keys
      WHERE element_type EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_prop_text.

    "select proposal text drafts for the Element types to delete
    SELECT FROM zrpsg_dam_prot FIELDS elementtype, language
      FOR ALL ENTRIES IN @it_keys
      WHERE elementtype EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_prop_text_d.

    "select predefined long texts for the Element types to delete
    SELECT FROM zrpsg_am_ptext FIELDS element_type, spras
      FOR ALL ENTRIES IN @it_keys
      WHERE element_type EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_pred_ltext.

    "select predefined long text drafts for the Element types to delete
    SELECT FROM zrpsg_dam_ptext FIELDS elementtype, language
      FOR ALL ENTRIES IN @it_keys
      WHERE elementtype EQ @it_keys-ElementType
      INTO CORRESPONDING FIELDS OF TABLE @et_pred_ltext_d.

    SORT et_el_type_gp_assig BY element_type.
    SORT et_el_type_gp_assig_d BY elementtype.
    SORT et_ltext BY element_type.
    SORT et_ltext_d BY elementtype.
    SORT et_cc BY element_type.
    SORT et_cc_d BY elementtype.
    SORT et_stext BY element_type.
    SORT et_stext_d BY elementtype.
    SORT et_pred_ltext_v BY element_type.
    SORT et_pred_ltext_v_d BY elementtype.
    SORT et_prop_text_v BY element_type.
    SORT et_prop_text_v_d BY elementtype.
    SORT et_prop_text BY element_type.
    SORT et_prop_text_d BY elementtype.
    SORT et_pred_ltext BY element_type.
    SORT et_pred_ltext_d BY elementtype.

  ENDMETHOD.


  METHOD add_to_failed_reported.
    APPEND VALUE #( %tky = is_elem_type-%tky ) TO ct_failed_el_type.
    APPEND VALUE #(
                    %tky        = is_elem_type-%tky
                    %state_area = state_area_precheck_delete
                    %msg        = NEW zrpsg_cx_error_messages( i_textid   = zrpsg_cx_error_messages=>delete_dependency
                                                               i_attr1    = CONV #( is_elem_type-ElementType )
                                                               i_severity = if_abap_behv_message=>severity-error )
                    %delete     = if_abap_behv=>mk-on
                 ) TO ct_reported_el_type.
  ENDMETHOD.

ENDCLASS.
