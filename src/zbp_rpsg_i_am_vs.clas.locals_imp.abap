CLASS lhc_zrpsg_i_am_vs DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_El_contr FOR NUMBERING
      IMPORTING entities FOR CREATE zrpsg_i_am_vs\_El_contr.

    METHODS earlynumbering_cba_El_ltext FOR NUMBERING
      IMPORTING entities FOR CREATE zrpsg_i_am_vs\_El_ltext.

    METHODS earlynumbering_cba_El_vs_pt FOR NUMBERING
      IMPORTING entities FOR CREATE zrpsg_i_am_vs\_vs_pt.

    METHODS earlynumbering_cba_El_stext FOR NUMBERING
      IMPORTING entities FOR CREATE zrpsg_i_am_vs\_El_stext.

    METHODS earlynumbering_cba_El_prot FOR NUMBERING
      IMPORTING entities FOR CREATE zrpsg_i_am_vs\_vs_prot.

    METHODS setDefaultVersionStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zrpsg_i_am_vs~setDefaultVersionStatus.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrpsg_i_am_vs RESULT result.

    METHODS copyVersion FOR MODIFY
      IMPORTING keys FOR ACTION zrpsg_i_am_vs~copyVersion.

ENDCLASS.

CLASS lhc_zrpsg_i_am_vs IMPLEMENTATION.

  METHOD earlynumbering_cba_El_contr.
***********************************************************
* For Elements it is used a number range object
***********************************************************
    DATA: entity TYPE STRUCTURE FOR CREATE zrpsg_i_am_vs\_el_contr.

    LOOP AT entities INTO entity.
      LOOP AT entity-%target INTO DATA(entity_el_contr).
        IF entity_el_contr-ElementNum IS NOT INITIAL.
          APPEND CORRESPONDING #( entity_el_contr ) TO mapped-contractentity.
        ELSE.
          TRY.
              cl_numberrange_runtime=>number_get(
                EXPORTING
                  nr_range_nr       = '01'
                  object            = 'ZRPSG_AMEL'
                  quantity          = '1'
                IMPORTING
                  number            = DATA(lv_number) ).

              entity_el_contr-ElementNum = lv_number+10(10).
              APPEND VALUE #( %cid      = entity_el_contr-%cid
                              %key      = entity_el_contr-%key
                              %is_draft = entity_el_contr-%is_draft
                            ) TO mapped-contractentity.

            CATCH cx_number_ranges INTO DATA(lx_number_ranges).
              APPEND VALUE #(  %cid      = entity_el_contr-%cid
                               %key      = entity_el_contr-%key
                               %is_draft = entity_el_contr-%is_draft
                               %msg      = lx_number_ranges
                            ) TO reported-contractentity.
              APPEND VALUE #(  %cid      = entity_el_contr-%cid
                               %key      = entity_el_contr-%key
                               %is_draft = entity_el_contr-%is_draft
                            ) TO failed-contractentity.
          ENDTRY.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_El_ltext.
***********************************************************
* For Elements it is used a number range object
***********************************************************
    DATA: entity TYPE STRUCTURE FOR CREATE zrpsg_i_am_vs\_el_ltext.

    LOOP AT entities INTO entity.
      LOOP AT entity-%target INTO DATA(entity_el_ltext).
        IF entity_el_ltext-ElementNum IS NOT INITIAL.
          APPEND CORRESPONDING #( entity_el_ltext ) TO mapped-zrpsg_i_am_ltext.
        ELSE.
          TRY.
              cl_numberrange_runtime=>number_get(
                EXPORTING
                  nr_range_nr       = '01'
                  object            = 'ZRPSG_AMEL'
                  quantity          = '1'
                IMPORTING
                  number            = DATA(lv_number) ).

              entity_el_ltext-ElementNum = lv_number+10(10).
              APPEND VALUE #( %cid      = entity_el_ltext-%cid
                              %key      = entity_el_ltext-%key
                              %is_draft = entity_el_ltext-%is_draft
                            ) TO mapped-zrpsg_i_am_ltext.

            CATCH cx_number_ranges INTO DATA(lx_number_ranges).
              APPEND VALUE #(  %cid      = entity_el_ltext-%cid
                               %key      = entity_el_ltext-%key
                               %is_draft = entity_el_ltext-%is_draft
                               %msg      = lx_number_ranges
                            ) TO reported-zrpsg_i_am_ltext.
              APPEND VALUE #(  %cid      = entity_el_ltext-%cid
                               %key      = entity_el_ltext-%key
                               %is_draft = entity_el_ltext-%is_draft
                            ) TO failed-zrpsg_i_am_ltext.
          ENDTRY.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_El_stext.
