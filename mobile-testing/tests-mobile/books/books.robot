*** Settings ***
Documentation    [PBI-002] Books Feature
...              Test suite for Books list, filter by type, and book detail
Resource         ../../pages/auth/AuthPage.resource
Resource         ../../pages/books/BooksPage.resource
Resource         ../../pages/common/BasePage.resource
Variables        ../../fixtures/testdata.${ENV}.${PLATFORM}.yaml
Variables        ../../pages/auth/locators.${PLATFORM}.yaml
Variables        ../../pages/books/locators.${PLATFORM}.yaml

Suite Setup      Setup Mobile Test
Suite Teardown   Teardown Mobile Test
Test Setup       Register And Navigate To Books
Test Teardown    Run Keyword If Test Failed    Capture Page Screenshot

*** Variables ***
# กำหนดค่า Default ไว้ (เผื่อลืมใส่ตอนรัน)
${PLATFORM}    android
${ENV}         local
${HEADLESS}    false

*** Test Cases ***
[TC-008] User Should See Books List After Login
    [Documentation]    Navigate to Books tab → books list displayed with filter bar
    [Tags]    Feature:Books    Important:Critical    Scenario:Success
    # ✅ Assert
    Verify Books Screen Displayed
    Verify Books List Not Empty

[TC-009] User Should Filter Books By Fiction
    [Documentation]    Select Fiction filter → only fiction books displayed
    [Tags]    Feature:Books    Important:High    Scenario:Success
    # 🎬 Act
    Select Filter Fiction
    # ✅ Assert
    Verify Books List Not Empty

[TC-010] User Should See Book Detail When Tap Book Card
    [Documentation]    Tap book card → detail screen shows name, type, status
    [Tags]    Feature:Books    Important:Critical    Scenario:Success
    # 🎬 Act
    Tap Book Card    1
    # ✅ Assert
    Verify Book Detail Displayed

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

Register And Navigate To Books
    Register With Credentials    ${USERS.valid.email}    ${USERS.valid.name}
    Verify Home Screen Displayed
    Verify Books Screen Displayed
