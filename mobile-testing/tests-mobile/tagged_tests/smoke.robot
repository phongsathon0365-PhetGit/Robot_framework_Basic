*** Settings ***
Documentation    Smoke Tests — critical path verification
Resource         ../../pages/auth/AuthPage.resource
Resource         ../../pages/books/BooksPage.resource
Resource         ../../pages/common/BasePage.resource
Variables        ../../fixtures/testdata.${ENV}.${PLATFORM}.yaml

*** Variables ***
# กำหนดค่า Default ไว้ (เผื่อลืมใส่ตอนรัน)
${PLATFORM}    android
${ENV}         local
${HEADLESS}    false

Suite Setup       Setup Mobile Test
Suite Teardown    Teardown Mobile Test
Test Teardown     Run Keyword If Test Failed    Capture Page Screenshot

*** Test Cases ***
Smoke Test - Register And Access Home
    [Tags]    smoke    critical
    Verify Register Page Displayed
    Register With Credentials    ${USERS.valid.email}    ${USERS.valid.name}
    Verify Home Screen Displayed

Smoke Test - Books List Accessible
    [Tags]    smoke    critical
    Register With Credentials    ${USERS.valid.email}    ${USERS.valid.name}
    Verify Home Screen Displayed
    Verify Books Screen Displayed
    Verify Books List Not Empty

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
