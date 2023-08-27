CLASS lhc_zrpsg_i_am_vs_prot DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS fill_to_prot FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZRPSG_I_AM_VS_PROT~fill_to_prot.

ENDCLASS.

CLASS lhc_zrpsg_i_am_vs_prot IMPLEMENTATION.

  METHOD fill_to_prot.

  READ ENTITIES OF zrpsg_i_am
    IN LOCAL MODE
    ENTITY zrpsg_i_am_vs_prot
    FIELDS ( ElementType )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_vs_prot).

    READ ENTITIES OF zrpsg_i_am
    IN LOCAL MODE
    ENTITY zrpsg_i_am
    FIELDS ( Language )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_am_l).

    READ TABLE lt_am_l INTO DATA(ls_am_l) INDEX 1.

    IF ls_am_l-Language IS NOT INITIAL.
      DATA(lv_sy_langu) = ls_am_l-Language.
    ELSE.

      lv_sy_langu = cl_abap_context_info=>get_user_language_abap_format( ).
    ENDIF.
**
    LOOP AT lt_vs_prot INTO DATA(ls_vs_prot).

*    READ TABLE lt_vs_pt INTO DATA(ls_vs_pt) INDEX 1.
      SELECT SINGLE * FROM zrpsg_am_prot WHERE element_type = @ls_vs_prot-ElementType
                                              AND  spras = @lv_sy_langu
                                              INTO @DATA(ls_ptext).

**
      MODIFY ENTITY IN LOCAL MODE zrpsg_i_am\\zrpsg_i_am_vs_prot
          UPDATE FIELDS ( Text )
          WITH VALUE #( ( %tky = ls_vs_prot-%tky
                          Text = ls_ptext-text ) ).

*    MODIFY ENTITIES OF zrpsg_i_am IN LOCAL MODE
*    ENTITY zrpsg_i_am_vs_pt
*    UPDATE FIELDS ( Text )
*    WITH VALUE #( FOR ls_m_vs_pt IN lt_vs_pt
*    ( %key = ls_m_vs_pt-%key
*    ElementType = ls_ptext-element_type
*     )
*    ) REPORTED DATA(modReported).
*    reported = CORRESPONDING #( DEEP modReported ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zrpsg_i_am_vs_ps DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS fill_to_pname FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZRPSG_I_AM_VS_PS~fill_to_pname.
    METHODS fill_to_Rdes FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZRPSG_I_AM_VS_PS~fill_to_Rdes.

ENDCLASS.

CLASS lhc_zrpsg_i_am_vs_ps IMPLEMENTATION.

  METHOD fill_to_pname.
  READ ENTITIES OF zrpsg_i_am
    IN LOCAL MODE
    ENTITY zrpsg_i_am_vs_ps
    FIELDS ( PersonNum )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_vs_ps).

    loop at lt_vs_ps into data(ls_vs_ps).
          SELECT SINGLE * FROM zrpsg_am_ps WHERE person_num = @ls_vs_ps-PersonNum
                                              INTO @DATA(ls_am_ps).

       MODIFY ENTITY IN LOCAL MODE zrpsg_i_am\\zrpsg_i_am_vs_ps
          UPDATE FIELDS ( Pname )
          WITH VALUE #( ( %tky = ls_vs_ps-%tky
                          Pname = ls_am_ps-name ) ).


    ENDLOOP..

  ENDMETHOD.

  METHOD fill_to_Rdes.

  READ ENTITIES OF zrpsg_i_am
    IN LOCAL MODE
    ENTITY zrpsg_i_am_vs_ps
    FIELDS ( PersonNum )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_vs_ps).

    loop at lt_vs_ps into data(ls_vs_ps).
          SELECT SINGLE * FROM zrpsg_am_ps_c00 WHERE role = @ls_vs_ps-Role
                                              INTO @DATA(ls_am_ps_c00).

       MODIFY ENTITY IN LOCAL MODE zrpsg_i_am\\zrpsg_i_am_vs_ps
          UPDATE FIELDS ( Rdes )
          WITH VALUE #( ( %tky = ls_vs_ps-%tky
                          Rdes = ls_am_ps_c00-description ) ).


    ENDLOOP..

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zrpsg_i_am_vs_pt DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS fill_to_pt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zrpsg_i_am_vs_pt~fill_to_pt.

ENDCLASS.

