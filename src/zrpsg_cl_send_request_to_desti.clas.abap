CLASS zrpsg_cl_send_request_to_desti DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.

    METHODS build_and_send_request
      IMPORTING iv_uri_path            TYPE string
                iv_json_payload_string TYPE string
                iv_http_method         TYPE string
                iv_destination         TYPE string
      EXPORTING ev_contract_number     TYPE string
      RAISING   zrpsg_cx_error_messages.

    METHODS set_api_url
      IMPORTING iv_service_url TYPE string.

    METHODS set_request_http_method
      IMPORTING iv_request_http_method TYPE string.

  PRIVATE SECTION.
    METHODS create_destination_and_request
      IMPORTING iv_destination   TYPE string
      EXPORTING eo_http_request  TYPE REF TO if_web_http_request
                eo_http_client   TYPE REF TO if_web_http_client
                ev_return_string TYPE string
      RAISING   zrpsg_cx_error_messages.

    METHODS create_or_update_coco_in_desti " create or update condition contract in destination
      IMPORTING io_http_request    TYPE REF TO if_web_http_request
                io_http_client     TYPE REF TO if_web_http_client
      EXPORTING ev_contract_number TYPE string
      RAISING   zrpsg_cx_error_messages.

    DATA mv_service_url TYPE string.
    DATA mv_request_http_method TYPE string. " POST or PATCH
    DATA ms_api_scheme_contract TYPE zrpsg_st_am_contract.
    DATA mv_contract_json_string TYPE string.

ENDCLASS.



