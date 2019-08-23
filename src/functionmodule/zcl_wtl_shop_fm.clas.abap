class ZCL_WTL_SHOP_FM definition
  public
  final
  create public .

public section.

  interfaces ZIF_WTC_SHOP .

  methods CONSTRUCTOR .
PROTECTED SECTION.
  PRIVATE SECTION.

    DATA:
      m_cart    TYPE REF TO ZCL_WTL_SHOP_CART,
      m_catalog TYPE REF TO ZCL_WTL_SHOP_CATALOG,
      m_rebate TYPE REF TO zcl_wtl_rebate_engine.
    METHODS build_new_empty_cart.

ENDCLASS.



CLASS ZCL_WTL_SHOP_FM IMPLEMENTATION.


  METHOD BUILD_NEW_EMPTY_CART.
    m_cart = NEW ZCL_WTL_SHOP_CART( ).
    "TODO: instantiate the rebate engine and set reference to it here
    m_rebate = NEW zcl_wtl_rebate_engine(
*        i_rules =
    ).
  ENDMETHOD.


  METHOD CONSTRUCTOR.
    m_catalog = NEW ZCL_WTL_SHOP_CATALOG( ).
    build_new_empty_cart( ).
  ENDMETHOD.


  METHOD ZIF_WTC_SHOP~ADD_ITEM_TO_CART.
    m_cart->add_item( m_catalog->get_item( i_id ) ).
  ENDMETHOD.


  METHOD ZIF_WTC_SHOP~BUY_CART.
    DATA(payment_processor) = NEW ZCL_WTL_SHOP_PAYMENTPROCESSOR( ).
    rv_success = payment_processor->pay(
        i_email_sender = NEW ZCL_WTL_SHOP_EMAIL_SENDER( )
        i_value        = zif_wtc_shop~get_final_price( )
    ).
    IF rv_success = abap_true.
      build_new_empty_cart( ).
    ENDIF.
  ENDMETHOD.


  METHOD ZIF_WTC_SHOP~GET_CART.
    r_cart = m_cart->get_cart( ).
  ENDMETHOD.


  METHOD ZIF_WTC_SHOP~GET_CATALOG.
    r_catalog = m_catalog->get_catalog( ).
  ENDMETHOD.


  METHOD ZIF_WTC_SHOP~GET_FINAL_PRICE.
    "TODO: should also subtract the rebate amount
    r_result = zif_wtc_shop~get_total_price( ) -
               zif_wtc_shop~get_global_rebate( ).

  ENDMETHOD.


  METHOD ZIF_WTC_SHOP~GET_GLOBAL_REBATE.
    "TODO: return the global rebate
*    r_global_rebate =
  ENDMETHOD.


  METHOD ZIF_WTC_SHOP~GET_GLOBAL_REBATE_REASON.
    "TODO: return the global rebate reason
  ENDMETHOD.


  METHOD ZIF_WTC_SHOP~GET_NAMES_OF_ACTIVE_RULES.

  ENDMETHOD.


  METHOD ZIF_WTC_SHOP~GET_TOTAL_PRICE.
    r_total_price = m_cart->get_standard_total( ).
  ENDMETHOD.


  METHOD ZIF_WTC_SHOP~REMOVE_ITEM_FROM_CART.
    m_cart->remove_item( i_cart_item ).
  ENDMETHOD.
ENDCLASS.
