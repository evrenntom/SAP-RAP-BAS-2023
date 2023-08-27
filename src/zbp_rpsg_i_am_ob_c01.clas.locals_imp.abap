CLASS lhc_ZRPSG_I_AM_OB_C01 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS state_area_precheck_delete TYPE string VALUE 'PRECHECK_DELETE'.

    TYPES:
      s_allow_table          TYPE STRUCTURE FOR READ RESULT zrpsg_i_am_ob_c01\\zrpsg_i_am_ob_c01,
      t_failed_allow_table   TYPE TABLE FOR FAILED EARLY zrpsg_i_am_ob_c01\\zrpsg_i_am_ob_c01,
      t_reported_allow_table TYPE TABLE FOR REPORTED EARLY zrpsg_i_am_ob_c01\\zrpsg_i_am_ob_c01.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zrpsg_i_am_ob_c01 RESULT result.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE zrpsg_i_am_ob_c01.

    METHODS add_to_failed_reported
      IMPORTING is_allow_table          TYPE s_allow_table
      CHANGING  ct_failed_allow_table   TYPE t_failed_allow_table
                ct_reported_allow_table TYPE t_reported_allow_table.

ENDCLASS.

CLASS lhc_ZRPSG_I_AM_OB_C01 IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD precheck_delete.

    DATA: lt_ob_types   TYPE STANDARD TABLE OF zrpsg_am_ob_c00,
          lt_ob_types_d TYPE STANDARD TABLE OF zrpsg_dam_ob_c00.

    "select object types for the allowed tables to delete
    SELECT FROM zrpsg_am_ob_c00 FIELDS objekt_type, table_name
     FOR ALL ENTRIES IN @keys
     WHERE table_name EQ @keys-TableName
     INTO CORRESPONDING FIELDS OF TABLE @lt_ob_types.

    "select object types drafts for the allowed tables to delete
    SELECT FROM zrpsg_dam_ob_c00 FIELDS objekttype, tablename
     FOR ALL ENTRIES IN @keys
     WHERE tablename EQ @keys-TableName
     INTO CORRESPONDING FIELDS OF TABLE @lt_ob_types_d.

    "if no data found exit
    IF lt_ob_types IS INITIAL AND
       lt_ob_types_d  IS INITIAL.
      RETURN.
    ENDIF.

    SORT lt_ob_types BY table_name.
    SORT lt_ob_types_d BY tablename.

    "check if the allowed tables to delete are used in the object types
    READ ENTITIES OF zrpsg_i_am_ob_c01 IN LOCAL MODE
      ENTITY zrpsg_i_am_ob_c01
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_allow_tables).

    LOOP AT lt_allow_tables INTO DATA(ls_allow_table).
      "check against active instances
      READ TABLE lt_ob_types TRANSPORTING NO FIELDS
        WITH KEY table_name = ls_allow_table-TableName BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_allow_table          = ls_allow_table
                                CHANGING  ct_failed_allow_table   = failed-zrpsg_i_am_ob_c01
                                          ct_reported_allow_table = reported-zrpsg_i_am_ob_c01 ).
        CONTINUE.
      ENDIF.
      "check against drafts
      READ TABLE lt_ob_types_d TRANSPORTING NO FIELDS
        WITH KEY tablename = ls_allow_table-TableName BINARY SEARCH.
      IF sy-subrc EQ 0.
        add_to_failed_reported( EXPORTING is_allow_table          = ls_allow_table
                                CHANGING  ct_failed_allow_table   = failed-zrpsg_i_am_ob_c01
                                          ct_reported_allow_table = reported-zrpsg_i_am_ob_c01 ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD add_to_failed_reported.
    APPEND VALUE #( %tky = is_allow_table-%tky ) TO ct_failed_allow_table.
    APPEND VALUE #(
                    %tky        = is_allow_table-%tky
                    %state_area = state_area_precheck_delete
                    %msg        = NEW zrpsg_cx_error_messages( i_textid   = zrpsg_cx_error_messages=>delete_dependency
                                                               i_attr1    = CONV #( is_allow_table-TableName )
                                                               i_severity = if_abap_behv_message=>severity-error )
                    %delete     = if_abap_behv=>mk-on
                 ) TO ct_reported_allow_table.
  ENDMETHOD.

ENDCLASS.
