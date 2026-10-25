*** Settings ***
Resource      ../common/BasePage.resource
Variables     locators.${PLATFORM}.yaml

*** Keywords ***
Navigate To Orders Tab
    Click Element Safe    ${ORDERS_TAB}

Verify Orders Screen Displayed
    Wait For Element    ${ORDERS_TAB}

Verify Empty Orders Displayed
    Wait For Element    ${EMPTY_ORDERS_TEXT}

Create Order For Book
    [Arguments]    ${book_id}    ${customer_name}
    Click Element Safe    accessibility_id=book_card_${book_id}
    Input Text Safe    ${CUSTOMER_NAME_INPUT}    ${customer_name}
    Click Element Safe    ${CREATE_ORDER_BUTTON}
    Wait For Element    accessibility_id=book_filter

Verify Order Card Exists
    [Arguments]    ${order_id}
    Wait For Element    accessibility_id=order_card_${order_id}

Get First Order Id
    ${cards}=    Get Webelements    xpath=//android.view.ViewGroup[contains(@content-desc,'order_card_')]
    Should Not Be Empty    ${cards}    msg=No orders found
    ${desc}=    Get Element Attribute    ${cards}[0]    content-desc
    ${order_id}=    Evaluate    '${desc}'.replace('order_card_', '')
    RETURN    ${order_id}