***********************************************************
* For Elements it is used a number range object
***********************************************************
    DATA: entity TYPE STRUCTURE FOR CREATE zrpsg_i_am_vs\_el_stext.

    LOOP AT entities INTO entity.
      LOOP AT entity-%target INTO DATA(entity_el_stext).
        IF entity_el_stext-ElementNum IS NOT INITIAL.
          APPEND CORRESPONDING #( entity_el_stext ) TO mapped-zrpsg_i_am_stext.
        ELSE.
          TRY.
              cl_numberrange_runtime=>number_get(
                EXPORTING
                  nr_range_nr       = '01'
                  object            = 'ZRPSG_AMEL'
                  quantity          = '1'
                IMPORTING
                  number            = DATA(lv_number) ).

              entity_el_stext-ElementNum = lv_number+10(10).
              APPEND VALUE #( %cid      = entity_el_stext-%cid
                              %key      = entity_el_stext-%key
                              %is_draft = entity_el_stext-%is_draft
                            ) TO mapped-zrpsg_i_am_stext.

            CATCH cx_number_ranges INTO DATA(lx_number_ranges).
              APPEND VALUE #(  %cid      = entity_el_stext-%cid
                               %key      = entity_el_stext-%key
                               %is_draft = entity_el_stext-%is_draft
                               %msg      = lx_number_ranges
                            ) TO reported-zrpsg_i_am_stext.
              APPEND VALUE #(  %cid      = entity_el_stext-%cid
                               %key      = entity_el_stext-%key
                               %is_draft = entity_el_stext-%is_draft
                            ) TO failed-zrpsg_i_am_stext.
          ENDTRY.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_El_vs_pt.
***********************************************************
* For Elements it is used a number range object
***********************************************************
    DATA: entity TYPE STRUCTURE FOR CREATE zrpsg_i_am_vs\_vs_pt.

    LOOP AT entities INTO entity.
      LOOP AT entity-%target INTO DATA(entity_vs_pt).
        IF entity_vs_pt-ElementNum IS NOT INITIAL.
          APPEND CORRESPONDING #( entity_vs_pt ) TO mapped-zrpsg_i_am_vs_pt.
        ELSE.
          TRY.
              cl_numberrange_runtime=>number_get(
                EXPORTING
                  nr_range_nr       = '01'
                  object            = 'ZRPSG_AMEL'
                  quantity          = '1'
                IMPORTING
                  number            = DATA(lv_number) ).

              entity_vs_pt-ElementNum = lv_number+10(10).
              APPEND VALUE #( %cid      = entity_vs_pt-%cid
                              %key      = entity_vs_pt-%key
                              %is_draft = entity_vs_pt-%is_draft
                            ) TO mapped-zrpsg_i_am_vs_pt.

            CATCH cx_number_ranges INTO DATA(lx_number_ranges).
              APPEND VALUE #(  %cid      = entity_vs_pt-%cid
                               %key      = entity_vs_pt-%key
                               %is_draft = entity_vs_pt-%is_draft
                               %msg      = lx_number_ranges
                            ) TO reported-zrpsg_i_am_vs_pt.
              APPEND VALUE #(  %cid      = entity_vs_pt-%cid
                               %key      = entity_vs_pt-%key
                               %is_draft = entity_vs_pt-%is_draft
                            ) TO failed-zrpsg_i_am_vs_pt.
          ENDTRY.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD setDefaultVersionStatus.

    READ ENTITIES OF zrpsg_i_am IN LOCAL MODE
      ENTITY zrpsg_i_am_vs
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_am_vs).

    DELETE lt_am_vs WHERE VersionStatus IS NOT INITIAL.
    IF lt_am_vs IS INITIAL.
      RETURN.
    ENDIF.
    "set the status 001 NEW
    MODIFY ENTITIES OF zrpsg_i_am IN LOCAL MODE
      ENTITY zrpsg_i_am_vs
        UPDATE FIELDS ( VersionStatus )
        WITH VALUE #( FOR ls_am_vs IN lt_am_vs ( %tky       = ls_am_vs-%tky
                                                 VersionStatus = '001' ) )
    REPORTED DATA(update_reported).
    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD earlynumbering_cba_el_prot.
