CLASS zrpsg_cx_error_messages DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    CONSTANTS:
      gc_msgid TYPE symsgid VALUE 'ZRPSG_ERROR_MESSAGES',

      BEGIN OF error_struct_create,
        msgid TYPE symsgid VALUE 'ZRPSG_AGT_MESSAGES',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF error_struct_create.

    CONSTANTS:
      BEGIN OF error_table_create,
        msgid TYPE symsgid VALUE 'ZRPSG_AGT_MESSAGES',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF error_table_create.

    CONSTANTS:
      BEGIN OF error_table_empty,
        msgid TYPE symsgid VALUE 'ZRPSG_AGT_MESSAGES',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF error_table_empty.

    CONSTANTS:
      BEGIN OF error_client_create,
        msgid TYPE symsgid VALUE 'ZRPSG_AGT_MESSAGES',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF error_client_create.

    CONSTANTS:
      BEGIN OF error_http_connect,
        msgid TYPE symsgid VALUE 'ZRPSG_AGT_MESSAGES',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'MV_ATTR1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF error_http_connect.

    CONSTANTS:
      BEGIN OF error_create_contract,
        msgid TYPE symsgid VALUE 'ZRPSG_AGT_MESSAGES',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF error_create_contract,

      BEGIN OF error_contract_field,
        msgid TYPE symsgid VALUE 'ZRPSG_AGT_MESSAGES',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'MV_ATTR1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF error_contract_field,

      BEGIN OF delete_dependency,
        msgid TYPE symsgid VALUE 'ZRPSG_AGT_MESSAGES',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE 'MV_ATTR1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF delete_dependency.

    METHODS constructor
      IMPORTING
        i_textid        LIKE if_t100_message=>t100key OPTIONAL
        i_attr1         TYPE string OPTIONAL
        i_attr2         TYPE string OPTIONAL
        i_attr3         TYPE string OPTIONAL
        i_attr4         TYPE string OPTIONAL
        i_previous      LIKE previous OPTIONAL
        i_severity      TYPE if_abap_behv_message=>t_severity OPTIONAL.

    DATA:
      mv_attr1 TYPE string,
      mv_attr2 TYPE string,
      mv_attr3 TYPE string,
      mv_attr4 TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZRPSG_CX_ERROR_MESSAGES IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( previous = i_previous ) .

    me->mv_attr1 = i_attr1.
    me->mv_attr2 = i_attr2.
    me->mv_attr3 = i_attr3.
    me->mv_attr4 = i_attr4.

    if_abap_behv_message~m_severity = i_severity.

    CLEAR me->textid.
    IF i_textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = i_textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
