CLASS lhc_ZRPSG_I_VS_AM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrpsg_i_vs_am RESULT result.

ENDCLASS.

CLASS lhc_ZRPSG_I_VS_AM IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