***********************************************************
* For Elements it is used a number range object
***********************************************************
    DATA: entity TYPE STRUCTURE FOR CREATE zrpsg_i_am_vs\_vs_prot.

    LOOP AT entities INTO entity.
      LOOP AT entity-%target INTO DATA(entity_vs_prot).
        IF entity_vs_prot-ElementNum IS NOT INITIAL.
          APPEND CORRESPONDING #( entity_vs_prot ) TO mapped-zrpsg_i_am_vs_prot.
        ELSE.
          TRY.
              cl_numberrange_runtime=>number_get(
                EXPORTING
                  nr_range_nr       = '01'
                  object            = 'ZRPSG_AMEL'
                  quantity          = '1'
                IMPORTING
                  number            = DATA(lv_number) ).

              entity_vs_prot-ElementNum = lv_number+10(10).
              APPEND VALUE #( %cid      = entity_vs_prot-%cid
                              %key      = entity_vs_prot-%key
                              %is_draft = entity_vs_prot-%is_draft
                            ) TO mapped-zrpsg_i_am_vs_prot.

            CATCH cx_number_ranges INTO DATA(lx_number_ranges).
              APPEND VALUE #(  %cid      = entity_vs_prot-%cid
                               %key      = entity_vs_prot-%key
                               %is_draft = entity_vs_prot-%is_draft
                               %msg      = lx_number_ranges
                            ) TO reported-zrpsg_i_am_vs_pt.
              APPEND VALUE #(  %cid      = entity_vs_prot-%cid
                               %key      = entity_vs_prot-%key
                               %is_draft = entity_vs_prot-%is_draft
                            ) TO failed-zrpsg_i_am_vs_pt.
          ENDTRY.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD copyVersion.

    DATA: lt_new_versions_cba  TYPE TABLE FOR CREATE zrpsg_i_am\_vs,                      "Version
          lt_new_per_assig_cba TYPE TABLE FOR CREATE zrpsg_i_am\\zrpsg_i_am_vs\_vs_ps,    "Person version assignment
          lt_new_cond_cba      TYPE TABLE FOR CREATE zrpsg_i_am\\zrpsg_i_am_vs\_el_contr. "Conditions

    "check keys with initial %cid (i.e., not set by caller API)
    READ TABLE keys WITH KEY %cid = '' INTO DATA(ls_key_with_inital_cid).
    ASSERT ls_key_with_inital_cid IS INITIAL.

    "read the data from the Version instances to be copied
    READ ENTITIES OF zrpsg_i_am IN LOCAL MODE
      ENTITY zrpsg_i_am_vs
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_versions_to_copy)
      ENTITY zrpsg_i_am_vs BY \_vs_ps
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(lt_per_assig_to_copy)
     ENTITY zrpsg_i_am_vs BY \_el_contr
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(lt_cond_to_copy)
    FAILED failed
    REPORTED reported.

    IF failed IS NOT INITIAL.
      RETURN.
    ENDIF.

