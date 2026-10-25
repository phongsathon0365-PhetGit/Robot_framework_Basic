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
# Locator ของหัวข้อหน้า Login และข้อความ validation
${WELCOME_MESSAGE}    xpath=//h5[contains(., "Welcome to Kru P' Beam")]
${EMAIL_REQUIRED_MESSAGE}    xpath=//p[contains(., 'email is a required field')]
${EMAIL_FORMAT_VALIDATION_MESSAGE}    xpath=//p[contains(., 'email must be a valid email')]
${PASSWORD_VALIDATION_MESSAGE}    xpath=//p[contains(., 'password must be at least 5 characters')] 
${HYPERLINK_CREATE_ACCOUNT}    xpath=//p[contains(., 'Create an account')]
${LOGIN_FAILED_MESSAGE}    xpath=//p[contains(., 'Email or Password is invalid')]

*** Keywords ***
# เปิดหน้า Login และตรวจว่าองค์ประกอบหลักพร้อมใช้งาน
Open Login Page
    Open Browser    ${WEB_BASE_URL}login/    ${BROWSER}
    Maximize Browser Window
    Verify Login Page Displayed


# กรอกข้อมูลตามที่รับมา แล้วส่งแบบฟอร์มเข้าสู่ระบบ
Login With Credentials
    [Arguments]    ${email}    ${password}
    Verify Login Page Displayed
    Input Text    ${EMAIL_INPUT}    ${email}
    Input Text    ${PASSWORD_INPUT}    ${password}
    Click Element    ${LOGIN_BUTTON}

# รอให้ช่อง email, password และปุ่ม Login ปรากฏบนหน้า
Verify Login Page Displayed
    Wait Until Page Contains Element    ${WELCOME_MESSAGE}    10s
    Wait Until Page Contains Element    ${EMAIL_INPUT}    10s
    Wait Until Page Contains Element    ${PASSWORD_INPUT}    10s
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    10s
    Wait Until Page Contains Element    ${HYPERLINK_CREATE_ACCOUNT}    10s

# แสดงหน้าจอชื่อ Kru P' Beam
Verify Welcome Message Displayed
    Wait Until Page Contains Element    ${WELCOME_MESSAGE}    10s
    Page Should Contain Element    ${WELCOME_MESSAGE}    message=Welcome message should be visible

# ตรวจว่า email ที่ใช้ตัวอักษร ตัวเลข และ _ . @ ผ่านการตรวจรูปแบบ
Verify Email Format Accepted
    [Arguments]    ${email}
    Login With Credentials    ${email}    ${EMPTY}
    ${entered_email}=    Get Value    ${EMAIL_INPUT}
    Should Be Equal    ${entered_email}    ${email}
    Page Should Contain Element    ${PASSWORD_VALIDATION_MESSAGE}    message=Password validation should be shown after accepting the email format
    Page Should Not Contain Element    ${EMAIL_REQUIRED_MESSAGE}    message=Valid email format should not be rejected as missing

# ตรวจว่า email ที่ไม่มี @, ใช้อักษรไทย หรือเป็นเบอร์โทร ถูกปฏิเสธด้วยข้อความ format ไม่ถูกต้อง
Verify Invalid Email Is Rejected
    [Arguments]    ${email}
    Login With Credentials    ${email}    ${WEB_VALID_PASSWORD}
    Wait Until Page Contains Element    ${EMAIL_FORMAT_VALIDATION_MESSAGE}    10s
    Page Should Contain Element    ${EMAIL_FORMAT_VALIDATION_MESSAGE}    message=Invalid email format validation should be visible

# ตรวจสอบ password ใส่ได้มากกว่่า 5 หลัก
Verify Password Length Greater Than Five
    [Arguments]    ${email}    ${WEB_PASSWORD_LONGER_THAN_FIVE}
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Wait Until Element Is Visible    ${PASSWORD_INPUT}    10s
    Login With Credentials    ${email}    ${WEB_PASSWORD_LONGER_THAN_FIVE}
    Page Should Not Contain Element    ${PASSWORD_VALIDATION_MESSAGE}    message=Password longer than 5 characters should be accepted
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    10s

