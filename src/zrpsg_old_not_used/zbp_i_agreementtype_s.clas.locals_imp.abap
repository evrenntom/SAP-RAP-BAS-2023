CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZAGTC00'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'AgreementTypeZ' table = 'ZRPSG_AM_C00' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_AGREEMENTTYPE_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR AgreementTypeAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION AgreementTypeAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR AgreementTypeAll
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_AGREEMENTTYPE_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_AgreementType_S IN LOCAL MODE
    ENTITY AgreementTypeAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_AgreementType = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_AgreementType_S IN LOCAL MODE
      ENTITY AgreementTypeAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_AgreementType_S IN LOCAL MODE
      ENTITY AgreementTypeAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_AGREEMENTTYPE' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_AGREEMENTTYPE_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_AGREEMENTTYPE_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-AgreementTypeAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_AGREEMENTTYPE DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR AgreementTypeZ~ValidateTransportRequest,
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR AgreementTypeZ~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR AgreementTypeZ
        RESULT result,
      DEPRECATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION AgreementTypeZ~Deprecate
        RESULT result,
      INVALIDATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION AgreementTypeZ~Invalidate
        RESULT result,
      COPYAGREEMENTTYPE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION AgreementTypeZ~CopyAgreementType,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR AgreementTypeZ
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR AgreementTypeZ
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_AGREEMENTTYPE IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_AgreementType_S.
    SELECT SINGLE TransportRequestID
      FROM ZRPSG_AM_C00_D_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = 'ZRPSG_AM_C00'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-AgreementTypeZ ) ).
  ENDMETHOD.
  METHOD VALIDATEDATACONSISTENCY.
    READ ENTITIES OF ZI_AgreementType_S IN LOCAL MODE
      ENTITY AgreementTypeZ
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(AgreementType).
    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( 'ZRPSG_AM_C00' ).
    DATA: BEGIN OF element_check,
            element  TYPE string,
            check    TYPE ref to if_xco_dp_check,
          END OF element_check,
          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
    LOOP AT AgreementType ASSIGNING FIELD-SYMBOL(<AgreementType>).
      element_checks = VALUE #(
        ( element = 'ConfigDeprecationCode' check = table->field( 'CONFIGDEPRECATIONCODE' )->get_value_check( ia_value = <AgreementType>-ConfigDeprecationCode  ) )
      ).
      LOOP AT element_checks INTO element_check.
        element_check-check->execute( ).
        CHECK element_check-check->passed = xco_cp=>boolean->false.
        INSERT VALUE #( %TKY        = <AgreementType>-%TKY ) INTO TABLE failed-AgreementTypeZ.
        INSERT VALUE #( %TKY        = <AgreementType>-%TKY
                        %STATE_AREA = 'AgreementType_Input_Check' ) INTO TABLE reported-AgreementTypeZ.
        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
          INSERT VALUE #( %TKY = <AgreementType>-%TKY
                          %STATE_AREA = 'AgreementType_Input_Check'
                          %PATH-AgreementTypeAll-SingletonID = 1
                          %PATH-AgreementTypeAll-%IS_DRAFT = <AgreementType>-%IS_DRAFT
                          %msg = new_message(
                                   id       = <msg>->value-msgid
                                   number   = <msg>->value-msgno
                                   severity = if_abap_behv_message=>severity-error
                                   v1       = <msg>->value-msgv1
                                   v2       = <msg>->value-msgv2
                                   v3       = <msg>->value-msgv3
                                   v4       = <msg>->value-msgv4 ) ) INTO TABLE reported-AgreementTypeZ ASSIGNING FIELD-SYMBOL(<rep>).
          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
          <comp> = if_abap_behv=>mk-on.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
  ENDMETHOD.
  METHOD DEPRECATE.
    MODIFY ENTITIES OF ZI_AgreementType_S IN LOCAL MODE
      ENTITY AgreementTypeZ
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'W'
                         ConfigDeprecationCode_Critlty = 2 ) ).
    READ ENTITIES OF ZI_AgreementType_S IN LOCAL MODE
      ENTITY AgreementTypeZ
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(AgreementType).
    result = VALUE #( FOR row IN AgreementType
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-AgreementTypeZ = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Deprecate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_deprecated( )
                                                   %PATH-AgreementTypeAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-AgreementTypeAll-SingletonID = 1 ) ).
  ENDMETHOD.
  METHOD INVALIDATE.
    MODIFY ENTITIES OF ZI_AgreementType_S IN LOCAL MODE
      ENTITY AgreementTypeZ
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'E'
                         ConfigDeprecationCode_Critlty = 1 ) ).
    READ ENTITIES OF ZI_AgreementType_S IN LOCAL MODE
      ENTITY AgreementTypeZ
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(AgreementType).
    result = VALUE #( FOR row IN AgreementType
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-AgreementTypeZ = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Invalidate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_invalidated( )
                                                   %PATH-AgreementTypeAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-AgreementTypeAll-SingletonID = 1 ) ).
  ENDMETHOD.
  METHOD COPYAGREEMENTTYPE.
    DATA new_AgreementType TYPE TABLE FOR CREATE ZI_AgreementType_S\_AgreementType.

    READ ENTITIES OF ZI_AgreementType_S IN LOCAL MODE
      ENTITY AgreementTypeZ
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ref_AgreementType)
      FAILED DATA(read_failed).

    LOOP AT ref_AgreementType ASSIGNING FIELD-SYMBOL(<ref_AgreementType>).
      DATA(key) = keys[ KEY draft %TKY = <ref_AgreementType>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_AgreementType>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_AgreementType>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_AgreementType> EXCEPT
            AgreementType
            ConfigDeprecationCode
            LastchangeTime
            LastchangeTimeLocal
            SingletonID
        ) ) )
      ) TO new_AgreementType ASSIGNING FIELD-SYMBOL(<new_AgreementType>).
      <new_AgreementType>-%TARGET[ 1 ]-AgreementType = key-%PARAM-AgreementType.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_AgreementType_S IN LOCAL MODE
      ENTITY AgreementTypeAll CREATE BY \_AgreementType
      FIELDS (
               AgreementType
               ElementTypeGroupNum
               Description
             ) WITH new_AgreementType
      MAPPED DATA(mapped_create)
      FAILED failed
      REPORTED reported.

    mapped-AgreementTypeZ = mapped_create-AgreementTypeZ.
    INSERT LINES OF read_failed-AgreementTypeZ INTO TABLE failed-AgreementTypeZ.

    reported-AgreementTypeZ = VALUE #( FOR created IN mapped-AgreementTypeZ (
                                               %CID = created-%CID
                                               %ACTION-CopyAgreementType = if_abap_behv=>mk-on
                                               %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                               %PATH-AgreementTypeAll-%IS_DRAFT = created-%IS_DRAFT
                                               %PATH-AgreementTypeAll-SingletonID = 1 ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_AGREEMENTTYPE' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-Deprecate = is_authorized.
    result-%ACTION-Invalidate = is_authorized.
    result-%ACTION-CopyAgreementType = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    READ ENTITIES OF ZI_AgreementType_S IN LOCAL MODE
      ENTITY AgreementTypeZ
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys )
      RESULT DATA(AgreementType).

    result =
      VALUE #(
        FOR row IN AgreementType
        LET Deprecate = COND #( WHEN row-ConfigDeprecationCode = '' AND row-%IS_DRAFT = if_abap_behv=>mk-on
                                THEN if_abap_behv=>fc-o-enabled
                                ELSE if_abap_behv=>fc-o-disabled  )
            Invalidate = COND #( WHEN ( row-ConfigDeprecationCode = '' OR row-ConfigDeprecationCode = 'W' ) AND row-%IS_DRAFT = if_abap_behv=>mk-on
                                THEN if_abap_behv=>fc-o-enabled
                                ELSE if_abap_behv=>fc-o-disabled  )
        IN ( %TKY              = row-%TKY
             %ACTION-Deprecate = Deprecate
             %ACTION-Invalidate = Invalidate
                                        %ACTION-CopyAgreementType = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
   ) ).
  ENDMETHOD.
ENDCLASS.