*****  Version *****
    LOOP AT lt_versions_to_copy ASSIGNING FIELD-SYMBOL(<ls_version_to_copy>).
      "%cid_ref it is not filled because the action copy is in the Version level not in the Agreement level
      APPEND VALUE #( %is_draft = <ls_version_to_copy>-%is_draft
                      Num       = <ls_version_to_copy>-Num )
        TO lt_new_versions_cba ASSIGNING FIELD-SYMBOL(<ls_new_version_cba>).

      APPEND VALUE #( %cid      = keys[ KEY entity %key = <ls_version_to_copy>-%key ]-%cid
                      %is_draft = <ls_version_to_copy>-%is_draft
                      %data     = CORRESPONDING #( <ls_version_to_copy> EXCEPT VersionNum VersionStatus CreationUser CreationTime LastchangeUser LastchangeTime ) )
        TO <ls_new_version_cba>-%target ASSIGNING FIELD-SYMBOL(<ls_new_version>).
      "adjust the copied version instance data
      "VersionNum will be filled with earlynumbering_cba_vs
      "VersionStatus will be filled with setDefaultVersionStatus
      <ls_new_version>-VersionDesc = |{ <ls_new_version>-VersionDesc } COPY|.
      "todo DateFrom, DateTo from input param

*****  Person version assignment *****
      APPEND VALUE #( %cid_ref   = <ls_new_version>-%cid
                      %is_draft  = <ls_version_to_copy>-%is_draft
                      Num        = <ls_new_version>-Num
                      VersionNum = <ls_new_version>-VersionNum )
        TO lt_new_per_assig_cba ASSIGNING FIELD-SYMBOL(<ls_per_assig_cba>).
      LOOP AT lt_per_assig_to_copy ASSIGNING FIELD-SYMBOL(<ls_per_assig_to_copy>)
        WHERE Num        EQ <ls_version_to_copy>-Num AND
              VersionNum EQ <ls_version_to_copy>-VersionNum.
        DATA(lv_per_assig_index) = sy-tabix.
        APPEND VALUE #( %cid      = keys[ KEY entity %key = <ls_version_to_copy>-%key ]-%cid && 'PER' && lv_per_assig_index
                        %is_draft = <ls_version_to_copy>-%is_draft
                        %data     = CORRESPONDING #( <ls_per_assig_to_copy> EXCEPT VersionNum  ) )
          TO <ls_per_assig_cba>-%target. "ASSIGNING FIELD-SYMBOL(<ls_new_per_assig>).
      ENDLOOP.

*****  Conditions *****
      APPEND VALUE #( %cid_ref   = <ls_new_version>-%cid
                      %is_draft  = <ls_version_to_copy>-%is_draft
                      Num        = <ls_new_version>-Num
                      VersionNum = <ls_new_version>-VersionNum )
        TO lt_new_cond_cba ASSIGNING FIELD-SYMBOL(<ls_cond_cba>).
      LOOP AT lt_cond_to_copy ASSIGNING FIELD-SYMBOL(<ls_cond_to_copy>)
        USING KEY entity WHERE Num        EQ <ls_version_to_copy>-Num AND
                               VersionNum EQ <ls_version_to_copy>-VersionNum.
        DATA(lv_cond_index) = sy-tabix.
        APPEND VALUE #( %cid      = keys[ KEY entity %key = <ls_version_to_copy>-%key ]-%cid && 'COND' && lv_cond_index
                        %is_draft = <ls_version_to_copy>-%is_draft
                        %data     = CORRESPONDING #( <ls_cond_to_copy> EXCEPT VersionNum ElementNum CocoNum ) )
          TO <ls_cond_cba>-%target. "ASSIGNING FIELD-SYMBOL(<ls_new_cond>).
        "ElementNum will be filled with EARLYNUMBERING_CBA_EL_CONTR
      ENDLOOP.

*****  todo next childs *****

    ENDLOOP.

    "create new BO instance
    MODIFY ENTITIES OF zrpsg_i_am IN LOCAL MODE
      ENTITY zrpsg_i_am
        CREATE BY \_vs FIELDS ( Num VersionDesc DateFrom DateTo )
          WITH lt_new_versions_cba
      ENTITY zrpsg_i_am_vs
        CREATE BY \_vs_ps FIELDS ( PersonNum Num Role )
          WITH lt_new_per_assig_cba
     ENTITY zrpsg_i_am_vs
       CREATE BY \_el_contr FIELDS ( Num ElementType HeaderText CalcType Amount Currency AmountPer PricingUnit Unit )
         WITH lt_new_cond_cba
      FAILED failed
      REPORTED reported
      MAPPED mapped.

  ENDMETHOD.

ENDCLASS.
