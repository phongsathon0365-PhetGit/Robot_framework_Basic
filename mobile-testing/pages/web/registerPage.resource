*** Settings ***
# SeleniumLibrary ใช้ควบคุม browser ผ่าน Selenium WebDriver
Library      SeleniumLibrary
# ข้อมูล URL และบัญชีทดสอบที่ใช้กับหน้าเว็บ
Resource     ../../fixtures/testdata.web.resource
# Locator ของช่องกรอกข้อมูลและปุ่มบนหน้า Login
Variables    locators.yaml

*** Variables ***
# Browser ที่เปิดเมื่อเรียก Open Login Page
${BROWSER}    chrome

${REGISTER_URL}    ${WEB_BASE_URL}register/
${HYPERLINK_CREATE_ACCOUNT}    xpath=//a[normalize-space(.)='Create an account']
${WELCOME_MESSAGE}    xpath=//h6[contains(., "Kru P")]
${RESET_BUTTON}    xpath=//a[contains(., 'reset')]
${first_name_input}    xpath=//input[@id='firstname']
${last_name_input}    xpath=//input[@id='lastname']
${EMAIL_INPUT}    xpath=//input[@id='email']
${PASSWORD_INPUT}    xpath=//input[@id='password']
${MOBILE_PHONE_INPUT}    xpath=//input[@id='mobile-phone']
${GENDER_GROUP}    validation-basic-radio
${FEMALE_RADIO}    xpath=//input[@type='radio' and @value='female']
${MALE_RADIO}    xpath=//input[@type='radio' and @value='male']
${COURSES_SQL_CHECKBOX}    xpath=//input[@name='courses.SQL']
${COURSES_TEST_MANUAL_CHECKBOX}    xpath=//input[@name='courses.Test Manual']
${COURSES_AUTOMATE_TEST_CHECKBOX}    xpath=//input[@name='courses.Automate Test']
${COURSES_AUTOMATE_TEST2_CHECKBOX}    xpath=//input[@name='courses.Automate Test2']
${NATIONALITY_SELECT}    xpath=//div[contains(@class, 'MuiSelect-select') and @id='nationality']
${ROLE_SELECT}    xpath=//div[contains(@class, 'MuiSelect-select') and @id='select-role']
${PLAN_SELECT}    xpath=//div[contains(@class, 'MuiSelect-select') and @id='select-plan']
${PLAN_VALIDATION_ERROR}    xpath=//p[@id='validation-plan']
${REGISTER_BUTTON}    xpath=//button[@id='btn-sign-up']

