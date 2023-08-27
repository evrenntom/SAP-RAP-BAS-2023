CLASS lhc_ZRPSG_I_USER_SETTINGS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrpsg_i_user_settings RESULT result.

ENDCLASS.

CLASS lhc_ZRPSG_I_USER_SETTINGS IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
