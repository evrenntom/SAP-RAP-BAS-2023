CLASS lhc_ZRPSG_I_AM_VS_EL_Overview DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZRPSG_I_AM_VS_EL_Overview RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE ZRPSG_I_AM_VS_EL_Overview.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZRPSG_I_AM_VS_EL_Overview.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZRPSG_I_AM_VS_EL_Overview.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZRPSG_I_AM_VS_EL_Overview RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ZRPSG_I_AM_VS_EL_Overview.

ENDCLASS.

CLASS lhc_ZRPSG_I_AM_VS_EL_Overview IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZRPSG_I_AM_VS_EL_OVERVIEW DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZRPSG_I_AM_VS_EL_OVERVIEW IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