*** Keywords ***
Open Register Page
    Open Browser    ${WEB_BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${HYPERLINK_CREATE_ACCOUNT}    10s
    Scroll Element Into View    ${HYPERLINK_CREATE_ACCOUNT}
    Click Element    ${HYPERLINK_CREATE_ACCOUNT}
    Wait Until Location Is    ${REGISTER_URL}    10s
    Verify Register Page Displayed

# รอให้ช่อง email, password และปุ่ม Register ปรากฏบนหน้า
Verify Register Page Displayed
    Wait Until Page Contains Element    ${WELCOME_MESSAGE}    10s
    Wait Until Page Contains Element    ${RESET_BUTTON}    10s
    Wait Until Page Contains Element    ${EMAIL_INPUT}    10s
    Wait Until Page Contains Element    ${PASSWORD_INPUT}    10s
    Wait Until Page Contains Element    ${MOBILE_PHONE_INPUT}    10s
    Wait Until Page Contains Element    ${FEMALE_RADIO}    10s
    Wait Until Page Contains Element    ${MALE_RADIO}    10s
    Wait Until Page Contains Element    ${COURSES_SQL_CHECKBOX}    10s
    Wait Until Page Contains Element    ${COURSES_TEST_MANUAL_CHECKBOX}    10s
    Wait Until Page Contains Element    ${COURSES_AUTOMATE_TEST_CHECKBOX}    10s
    Wait Until Page Contains Element    ${COURSES_AUTOMATE_TEST2_CHECKBOX}    10s
    Wait Until Page Contains Element    ${NATIONALITY_SELECT}    10s
    Wait Until Page Contains Element    ${ROLE_SELECT}    10s
    Wait Until Page Contains Element    ${PLAN_SELECT}    10s
    Wait Until Page Contains Element    ${REGISTER_BUTTON}    10s

Verify Page Title
    Open Register Page
    Wait Until Page Contains Element    ${WELCOME_MESSAGE}    10s

Verify Click Reset Hyperlink
    Open Register Page
    Click Element    ${RESET_BUTTON}
    sleep    1s

Verify Firstname input field
    Open Register Page
    Wait Until Page Contains Element    ${first_name_input}    10s
    Click Element    ${first_name_input}
    Input Text    ${first_name_input}    ${WEB_FIRSTNAME}
    Click Button    ${REGISTER_BUTTON}

Verify Firstname not input field
    Open Register Page
    Wait Until Page Contains Element    ${first_name_input}    10s
    Click Button    ${REGISTER_BUTTON}    

Verify Lastname input field
    Open Register Page
    Wait Until Page Contains Element    ${last_name_input}    10s
    Click Element    ${last_name_input}
    Input Text    ${last_name_input}    ${WEB_LASTNAME}
    Click Button    ${REGISTER_BUTTON}

Verify Lastname not input field
    Open Register Page
    Wait Until Page Contains Element    ${last_name_input}    10s
    Click Button    ${REGISTER_BUTTON}
    
# ตรวจสอบการกรอกข้อมูลในรูปแบบ Format Name@gmail.com และกรอกข้อมูลเป็นภาษาอังกฤษ ตัวเลข และอักขระพิเศษ ดังนี้ _ . @ 
Verify Email input field
    Open Register Page
    Wait Until Page Contains Element    ${EMAIL_INPUT}    10s
    Click Element    ${EMAIL_INPUT}
    Input Text    ${EMAIL_INPUT}    ${WEB_EMAIL}
    Click Button    ${REGISTER_BUTTON}
    
# ตรวจสอบการกรอกข้อมูลที่ไม่ใช่ภาษาอังกฤษ ตัวเลข และไม่อยู่ในรูปแบบ Format Name@gmail.com
Verify Email invalid input field
    [Arguments]    ${email}
    Open Register Page
    Wait Until Page Contains Element    ${EMAIL_INPUT}    10s
    Click Element    ${EMAIL_INPUT}
    Input Text    ${EMAIL_INPUT}    ${email}
    Click Button    ${REGISTER_BUTTON}

Verify Email not input field
    Open Register Page
    Wait Until Page Contains Element    ${EMAIL_INPUT}    10s
    Click Button    ${REGISTER_BUTTON}

Verify Password input field
    Open Register Page
    Wait Until Page Contains Element    ${PASSWORD_INPUT}    10s
    Click Element    ${PASSWORD_INPUT}
    Input Text    ${PASSWORD_INPUT}    ${WEB_PASSWORD}
    Click Button    ${REGISTER_BUTTON}

Verify Password not input field
    Open Register Page
    Wait Until Page Contains Element    ${PASSWORD_INPUT}    10s
    Click Button    ${REGISTER_BUTTON}

Verify Mobile Phone input field
    Open Register Page
    Wait Until Page Contains Element    ${MOBILE_PHONE_INPUT}    10s
    Click Element    ${MOBILE_PHONE_INPUT}
    Input Text    ${MOBILE_PHONE_INPUT}    ${WEB_MOBILE_PHONE}
    Click Button    ${REGISTER_BUTTON}

Verify Mobile Phone not input field
    Open Register Page
    Wait Until Page Contains Element    ${MOBILE_PHONE_INPUT}    10s
    Click Button    ${REGISTER_BUTTON}

Verify Gender radio buttons
    Open Register Page
    Wait Until Page Contains Element    ${FEMALE_RADIO}    10s
    Wait Until Page Contains Element    ${MALE_RADIO}      10s
    Select Radio Button    ${GENDER_GROUP}    female
    Radio Button Should Be Set To    ${GENDER_GROUP}    female
    Select Radio Button    ${GENDER_GROUP}    male
    Radio Button Should Be Set To    ${GENDER_GROUP}    male
    Select Radio Button    ${GENDER_GROUP}    male
    ${checked}=    Execute JavaScript    return document.querySelector('input[name="validation-basic-radio"][value="female"]').checked;
    Should Be Equal    ${checked}    ${False}
    Click Button    ${REGISTER_BUTTON}

Verify Checkbox SQL
    Open Register Page
    Wait Until Page Contains Element    ${COURSES_SQL_CHECKBOX}    10s
    Click Element    ${COURSES_SQL_CHECKBOX}
    Click Button    ${REGISTER_BUTTON}

Verify Checkbox Manual
    Open Register Page
    Wait Until Page Contains Element    ${COURSES_TEST_MANUAL_CHECKBOX}    10s
    Click Element    ${COURSES_TEST_MANUAL_CHECKBOX}
    Click Button    ${REGISTER_BUTTON}

Verify Checkbox Automate Test
    Open Register Page
    Wait Until Page Contains Element    ${COURSES_AUTOMATE_TEST_CHECKBOX}    10s
    Click Element    ${COURSES_AUTOMATE_TEST_CHECKBOX}
    Click Button    ${REGISTER_BUTTON}

Verify Checkbox Automate Test2
    Open Register Page
    Wait Until Page Contains Element    ${COURSES_AUTOMATE_TEST2_CHECKBOX}    10s
    Click Element    ${COURSES_AUTOMATE_TEST2_CHECKBOX}
    Click Button    ${REGISTER_BUTTON}

Verify Dropdown Nationlity
    [Arguments]    ${nationality}=${WEB_DROPDOWN_TH}
    Open Register Page
    Wait Until Element Is Visible    ${NATIONALITY_SELECT}    10s
    Scroll Element Into View    ${NATIONALITY_SELECT}
    Click Element    ${NATIONALITY_SELECT}
    ${OPTIONS}=    Set Variable    xpath=//*[@role='option' and normalize-space(.)="${nationality}"]
    Wait Until Element Is Visible    ${OPTIONS}    10s
    Scroll Element Into View    ${OPTIONS}
    Click Element    ${OPTIONS}
    Element Text Should Be    ${NATIONALITY_SELECT}    ${nationality}
    Scroll Element Into View    ${REGISTER_BUTTON}
    Click Button    ${REGISTER_BUTTON}
    
Verify Dropdown Role
    [Arguments]    ${role}=${WEB_DROPDOWN_ADMIN}
    Open Register Page
    Wait Until Element Is Visible    ${ROLE_SELECT}    10s
    Scroll Element Into View    ${ROLE_SELECT}
    Click Element    ${ROLE_SELECT}
    ${OPTIONS}=    Set Variable    xpath=//*[@role='option' and normalize-space(.)="${role}"]
    Wait Until Element Is Visible    ${OPTIONS}    10s
    Scroll Element Into View    ${OPTIONS}
    Click Element    ${OPTIONS}
    Element Text Should Be    ${ROLE_SELECT}    ${role}
    Scroll Element Into View    ${REGISTER_BUTTON}
    Click Button    ${REGISTER_BUTTON}

Verify Dropdown Plan
    [Arguments]    ${plan}=${WEB_DROPDOWN_BASIC}
    Open Register Page
    Wait Until Element Is Visible    ${PLAN_SELECT}    10s
    Scroll Element Into View    ${PLAN_SELECT}
    Click Element    ${PLAN_SELECT}
    ${OPTIONS}=    Set Variable    xpath=//*[@role='option' and normalize-space(.)="${plan}"]
    Wait Until Element Is Visible    ${OPTIONS}    10s
    Scroll Element Into View    ${OPTIONS}
    Click Element    ${OPTIONS}
    Element Text Should Be    ${PLAN_SELECT}    ${plan}
    Scroll Element Into View    ${REGISTER_BUTTON}
    Click Button    ${REGISTER_BUTTON}

# ตรวจสอบการกรอกข้อมูลถูกต้องครบถ้วน
Verify Checkbox All
    Open Register Page
    Verify Firstname input field
    Verify Lastname input field
    Verify Email input field
    Verify Mobile Phone input field
    Verify Password input field
    Verify Mobile Phone input field
    Verify Gender radio buttons
    Verify Checkbox SQL
    Verify Checkbox Manual
    Verify Checkbox Automate Test
    Verify Checkbox Automate Test2
    Verify Dropdown Nationlity
    Verify Dropdown Role
    Verify Dropdown Plan
    Verify Register button is present

# ไม่ได้กรอกข้อมูล Required Field*
Verify Checkbox None
    Open Register Page
    Click Button    ${REGISTER_BUTTON}
    Wait Until Page Contains Element    ${PLAN_VALIDATION_ERROR}    10s
    Element Text Should Be    ${PLAN_VALIDATION_ERROR}    This field is required
    ${validation_count}=    Get Element Count    xpath=//p[normalize-space(.)='This field is required']
    Should Be True    ${validation_count} >= 9    Expected required-field validation messages for all mandatory fields
    Checkbox Should Not Be Selected    ${COURSES_SQL_CHECKBOX}
    Checkbox Should Not Be Selected    ${COURSES_TEST_MANUAL_CHECKBOX}
    Checkbox Should Not Be Selected    ${COURSES_AUTOMATE_TEST_CHECKBOX}
    Checkbox Should Not Be Selected    ${COURSES_AUTOMATE_TEST2_CHECKBOX}
    
Verify Register button is present
    Open Register Page
    Wait Until Page Contains Element    ${REGISTER_BUTTON}    10s
