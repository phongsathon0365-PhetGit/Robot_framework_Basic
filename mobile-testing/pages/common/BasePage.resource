*** Settings ***
Library    AppiumLibrary

*** Keywords ***
Wait For Element
    [Arguments]    ${locator}    ${timeout}=30s
    Wait Until Element Is Visible    ${locator}    ${timeout}

Click Element Safe
    [Arguments]    ${locator}
    Wait For Element    ${locator}
    Click Element    ${locator}

Input Text Safe
    [Arguments]    ${locator}    ${text}
    Wait For Element    ${locator}
    Input Text    ${locator}    ${text}

Get Text Safe
    [Arguments]    ${locator}
    Wait For Element    ${locator}
    ${text}=    Get Text    ${locator}
    RETURN    ${text}

Swipe Up
    [Arguments]    ${start_y}=80    ${end_y}=20
    ${width}=    Get Window Width
    ${height}=    Get Window Height
    ${start_x}=    Evaluate    ${width} / 2
    ${start_y_coord}=    Evaluate    ${height} * ${start_y} / 100
    ${end_y_coord}=    Evaluate    ${height} * ${end_y} / 100
    Swipe    ${start_x}    ${start_y_coord}    ${start_x}    ${end_y_coord}    500

Swipe Down
    [Arguments]    ${start_y}=20    ${end_y}=80
    ${width}=    Get Window Width
    ${height}=    Get Window Height
    ${start_x}=    Evaluate    ${width} / 2
    ${start_y_coord}=    Evaluate    ${height} * ${start_y} / 100
    ${end_y_coord}=    Evaluate    ${height} * ${end_y} / 100
    Swipe    ${start_x}    ${start_y_coord}    ${start_x}    ${end_y_coord}    500

Scroll To Element
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    30s
    Scroll    ${locator}

Take Screenshot On Failure
    Run Keyword If Test Failed    Capture Page Screenshot

Hide Keyboard If Visible
    ${status}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//android.widget.EditText
    Run Keyword If    ${status}    Hide Keyboard
