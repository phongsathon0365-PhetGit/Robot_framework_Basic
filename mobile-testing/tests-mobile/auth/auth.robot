*** Settings ***
Documentation    [PBI-001] User Authentication Feature
...              Test suite for Register, Login with Token, Toggle mode, and Logout
Resource         ../../pages/auth/AuthPage.resource
Resource         ../../pages/common/BasePage.resource
Variables        ../../fixtures/testdata.${ENV}.${PLATFORM}.yaml
Variables        ../../pages/auth/locators.${PLATFORM}.yaml

Suite Setup      Setup Mobile Test
Suite Teardown   Teardown Mobile Test
Test Teardown    Run Keyword If Test Failed    Capture Page Screenshot

*** Variables ***
# กำหนดค่า Default ไว้ (เผื่อลืมใส่ตอนรัน)
${PLATFORM}    android
${ENV}         local
${HEADLESS}    false

*** Test Cases ***
[TC-001] User Should Register Successfully With Valid Email And Name
    [Documentation]    Register with valid email and name → navigate to HomeScreen
    [Tags]    Feature:Auth    Important:Critical    Scenario:Success
    [Teardown]    Logout
    # 📝 Arrange
    ${email}=    Set Variable    ${USERS.valid.email}
    ${name}=     Set Variable    ${USERS.valid.name}
    # 🎬 Act
    Verify Register Page Displayed
    Register With Credentials    ${email}    ${name}
    # ✅ Assert
    Verify Home Screen Displayed

[TC-002] User Should See Error When Register With Duplicate Email
    [Documentation]    Register with already-used email → error snackbar displayed
    [Tags]    Feature:Auth    Important:High    Scenario:Alternative
    # 🎬 Act
    Verify Register Page Displayed
    Register With Credentials    ${USERS.duplicate.email}    ${USERS.duplicate.name}
    # ✅ Assert
    Wait For Element    xpath=//*[contains(@content-desc, 'register_error_message')]

[TC-003] User Should See Validation Error With Invalid Email Format
    [Documentation]    Register with non-email string → form validation error
    [Tags]    Feature:Auth    Important:High    Scenario:Alternative
    # 🎬 Act
    Verify Register Page Displayed
    Register With Credentials    ${USERS.invalid_email.email}    ${USERS.invalid_email.name}
    # ✅ Assert
    Verify Register Page Displayed

[TC-004] User Should See Validation Error With Empty Name
    [Documentation]    Register with empty name → form validation error
    [Tags]    Feature:Auth    Important:High    Scenario:Alternative
    # 🎬 Act
    Verify Register Page Displayed
    Register With Credentials    ${USERS.empty_name.email}    ${USERS.empty_name.name}
    # ✅ Assert
    Verify Register Page Displayed

[TC-005] User Should Login Successfully With Valid Token
    [Documentation]    Register → copy token from Info dialog → logout → login with token → HomeScreen
    [Tags]    Feature:Auth    Important:Critical    Scenario:Success
    [Teardown]    Logout
    # 📝 Arrange
    Register With Credentials    ${USERS.login_user.email}    ${USERS.login_user.name}
    Verify Home Screen Displayed
    ${token}=    Get Token From Info Dialog
    Logout
    # 🎬 Act
    Switch To Login Mode
    Login With Token    ${token}    use_paste=True
    # ✅ Assert
    Verify Home Screen Displayed

[TC-006] User Should See Error When Login With Invalid Token
    [Documentation]    Login with invalid token → error snackbar displayed
    [Tags]    Feature:Auth    Important:High    Scenario:Alternative
    # 🎬 Act
    Switch To Login Mode
    Login With Token    ${TOKEN.invalid}
    # ✅ Assert
    Wait For Element    xpath=//*[contains(@content-desc, 'login_error_message')]

[TC-007] User Should Logout And Return To Auth Screen
    [Documentation]    Logout from HomeScreen → AuthScreen displayed
    [Tags]    Feature:Auth    Important:Critical    Scenario:Success
    # 📝 Arrange
    Register With Credentials    ${USERS.logout_user.email}    ${USERS.logout_user.name}
    Verify Home Screen Displayed
    # 🎬 Act
    Logout
    # ✅ Assert
    Verify Auth Screen Displayed

*** Keywords ***
Setup Mobile Test
    Open Application    ${APPIUM_URL}
    ...    platformName=${PLATFORM_NAME}
    ...    platformVersion=${PLATFORM_VERSION}
    ...    deviceName=${DEVICE_NAME}
    ...    app=${APP_PATH}
    ...    automationName=${AUTOMATION_NAME}
    ...    noReset=false

Teardown Mobile Test
    Close Application
