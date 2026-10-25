*** Settings ***
Resource      ../common/BasePage.resource
Variables     locators.${PLATFORM}.yaml

*** Keywords ***
Verify Books Screen Displayed
    Wait For Element    ${BOOK_FILTER}

Select Filter All
    Click Element Safe    ${FILTER_ALL}
    Wait For Element    ${BOOK_FILTER}

Select Filter Fiction
    Click Element Safe    ${FILTER_FICTION}
    Wait For Element    ${BOOK_FILTER}

Select Filter Non Fiction
    Click Element Safe    ${FILTER_NON_FICTION}
    Wait For Element    ${BOOK_FILTER}

Tap Book Card
    [Arguments]    ${book_id}
    Click Element Safe    accessibility_id=book_card_${book_id}

Verify Book Detail Displayed
    Wait For Element    ${BOOK_NAME}
    Wait For Element    ${BOOK_TYPE}
    Wait For Element    ${BOOK_STATUS}

Get Book Status
    ${status}=    Get Text Safe    ${BOOK_STATUS}
    RETURN    ${status}

Verify Books List Not Empty
    ${cards}=    Get Webelements    xpath=//android.view.ViewGroup[contains(@content-desc,'book_card_')]
    Should Not Be Empty    ${cards}