CLASS ZRPSG_CL_SEND_REQUEST_TO_DESTI IMPLEMENTATION.

  METHOD constructor.
    mv_service_url = zif_import_tool_constants=>mc_service_url_cc.
  ENDMETHOD.

  METHOD build_and_send_request.

    mv_contract_json_string = iv_json_payload_string.
    mv_request_http_method = iv_http_method.

    create_destination_and_request( EXPORTING
                                     iv_destination = iv_destination
                                    IMPORTING
                                     eo_http_client = DATA(lo_http_client)
                                     eo_http_request = DATA(lo_http_request)
                                     ev_return_string = DATA(lv_dest_return_text)
                                   ).

    " 5 . Execute POST or PATCH Request
    create_or_update_coco_in_desti( EXPORTING
                                        io_http_client = lo_http_client
                                        io_http_request = lo_http_request
                                    IMPORTING
                                        ev_contract_number = ev_contract_number ).

  ENDMETHOD.

  METHOD set_request_http_method.
    " Doesn't has to be called - is automatically called
    mv_request_http_method = iv_request_http_method.
  ENDMETHOD.


  METHOD create_destination_and_request.
    DATA lv_uri_path TYPE string.
    DATA lv_service_name_addon TYPE string.
    DATA lv_string_offset TYPE i.
    DATA lv_destination TYPE string.

    TRY.

        lv_destination = iv_destination.

        " 1. HTTP-Destination
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination( i_name = lv_destination ). " instance name: zif_import_tool_constants=>mc_destination_service

        " 2. HTTP-Client
        eo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        " 3. HTTP-Header-Fields
        eo_http_request = eo_http_client->get_http_request( ).

        eo_http_request->set_header_fields( VALUE #( ( name = 'Content-Type' value = 'application/json' )
                                                     ( name = 'Accept' value = 'application/json' )
                                                     ( name = 'x-csrf-token' value = 'Fetch' )
                                                     ( name = 'Accept-Encoding' value = 'gzip, deflate, br' ) ) ).

        lv_uri_path = zif_import_tool_constants=>mc_service_url_cc.

        eo_http_request->set_uri_path( i_uri_path = lv_uri_path ).

        " 4. GET first to get the x-csrf-token
        DATA(lo_get_http_response) = eo_http_client->execute( if_web_http_client=>get ).

        DATA(lv_x_csrf_token) = lo_get_http_response->get_header_field( i_name = 'x-csrf-token' ).

        " 5. Building the POST Request
        eo_http_request->set_header_fields( VALUE #( ( name = 'x-csrf-token' value = lv_x_csrf_token ) ) ).
      CATCH cx_http_dest_provider_error
            cx_web_http_client_error
            cx_web_message_error
             INTO DATA(l_error).

        ev_return_string = l_error->get_text( ).

        RAISE EXCEPTION TYPE zrpsg_cx_error_messages
          EXPORTING
            i_textid   = zrpsg_cx_error_messages=>error_http_connect
            i_severity = if_abap_behv_message=>severity-error.

    ENDTRY.
  ENDMETHOD.


  METHOD create_or_update_coco_in_desti.
    " Sends request to the chosen destination (in current coding every time DSY)

    DATA lv_post_string TYPE string.
    DATA l_is_error TYPE abap_boolean. " is error or success?
*    DATA lt_contracttab TYPE TABLE OF ztab_contract.
*    DATA lt_errortab TYPE TABLE OF ztab_error.
    DATA lr_data    TYPE REF TO data.
    DATA ls_created TYPE ztab_it_created.
    DATA ls_crea_err TYPE ztab_it_crea_err.

    FIELD-SYMBOLS <ls_data>     TYPE data.
    FIELD-SYMBOLS <results>     TYPE any.
    FIELD-SYMBOLS <structure>   TYPE any.
    FIELD-SYMBOLS <table>       TYPE ANY TABLE.
    FIELD-SYMBOLS <l_field>     TYPE any.
    FIELD-SYMBOLS <field_value> TYPE data.

    l_is_error = abap_false.

    TRY.
        " 1.) - - - Create contract and get the response - - -
        lv_post_string = mv_contract_json_string.

        io_http_request->set_text( i_text = lv_post_string ).

        IF mv_request_http_method EQ 'POST'.
          DATA(lo_post_http_response) = io_http_client->execute( if_web_http_client=>post ).
        ELSEIF mv_request_http_method EQ 'PATCH'.
          lo_post_http_response = io_http_client->execute( if_web_http_client=>patch ).
        ENDIF.

        DATA(l_return_text) = lo_post_http_response->get_text(  ).

        " 2.) - - - Deserialize into internal table and fill structure- - -
        "     - - - and fill tables with everything that was created and the error messages - - -
        /ui2/cl_json=>deserialize( EXPORTING json = l_return_text
                                   CHANGING data = lr_data ).

        IF lr_data IS BOUND.

          ASSIGN lr_data->* TO <ls_data>.
          ASSIGN COMPONENT `ERROR` OF STRUCTURE <ls_data> TO <l_field>.
          IF <l_field> IS ASSIGNED.
            ASSIGN <l_field>->* TO <ls_data>.
            ASSIGN COMPONENT `MESSAGE` OF STRUCTURE <ls_data> TO <l_field>.
            IF <l_field> IS ASSIGNED.
              ASSIGN <l_field>->* TO <field_value>.
              ls_crea_err-error_text = <field_value>.
            ENDIF.
            l_is_error = abap_true.
          ENDIF.
          UNASSIGN: <l_field>, <field_value>.

          IF l_is_error = abap_true.
            RAISE EXCEPTION TYPE zrpsg_cx_error_messages
              EXPORTING
                i_textid = zrpsg_cx_error_messages=>error_create_contract.
          ELSE.

            ASSIGN lr_data->* TO <ls_data>.
            ASSIGN COMPONENT `CONDITIONCONTRACT` OF STRUCTURE <ls_data> TO <l_field>.
            IF <l_field> IS ASSIGNED.
              ASSIGN <l_field>->* TO <field_value>.
              ev_contract_number = <field_value>.
            ENDIF.
            UNASSIGN: <l_field>, <field_value>.

          ENDIF.
        ENDIF.

      CATCH cx_web_http_client_error INTO DATA(lo_error).

        RAISE EXCEPTION TYPE zrpsg_cx_error_messages
          EXPORTING
            i_textid   = zrpsg_cx_error_messages=>error_client_create
            i_severity = if_abap_behv_message=>severity-error.

    ENDTRY.
  ENDMETHOD.

  METHOD set_api_url.
    " Doesn't has to be called - is automatically called
    mv_service_url = iv_service_url.
  ENDMETHOD.
ENDCLASS.