CLASS lhc_zrpsg_i_am_vs_pt IMPLEMENTATION.

  METHOD fill_to_pt.


    READ ENTITIES OF zrpsg_i_am
    IN LOCAL MODE
    ENTITY zrpsg_i_am_vs_pt
    FIELDS ( ElementType )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_vs_pt).

    READ ENTITIES OF zrpsg_i_am
    IN LOCAL MODE
    ENTITY zrpsg_i_am
    FIELDS ( Language )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_am_l).

    READ TABLE lt_am_l INTO DATA(ls_am_l) INDEX 1.

    IF ls_am_l-Language IS NOT INITIAL.
      DATA(lv_sy_langu) = ls_am_l-Language.
    ELSE.

      lv_sy_langu = cl_abap_context_info=>get_user_language_abap_format( ).
    ENDIF.
**
    LOOP AT lt_vs_pt INTO DATA(ls_vs_pt).

*    READ TABLE lt_vs_pt INTO DATA(ls_vs_pt) INDEX 1.
      SELECT SINGLE * FROM zrpsg_am_ptext WHERE element_type = @ls_vs_pt-ElementType
                                              AND  spras = @lv_sy_langu
                                              INTO @DATA(ls_ptext).

**
      MODIFY ENTITY IN LOCAL MODE zrpsg_i_am\\zrpsg_i_am_vs_pt
          UPDATE FIELDS ( Text )
          WITH VALUE #( ( %tky = ls_vs_pt-%tky
                          Text = ls_ptext-text ) ).

*    MODIFY ENTITIES OF zrpsg_i_am IN LOCAL MODE
*    ENTITY zrpsg_i_am_vs_pt
*    UPDATE FIELDS ( Text )
*    WITH VALUE #( FOR ls_m_vs_pt IN lt_vs_pt
*    ( %key = ls_m_vs_pt-%key
*    ElementType = ls_ptext-element_type
*     )
*    ) REPORTED DATA(modReported).
*    reported = CORRESPONDING #( DEEP modReported ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZRPSG_I_AM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrpsg_i_am RESULT result.
    METHODS earlynumbering_cba_vs FOR NUMBERING
      IMPORTING entities FOR CREATE zrpsg_i_am\_vs.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zrpsg_i_am.

ENDCLASS.

CLASS lhc_ZRPSG_I_AM IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
***********************************************************
* For Agreement it is used a number range object
***********************************************************
    DATA: entity TYPE STRUCTURE FOR CREATE zrpsg_i_am.

    LOOP AT entities INTO entity.
      "Ensure num is not set yet (idempotent)- must be checked when BO is draft-enabled
      IF entity-num IS NOT INITIAL.
        APPEND CORRESPONDING #( entity ) TO mapped-zrpsg_i_am.
      ELSE.
        TRY.
            cl_numberrange_runtime=>number_get(
              EXPORTING
                nr_range_nr       = '01'
                object            = 'ZRPSG_AM'
                quantity          = '1'
              IMPORTING
                number            = DATA(lv_number) ).

            entity-num = lv_number+10(10).
            APPEND VALUE #( %cid      = entity-%cid
                            %key      = entity-%key
                            %is_draft = entity-%is_draft
                          ) TO mapped-zrpsg_i_am.

          CATCH cx_number_ranges INTO DATA(lx_number_ranges).
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                             %msg      = lx_number_ranges
                          ) TO reported-zrpsg_i_am.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                          ) TO failed-zrpsg_i_am.
        ENDTRY.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Vs.
***********************************************************
* For Agreement Version NO number range object is used,
*  instead the max Version number is incremented with 1
***********************************************************
    DATA: entity TYPE STRUCTURE FOR CREATE zrpsg_i_am\_vs.

    LOOP AT entities INTO entity.
      "get max VersionNum from active table
      SELECT SINGLE FROM zrpsg_am_vs FIELDS MAX( version_num ) WHERE num EQ @entity-num INTO @DATA(lv_vnum_max).
      "get max VersionNum from draft table
      SELECT SINGLE FROM zrpsg_dam_vs FIELDS MAX( VersionNum ) WHERE num EQ @entity-num INTO @DATA(lv_draft_vnum_max).
      "determine the first free VersionNum
      IF lv_draft_vnum_max GT lv_vnum_max.
        lv_vnum_max = lv_draft_vnum_max.
      ENDIF.
      LOOP AT entity-%target INTO DATA(entity_vs).
        IF entity_vs-VersionNum IS NOT INITIAL.
          APPEND CORRESPONDING #( entity_vs ) TO mapped-zrpsg_i_am_vs.
        ELSE.
          lv_vnum_max += 1.
          entity_vs-VersionNum = lv_vnum_max.
          APPEND VALUE #( %cid      = entity_vs-%cid
                          %key      = entity_vs-%key
                          %is_draft = entity_vs-%is_draft
                        ) TO mapped-zrpsg_i_am_vs.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
