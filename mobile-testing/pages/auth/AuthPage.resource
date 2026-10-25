*** Settings ***
Resource      ../common/BasePage.resource
Variables     locators.${PLATFORM}.yaml

*** Keywords ***
Verify Register Page Displayed
    Wait For Element    ${EMAIL_INPUT}
    Wait For Element    ${NAME_INPUT}
    Wait For Element    ${REGISTER_BUTTON}

Verify Login Page Displayed
    Wait For Element    ${TOKEN_INPUT}
    Wait For Element    ${LOGIN_BUTTON}

Switch To Login Mode
    Click Element Safe    ${TOGGLE_MODE_BUTTON}
    Wait For Element    ${TOKEN_INPUT}

Switch To Register Mode
    Click Element Safe    ${TOGGLE_MODE_BUTTON}
    Wait For Element    ${EMAIL_INPUT}

Register With Credentials
    [Arguments]    ${email}    ${name}
    Verify Register Page Displayed
    Click Element Safe    ${EMAIL_INPUT}
    Input Text Safe    ${EMAIL_INPUT}    ${email}
    Click Element Safe    ${NAME_INPUT}
    Input Text Safe    ${NAME_INPUT}    ${name}
    Click Element Safe    ${REGISTER_BUTTON}

Login With Token
    [Arguments]    ${token}    ${use_paste}=False
    Verify Login Page Displayed
    Run Keyword If    '${use_paste}' == 'True'    Click Element Safe    ${PASTE_TOKEN_BUTTON}
    ...    ELSE    Input Text Safe    ${TOKEN_INPUT}    ${token}
    Click Element Safe    ${LOGIN_BUTTON}

Verify Home Screen Displayed
    Wait For Element    ${BOTTOM_NAV}

Verify Auth Screen Displayed
    Wait For Element    ${TOGGLE_MODE_BUTTON}

Logout
    Click Element Safe    ${LOGOUT_BUTTON}
    Verify Auth Screen Displayed

Get Token From Info Dialog
    Click Element Safe    ${INFO_BUTTON}
    Click Element Safe    ${COPY_TOKEN_BUTTON}
    ${token}=    Execute Script    mobile: getClipboard
    Click Element Safe    ${CLOSE_DIALOG_BUTTON}
    RETURN    ${token}