# ตรวจสอบ password ใส่ได้น้อยกว่่า 5 หลัก
Verify Password Length Less Than Five
    [Arguments]    ${email}    ${WEB_PASSWORD_LESS_THAN_FIVE}
    [Documentation]    Verify that passwords shorter than 5 characters are rejected.
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Wait Until Element Is Visible    ${PASSWORD_INPUT}    10s
    Login With Credentials    ${email}    ${WEB_PASSWORD_LESS_THAN_FIVE}
    Page Should Contain Element    ${PASSWORD_VALIDATION_MESSAGE}    message=Password shorter than 5 characters should be rejected
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    10s

# ตรวจสอบการกรอก Email และ Password ที่ไม่มีการลงทะเบียนไว้
Verify Login Failed With Unregistered Credentials
    [Arguments]    ${WEB_EMPTY_NAME_EMAIL}    ${WEB_EMPTY_NAME_PASSWORD}
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Wait Until Element Is Visible    ${PASSWORD_INPUT}    10s
    Login With Credentials    ${WEB_EMPTY_NAME_EMAIL}    ${WEB_EMPTY_NAME_PASSWORD}
    Page Should Contain Element    ${LOGIN_FAILED_MESSAGE}    message=Login should fail for unregistered credentials
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    10s


# ตรวจสอบว่าเข้าสู่ระบบไม่สำเร็จโดยไม่ใส่ email และ password
Verify Login Failed Without Email And Password
    Login With Credentials    ${EMPTY}    ${EMPTY}
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Wait Until Element Is Visible    ${PASSWORD_INPUT}    10s
    Page Should Contain Element    ${EMAIL_REQUIRED_MESSAGE}    message=Email validation message should be visible
    Page Should Contain Element    ${PASSWORD_VALIDATION_MESSAGE}    message=Password validation message should be visible
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    10s

# ตรวจสอบว่าเข้าสู่ระบบโดยไม่ใส่ email จะไม่สำเร็จ
Verify Login Failed Without Email
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Wait Until Element Is Visible    ${PASSWORD_INPUT}    10s
    Login With Credentials    ${EMPTY}    ${password}
    Page Should Contain Element    ${EMAIL_REQUIRED_MESSAGE}    message=Email validation message should be visible
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    10s

# ตรวจสอบว่าเข้าสู่ระบบโดยไม่ใส่ password จะไม่สำเร็จ
Verify Login Failed Without Password
    [Arguments]    ${email}
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Wait Until Element Is Visible    ${PASSWORD_INPUT}    10s
    Login With Credentials    ${email}    ${EMPTY}
    Page Should Contain Element    ${PASSWORD_VALIDATION_MESSAGE}    message=Password validation message should be visible
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    10s

# ตรวจสอบการกด Hyperlink Create an account
Verify Create Account Hyperlink
    Click Element    ${HYPERLINK_CREATE_ACCOUNT}
    Wait Until Location Contains    /register/    10s


# ทางลัดสำหรับเข้าสู่ระบบด้วยบัญชีที่กำหนดไว้ใน fixture
Login With Valid Credentials
    Login With Credentials    ${WEB_VALID_EMAIL}    ${WEB_VALID_PASSWORD}

# ตรวจว่าเข้าสู่ระบบสำเร็จโดยรอจน URL ไม่ใช่หน้า Login
Verify Login Succeeded
    Wait Until Location Does Not Contain    /login/    15s

# ตรวจว่าหลังล็อกอินไปถึงหน้า Home (User List) แล้ว
Verify Home Page Displayed
    Wait Until Location Contains    /user/list/    15s
    Wait Until Page Contains    Search Filters    10s

# ตรวจว่าเข้าสู่ระบบไม่สำเร็จโดยรอจนยังคงอยู่หน้า Login
Verify Login Failed
    Wait Until Location Contains    /login/    15s
