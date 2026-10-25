*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://automate-test.stpb-digital.com/  
${BROWSER}    chrome

*** Test Cases ***
Open Example Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

    Wait Until Page Contains Element    xpath=//h5[contains(., 'Welcome')]    15s

    Element Should Be Visible    xpath=//h5[contains(., 'Welcome')]
    Element Should Contain       xpath=//h5[contains(., 'Welcome')]    Welcome to Kru P

    Capture Page Screenshot

Test openbrowser
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    
    Input Text    id=email    user.test@krupbeam.com
    Input Text    name=password    jKNsrapwLNV7eBN

    Capture Page Screenshot
